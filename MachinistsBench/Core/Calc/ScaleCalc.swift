import Foundation

// MARK: - Scale Converter

/// Compute model length, area, and volume for a 1:N scale.
/// - Parameters:
///   - full: Full-size measurement (any unit).
///   - n: Scale denominator (1:N).
/// - Returns: Tuple of (model: full/N, area: full/N², vol: full/N³).
public func scaleModel(full: Double, n: Double) -> (model: Double, area: Double, vol: Double) {
    let model = full / n
    let area  = full / (n * n)
    let vol   = full / (n * n * n)
    return (model, area, vol)
}

// MARK: - Scale Speed (Froude similarity)

/// Compute scale speed and wheel RPM using Froude similarity.
///
/// Ported verbatim from app.html (inch path, line 6340):
/// ```
/// vModPerMin = (prototypeMph / √N) * 63360 / 60   // in/min
/// wheelRPM   = vModPerMin / (π × (wheelDiaIn / N))
/// ```
/// - Parameters:
///   - prototypeMph: Full-size prototype speed in mph.
///   - n: Scale denominator (1:N).
///   - wheelDiaIn: Full-size driving-wheel diameter in inches.
/// - Returns: Tuple of (scaleMph: model speed in mph, wheelRPM: model wheel revolutions/min).
public func scaleSpeed(prototypeMph: Double, n: Double, wheelDiaIn: Double) -> (scaleMph: Double, wheelRPM: Double) {
    let sqrtN    = n.squareRoot()
    let scaleMph = prototypeMph / sqrtN
    // Exact JS: s / sqrtN * 63360 / 60  (where s is prototypeMph)
    let vModPerMin = prototypeMph / sqrtN * 63360.0 / 60.0
    let wMod       = wheelDiaIn / n
    let rpm        = wMod > 0 ? vModPerMin / (.pi * wMod) : 0
    return (scaleMph, rpm)
}

// MARK: - Fastener Naive Scale

/// Compute the naively-scaled fastener diameter (advisory — go oversize in practice).
/// - Parameters:
///   - diaIn: Full-size fastener diameter in inches.
///   - n: Scale denominator (1:N).
/// - Returns: Scaled diameter = diaIn / N.
public func fastenerNaive(diaIn: Double, n: Double) -> Double {
    return diaIn / n
}
