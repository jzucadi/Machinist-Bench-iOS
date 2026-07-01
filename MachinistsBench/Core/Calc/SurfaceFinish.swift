import Foundation

/// Calculate surface finish (Ra and Rmax) from feed rate and nose radius.
///
/// Predicts the roughness profile based on feed per revolution and cutting tool nose radius.
///
/// - Parameters:
///   - feedIPR: Feed per revolution (inches/rev)
///   - noseRadIn: Nose radius of the cutting tool (inches)
///
/// - Returns: Tuple containing:
///   - rmaxIn: Peak-to-valley roughness (inches)
///   - raIn: Arithmetic mean roughness (inches)
///
/// Formulas:
/// - Rmax = f² / (8 × r)
/// - Ra = Rmax / 4
public func surfaceRa(feedIPR f: Double, noseRadIn r: Double) -> (rmaxIn: Double, raIn: Double) {
    let rmax = (f * f) / (8 * r)
    let ra = rmax / 4

    return (rmaxIn: rmax, raIn: ra)
}

/// Calculate required feed rate for a target surface finish Ra value.
///
/// Determines the feed rate needed to achieve a specific surface roughness target.
///
/// - Parameters:
///   - raIn: Target arithmetic mean roughness (inches)
///   - noseRadIn: Nose radius of the cutting tool (inches)
///
/// - Returns: Required feed per revolution (inches/rev)
///
/// Formula:
/// - f = √(Ra × 32 × r)  [derived from Ra = f² / (32r)]
public func feedForRa(raIn: Double, noseRadIn r: Double) -> Double {
    return (raIn * 32 * r).squareRoot()
}
