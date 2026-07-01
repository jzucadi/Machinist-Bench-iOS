import Foundation

// MARK: - FitKind

/// ISO 286 hole-basis fit classes.
public enum FitKind: String, Sendable {
    /// Sliding fit H7/g6 — close running, locates accurately, slides freely.
    case h7g6  = "H7g6"
    /// Locational fit H7/h6 — snug hand-assembly, no perceptible play.
    case h7h6  = "H7h6"
    /// Transition fit H7/k6 — light press / keyed, slight interference possible.
    case h7k6  = "H7k6"
    /// Press fit H7/p6 — interference, permanent or arbor-press assembly.
    case h7p6  = "H7p6"
    /// Loose fit H11/c11 — wide clearance, rough or dirty conditions.
    case h11c11 = "H11c11"
}

// MARK: - FitResult

/// Computed ISO 286 fit limits for a given nominal size.
/// All values in inches. Positive = above zero line; negative = below.
public struct FitResult: Sendable {
    /// Hole upper deviation (es), inches.
    public let holeEsIn: Double
    /// Hole lower deviation (ei), inches — always 0 for H-basis.
    public let holeEiIn: Double
    /// Shaft upper deviation (es), inches.
    public let shaftEsIn: Double
    /// Shaft lower deviation (ei), inches.
    public let shaftEiIn: Double
    /// Minimum clearance (negative → maximum interference), inches.
    public let minClearIn: Double
    /// Maximum clearance (negative → minimum interference), inches.
    public let maxClearIn: Double
}

// MARK: - isoFit

/// Compute ISO 286 fit limits for a nominal size.
///
/// - Parameters:
///   - sizeIn: Nominal diameter in inches (0 < sizeIn ≤ 9.84 in / 250 mm).
///   - fit: Fit class to compute.
/// - Returns: `FitResult` with hole/shaft deviations and clearance limits in inches.
public func isoFit(sizeIn: Double, fit: FitKind) -> FitResult {
    let Dmm = sizeIn * 25.4

    // Find first band where Dmm ≤ band[0] (with tiny epsilon for exact boundary)
    guard let band = ISO_BANDS.first(where: { Dmm <= $0[0] + 1e-9 }) else {
        return FitResult(holeEsIn: 0, holeEiIn: 0, shaftEsIn: 0,
                         shaftEiIn: 0, minClearIn: 0, maxClearIn: 0)
    }

    let it6  = band[1]
    let it7  = band[2]
    let it11 = band[3]
    let gEs  = band[4]
    let kEi  = band[5]
    let pEi  = band[6]

    // Determine IT grade values for hole and shaft
    let hIT: Double
    let sIT: Double
    let shaftDevLetter: Character

    switch fit {
    case .h7g6:
        hIT = it7; sIT = it6; shaftDevLetter = "g"
    case .h7h6:
        hIT = it7; sIT = it6; shaftDevLetter = "h"
    case .h7k6:
        hIT = it7; sIT = it6; shaftDevLetter = "k"
    case .h7p6:
        hIT = it7; sIT = it6; shaftDevLetter = "p"
    case .h11c11:
        hIT = it11; sIT = it11; shaftDevLetter = "c"
    }

    // Compute shaft deviations in µm
    let shaftEsMu: Double
    let shaftEiMu: Double

    switch shaftDevLetter {
    case "g":
        shaftEsMu = gEs
        shaftEiMu = gEs - sIT
    case "h":
        shaftEsMu = 0
        shaftEiMu = -sIT
    case "k":
        shaftEiMu = kEi
        shaftEsMu = kEi + sIT
    case "p":
        shaftEiMu = pEi
        shaftEsMu = pEi + sIT
    default: // "c"
        let cEs = C_ES.first(where: { Dmm <= $0[0] + 1e-9 })?[1] ?? -60
        shaftEsMu = cEs
        shaftEiMu = cEs - sIT
    }

    // Hole is always H-basis: ei = 0, es = hIT
    let holeEiMu: Double = 0
    let holeEsMu: Double = hIT

    // Convert µm → inches (÷ 25400)
    let holeEsIn  = holeEsMu  / 25400
    let holeEiIn  = holeEiMu  / 25400
    let shaftEsIn = shaftEsMu / 25400
    let shaftEiIn = shaftEiMu / 25400

    // Clearance: positive = clearance, negative = interference
    let minClearIn = holeEiIn - shaftEsIn
    let maxClearIn = holeEsIn - shaftEiIn

    return FitResult(
        holeEsIn:   holeEsIn,
        holeEiIn:   holeEiIn,
        shaftEsIn:  shaftEsIn,
        shaftEiIn:  shaftEiIn,
        minClearIn: minClearIn,
        maxClearIn: maxClearIn
    )
}

// MARK: - shrinkFitTemp

/// Compute the temperature change required to assemble an interference fit.
///
/// Uses a fixed 0.0005 in slip clearance added to the stated interference.
///
/// - Parameters:
///   - materialKey: CTE table key (e.g. `"lowc"`, `"alum"`, `"steel"`).
///   - interferenceIn: Diametral interference in inches.
///   - diaIn: Nominal diameter in inches.
///   - heatHub: `true` to heat the outer part; `false` to cool the shaft.
/// - Returns: Tuple of temperature delta and target temperatures in °F and °C.
public func shrinkFitTemp(
    materialKey: String,
    interferenceIn: Double,
    diaIn: Double,
    heatHub: Bool
) -> (deltaF: Double, deltaC: Double, targetF: Double, targetC: Double) {
    let slip: Double = 0.0005
    let need = interferenceIn + slip

    let alphaC = (CTE[materialKey] ?? 12) * 1e-6  // per °C
    let alphaF = alphaC * 5 / 9                    // per °F

    let deltaF = need / (alphaF * diaIn)
    let deltaC = deltaF * 5 / 9

    let targetF = heatHub ? 68 + deltaF : 68 - deltaF
    let targetC = heatHub ? 20 + deltaC : 20 - deltaC

    return (deltaF: deltaF, deltaC: deltaC, targetF: targetF, targetC: targetC)
}
