import Foundation

/// Taper calculation result containing all derived dimensions.
public struct TaperResult: Sendable {
    /// Taper per inch (dimensionless ratio).
    public let tpi: Double

    /// Taper per foot (in/ft).
    public let tpf: Double

    /// Half angle of the taper in degrees.
    public let halfAngleDeg: Double

    /// Included angle of the taper in degrees (2 × halfAngleDeg).
    public let includedAngleDeg: Double

    /// Tailstock setover for full-length taper.
    public let setover: Double

    /// Tailstock setover for partial taper between centers (nil if betweenCentersIn ≤ 0).
    public let setoverBetweenCenters: Double?

    public init(tpi: Double, tpf: Double, halfAngleDeg: Double,
                includedAngleDeg: Double, setover: Double,
                setoverBetweenCenters: Double?) {
        self.tpi = tpi
        self.tpf = tpf
        self.halfAngleDeg = halfAngleDeg
        self.includedAngleDeg = includedAngleDeg
        self.setover = setover
        self.setoverBetweenCenters = setoverBetweenCenters
    }
}

/// Calculate taper dimensions from diameter and length measurements.
///
/// - Parameters:
///   - largeDiaIn: Large diameter (inches)
///   - smallDiaIn: Small diameter (inches)
///   - lengthIn: Length of taper (inches)
///   - betweenCentersIn: Distance between centers for partial taper (inches); 0 or negative means no between-centers calculation
///
/// - Returns: TaperResult containing all derived taper dimensions, or nil if lengthIn ≤ 0
///
/// Formulas:
/// - tpi = (D - d) / L
/// - tpf = tpi × 12
/// - halfAngleDeg = atan(tpi / 2) × (180 / π)
/// - includedAngleDeg = halfAngleDeg × 2
/// - setover = (D - d) / 2
/// - setoverBetweenCenters = lbc > 0 ? lbc × (D - d) / (2 × L) : nil
public func taper(largeDiaIn D: Double, smallDiaIn d: Double,
                  lengthIn L: Double, betweenCentersIn lbc: Double) -> TaperResult? {
    // Return nil if length is zero or negative
    guard L > 0 else { return nil }

    let diaDiff = D - d

    // Calculate taper per inch
    let tpi = diaDiff / L

    // Calculate taper per foot
    let tpf = tpi * 12

    // Calculate half angle in degrees
    let halfAngleRad = atan(tpi / 2)
    let halfAngleDeg = halfAngleRad * (180 / Double.pi)

    // Calculate included angle
    let includedAngleDeg = halfAngleDeg * 2

    // Calculate setover for full-length taper
    let setover = diaDiff / 2

    // Calculate setover for between-centers taper (if lbc > 0)
    let setoverBetweenCenters: Double?
    if lbc > 0 {
        setoverBetweenCenters = lbc * diaDiff / (2 * L)
    } else {
        setoverBetweenCenters = nil
    }

    return TaperResult(
        tpi: tpi,
        tpf: tpf,
        halfAngleDeg: halfAngleDeg,
        includedAngleDeg: includedAngleDeg,
        setover: setover,
        setoverBetweenCenters: setoverBetweenCenters
    )
}
