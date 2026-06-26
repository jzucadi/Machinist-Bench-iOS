import Foundation

// MARK: - Band Saw Speed Calculator

/// Returns blade surface speed in FPM for a metal material.
///
/// - Parameters:
///   - material: A `SawMaterial` from `SawData.materials`.
///   - blade: `"bi"` (bi-metal), `"carbon"`, or `"carbide"`.
///   - sectionIn: Section size across the cut in inches.
/// - Returns: Recommended blade speed in FPM (feet per minute).
public func bladeSpeedFPM(material: SawMaterial, blade: String, sectionIn: Double) -> Int {
    // Section-size band index (metal materials only)
    // band(t): t < 1 → 0, t < 3 → 1, t < 6 → 2, else 3
    let band: Int
    if sectionIn < 1 {
        band = 0
    } else if sectionIn < 3 {
        band = 1
    } else if sectionIn < 6 {
        band = 2
    } else {
        band = 3
    }

    guard band < material.sfm.count else { return 0 }
    let base = material.sfm[band]

    switch blade {
    case "carbon":
        return Int((Double(base) * 0.5).rounded())
    default:  // "bi" and "carbide" both use base rate
        return base
    }
}

// MARK: - Band Saw Pitch / Blade Select Calculator

/// Recommends a blade pitch (TPI) for the given section size and material class.
///
/// Implements the 3-to-24 teeth-in-the-cut rule from `BandSawSelect` in app.html.
///
/// - Parameters:
///   - sizeIn: Section size (or wall thickness for tube) in inches.
///   - materialClass: `"steel"`, `"nonfer"`, `"plastic"`, or `"wood"`.
///   - userTPI: Optional user-entered TPI override; when non-nil, `avg` and `teeth` reflect it.
/// - Returns: A tuple with the recommended label, avg TPI, teeth in cut, min/max TPI, and tone.
public func sawPitch(
    sizeIn: Double,
    materialClass: String,
    userTPI: Double?
) -> (label: String, avg: Double, teeth: Double, minTPI: Double, maxTPI: Double, tone: String) {

    let table = SawData.diaPitch
    let maxIdx = table.count - 1

    // Find first index where sizeIn <= table[idx].maxIn
    var idx = table.indices.first { sizeIn <= table[$0].maxIn } ?? maxIdx

    // Material-class offset: finer for soft materials
    let off: Int
    switch materialClass {
    case "wood":              off = 2
    case "plastic", "nonfer": off = 1
    default:                  off = 0   // "steel" and anything else
    }
    idx = max(0, min(maxIdx, idx + off))

    // Enforce 3-to-24 teeth rule on the recommended pitch
    while table[idx].avg * sizeIn < 3 && idx > 0 { idx -= 1 }      // go coarser
    while table[idx].avg * sizeIn > 24 && idx < maxIdx { idx += 1 } // go finer

    let row = table[idx]
    let recAvg = row.avg

    // Teeth in cut: use userTPI if provided, else recommended avg
    let effectiveTPI = userTPI ?? recAvg
    let teeth = effectiveTPI * sizeIn

    let minTPI = 3.0 / sizeIn
    let maxTPI = 24.0 / sizeIn

    let tone: String
    if teeth < 3 {
        tone = "bad"
    } else if teeth > 24 {
        tone = "warn"
    } else {
        tone = "good"
    }

    return (label: row.label, avg: recAvg, teeth: teeth, minTPI: minTPI, maxTPI: maxTPI, tone: tone)
}
