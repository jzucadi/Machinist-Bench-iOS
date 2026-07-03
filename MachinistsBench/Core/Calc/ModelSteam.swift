import Foundation

// MARK: - Boiler Proportions

/// Rules-of-thumb for sizing a model steam boiler from cylinder bore and count.
///
/// Ported verbatim from app.html BoilerProps component (line 6361):
/// ```
/// pa      = π × (bore/2)²            (in²)
/// totPA   = pa × nc
/// grate   = totPA / 8
/// heating = grate × 60
/// ```
/// `stroke` and `rpm` are inputs in the web app but are NOT used in the formula
/// (present as context fields). This function accepts only the formula inputs.
///
/// - Parameters:
///   - boreIn: Cylinder bore in inches.
///   - cylinders: Number of cylinders.
/// - Returns: Tuple of (grateSqIn: grate area in², heatingSqIn: heating surface in²).
public func boilerProps(boreIn: Double, cylinders: Int) -> (grateSqIn: Double, heatingSqIn: Double) {
    let pa    = Double.pi * (boreIn / 2) * (boreIn / 2)
    let totPA = pa * Double(cylinders)
    let grate = totPA / 8.0
    let heat  = grate * 60.0
    return (grate, heat)
}

// MARK: - Cylinder Power (PLAN formula)

/// Calculates indicated cylinder power and approximate steam consumption.
///
/// Ported verbatim from app.html CylinderPower component (line 6392):
/// ```
/// bore_m         = boreIn × 0.0254
/// stroke_m       = strokeIn × 0.0254
/// mep_pa         = psi × 6894.76
/// area_m²        = π × (bore_m/2)²
/// strokesPerSec  = 2 × rpm / 60          // double-acting
/// watts          = mep_pa × stroke_m × area_m² × strokesPerSec × nc
/// hp             = watts / 745.7
/// sweptVol_m³    = area_m² × stroke_m
/// steamVol_min   = sweptVol_m³ × strokesPerSec × 60 × cutoff × nc
/// Pbar           = psi / 14.5
/// rho            = max(0.6, Pbar × 0.55)
/// steamKg_h      = steamVol_min × 60 × rho
/// ```
///
/// - Parameters:
///   - boreIn:    Cylinder bore in inches.
///   - strokeIn:  Stroke length in inches.
///   - rpm:       Engine speed in revolutions per minute.
///   - psi:       Mean effective pressure in psi.
///   - cutoff:    Admission cutoff (0–1, e.g. 0.6).
///   - cylinders: Number of cylinders.
/// - Returns: Tuple of (watts: indicated power W, hp: horsepower, steamKgH: steam consumption kg/h).
public func cylinderPower(
    boreIn:    Double,
    strokeIn:  Double,
    rpm:       Double,
    psi:       Double,
    cutoff:    Double,
    cylinders: Int
) -> (watts: Double, hp: Double, steamKgH: Double) {
    let nc            = Double(cylinders)
    let bore_m        = boreIn   * 0.0254
    let stroke_m      = strokeIn * 0.0254
    let mep_pa        = psi * 6894.76
    let area_m2       = Double.pi * (bore_m / 2) * (bore_m / 2)
    let strokesPerSec = 2.0 * rpm / 60.0
    let watts         = mep_pa * stroke_m * area_m2 * strokesPerSec * nc
    let hp            = watts / 745.7
    let sweptVol_m3   = area_m2 * stroke_m
    let steamVol_min  = sweptVol_m3 * strokesPerSec * 60.0 * cutoff * nc
    let Pbar          = psi / 14.5
    let rho           = max(0.6, Pbar * 0.55)
    let steamKg_h     = steamVol_min * 60.0 * rho
    return (watts, hp, steamKg_h)
}
