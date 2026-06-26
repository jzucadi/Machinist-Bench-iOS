import Foundation

// MARK: - Thread Geometry

public struct ThreadGeometry: Sendable {
    public let heightExt: Double
    public let pitchDia: Double
    public let minorExt: Double
    public let compound: Double
}

/// Compute 60° unified thread geometry from major diameter and pitch (both in inches).
public func threadGeometry(majorIn: Double, pitchIn: Double) -> ThreadGeometry {
    let h = 0.6134 * pitchIn
    let pd = majorIn - 0.6495 * pitchIn
    let minor = majorIn - 2 * h
    let comp = h / cos(29.5 * .pi / 180)
    return ThreadGeometry(heightExt: h, pitchDia: pd, minorExt: minor, compound: comp)
}

// MARK: - Speed

/// Threading RPM from surface feet per minute and workpiece OD (inches). Returns nil if OD ≤ 0.
public func threadingRPM(sfm: Double, workpieceODIn: Double) -> Double? {
    guard workpieceODIn > 0 else { return nil }
    return sfm * 12 / (.pi * workpieceODIn)
}

/// Recommended threading SFM: 65 % of the midpoint of the turning range for the given tool.
public func recommendedThreadSFM(material: Material, tool: Tool) -> Int {
    let range = tool == .hss ? material.hssSFM : material.carbideSFM
    let midpoint = (Double(range.lowerBound) + Double(range.upperBound)) / 2.0
    return Int((midpoint * 0.65).rounded())
}

// MARK: - Constant-Area Infeed Schedule

/// Per-pass compound infeed depths using a constant-area (√n/N) schedule.
/// Length of returned array equals `passes`; values sum to `heightExt`.
public func threadingInfeeds(heightExt: Double, passes: Int) -> [Double] {
    guard passes > 0 else { return [] }
    let n = Double(passes)
    var result = [Double]()
    result.reserveCapacity(passes)
    for i in 1...passes {
        let cumCurrent = heightExt * sqrt(Double(i) / n)
        let cumPrev    = i > 1 ? heightExt * sqrt(Double(i - 1) / n) : 0.0
        result.append(cumCurrent - cumPrev)
    }
    return result
}
