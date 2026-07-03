import Foundation

/// Calculate the gauge-block stack height for a sine bar.
/// - Parameters:
///   - barLengthIn: Sine bar length in inches
///   - degrees: Angle degrees component
///   - minutes: Angle minutes component (0–59)
///   - seconds: Angle seconds component (0–59)
/// - Returns: Tuple of (stackIn: stack height in inches, decimalDeg: decimal degrees)
///   - stackIn = barLengthIn * sin(A * π/180)
///   - decimalDeg = degrees + minutes/60 + seconds/3600
public func sineBarStack(barLengthIn: Double, degrees: Double, minutes: Double, seconds: Double) -> (stackIn: Double, decimalDeg: Double) {
    // Convert DMS to decimal degrees
    let decimalDeg = degrees + minutes / 60.0 + seconds / 3600.0

    // Convert to radians
    let angleRad = decimalDeg * .pi / 180.0

    // Calculate stack height
    let stackIn = barLengthIn * sin(angleRad)

    return (stackIn, decimalDeg)
}
