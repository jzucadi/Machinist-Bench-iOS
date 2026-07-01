import Foundation

/// Result of knurl calculation containing tooth count and diameter adjustments.
public struct KnurlResult: Sendable {
    /// Number of teeth around the circumference.
    public let teeth: Int

    /// Ideal diameter at which to turn the blank (inches).
    public let idealDiaIn: Double

    /// Adjustment needed: positive means reduce blank, negative means increase blank (inches).
    public let adjustIn: Double

    public init(teeth: Int, idealDiaIn: Double, adjustIn: Double) {
        self.teeth = teeth
        self.idealDiaIn = idealDiaIn
        self.adjustIn = adjustIn
    }
}

/// Calculate knurl pattern diameter and tooth count.
///
/// Given a target blank diameter and a knurl pitch, determines the number of teeth
/// that will fit around the circumference and the ideal diameter at which to turn
/// the blank to achieve proper knurl spacing.
///
/// - Parameters:
///   - diaIn: Target blank diameter (inches)
///   - pitchIn: Knurl pitch (inches, e.g., 1/96 for 96 TPI)
///
/// - Returns: KnurlResult containing teeth count, ideal diameter, and adjustment needed
///
/// Formulas:
/// - N = max(1, round(π × D / pitch))
/// - idealDia = N × pitch / π
/// - adjust = D − idealDia  (positive: reduce; negative: increase)
public func knurl(diaIn D: Double, pitchIn: Double) -> KnurlResult {
    // Calculate number of teeth around circumference
    let N = max(1, Int((Double.pi * D / pitchIn).rounded()))

    // Calculate ideal diameter
    let idealDia = Double(N) * pitchIn / Double.pi

    // Calculate adjustment (positive = reduce, negative = increase)
    let adjust = D - idealDia

    return KnurlResult(teeth: N, idealDiaIn: idealDia, adjustIn: adjust)
}
