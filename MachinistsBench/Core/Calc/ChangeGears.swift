import Foundation

/// Specifies a screw pitch either in threads-per-inch or in millimetres.
public enum PitchSpec: Sendable {
    case tpi(Double)
    case mmPitch(Double)

    /// Returns the pitch expressed in millimetres.
    public var mm: Double {
        switch self {
        case .tpi(let v):      return 25.4 / v
        case .mmPitch(let v):  return v
        }
    }
}

/// A candidate gear train produced by the change-gear search.
public struct GearTrain: Sendable {
    /// Tooth counts in driver/driven order: 2-gear [a, b] or 4-gear [a, b, c, d].
    public let gears: [Int]
    /// Actual gear ratio produced by this train (driver product / driven product).
    public let ratio: Double
    /// Absolute percentage error vs. the required ratio.
    public let errorPct: Double

    public init(gears: [Int], ratio: Double, errorPct: Double) {
        self.gears = gears
        self.ratio = ratio
        self.errorPct = errorPct
    }
}

/// Search available change-gears for trains that approximate the required pitch ratio.
///
/// - Parameters:
///   - leadscrew: Pitch of the lathe leadscrew.
///   - target:    Desired cut pitch.
///   - available: List of available gear tooth counts (duplicates allowed for mini sets).
///   - compound:  When true, also searches 4-gear compound trains (a×c)/(b×d).
/// - Returns: A tuple of the required ratio and up to 8 candidate `GearTrain` values
///            sorted by ascending error then ascending gear count, deduplicated by ratio.
///
/// Algorithm:
///   R = target.mm / leadscrew.mm
///   2-gear:  ratio = a/b,         kept if |ratio−R|/R < 0.02
///   4-gear:  ratio = (a×c)/(b×d), kept if |ratio−R|/R < 0.02
///   Combine, sort (err asc, count asc), dedupe ratio to 6 dp, top 8.
public func changeGears(
    leadscrew: PitchSpec,
    target: PitchSpec,
    available: [Int],
    compound: Bool
) -> (requiredRatio: Double, trains: [GearTrain]) {
    let plsMm = leadscrew.mm
    let pcMm  = target.mm
    let R     = pcMm / plsMm

    guard R > 0, plsMm > 0 else {
        return (R, [])
    }

    var candidates: [GearTrain] = []
    let n = available.count

    // --- 2-gear search: a/b ---
    for i in 0 ..< n {
        let a = available[i]
        for j in 0 ..< n {
            if i == j { continue }
            let b = available[j]
            let ratio = Double(a) / Double(b)
            let err   = abs(ratio - R) / R
            if err < 0.02 {
                candidates.append(GearTrain(gears: [a, b], ratio: ratio, errorPct: err * 100))
            }
        }
    }

    // --- 4-gear compound search: (a×c)/(b×d) ---
    if compound {
        for i in 0 ..< n {
            let a = available[i]
            for j in 0 ..< n {
                if i == j { continue }
                let b = available[j]
                for k in 0 ..< n {
                    if k == i || k == j { continue }
                    let c = available[k]
                    for l in 0 ..< n {
                        if l == i || l == j || l == k { continue }
                            let d = available[l]
                            let ratio = Double(a * c) / Double(b * d)
                            let err   = abs(ratio - R) / R
                            if err < 0.02 {
                                candidates.append(GearTrain(gears: [a, b, c, d], ratio: ratio, errorPct: err * 100))
                            }
                    }
                }
            }
        }
    }

    // Sort: ascending error, then ascending gear count (prefer 2-gear over 4-gear)
    candidates.sort {
        if abs($0.errorPct - $1.errorPct) > 1e-10 { return $0.errorPct < $1.errorPct }
        return $0.gears.count < $1.gears.count
    }

    // Deduplicate by ratio rounded to 6 decimal places, keep top 8
    var seen = Set<String>()
    var unique: [GearTrain] = []
    for train in candidates {
        let key = String(format: "%.6f", train.ratio)
        if seen.insert(key).inserted {
            unique.append(train)
            if unique.count == 8 { break }
        }
    }

    return (R, unique)
}
