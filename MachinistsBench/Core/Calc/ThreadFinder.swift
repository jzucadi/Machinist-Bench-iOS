// ThreadFinder.swift — Thread concordance calculations
// Ported from app.html FamBlock formula (line 5836, 5844–5846).
// NOTE: Does NOT clash with Tapping.swift tapDrillIdeal() / tapActualPct() (M2/M3-era).

import Foundation

// MARK: - K factor (thread depth factor by form angle)

/// Thread-depth factor K for the 60° form (UN, Metric, NPT, Photo).
/// From app.html: `fam.ang === 60 ? 1.299 : fam.ang === 55 ? 1.2806 : 1.2`
/// BSC cycle uses k=1.0654 (special radiused form).
public let threadDepthK_60: Double = 1.299   // 60° UN/Metric/NPT/Photo
public let threadDepthK_55: Double = 1.2806  // 55° Whitworth/BSF/BSB/BSP/ME
public let threadDepthK_47: Double = 1.2     // 47.5° BA/Thury
public let threadDepthK_BSC: Double = 1.0654 // BSC Cycle (radiused crests)

// MARK: - tapDrillIn

/// Tap drill diameter in inches for the given engagement percentage.
///
/// Formula (from app.html FamBlock, line 5844, generalised):
///   `tapIn = majorIn - (engagementPct / 100) × K × pitchIn`
///
/// K defaults to 1.299 (60° UN/Metric form). For other families call
/// `tapDrillIn(majorIn:pitchIn:engagementPct:k:)`.
///
/// - Parameters:
///   - majorIn:       Major diameter in inches.
///   - pitchIn:       Pitch in inches (= 1/tpi for inch threads, pitch_mm/25.4 for metric).
///   - engagementPct: Thread engagement percentage (75 = standard tapping drill).
/// - Returns: Tap drill diameter in inches.
public func tapDrillIn(majorIn: Double, pitchIn: Double, engagementPct: Double) -> Double {
    tapDrillIn(majorIn: majorIn, pitchIn: pitchIn, engagementPct: engagementPct, k: threadDepthK_60)
}

/// Tap drill with explicit K factor.
public func tapDrillIn(majorIn: Double, pitchIn: Double, engagementPct: Double, k: Double) -> Double {
    majorIn - (engagementPct / 100.0) * k * pitchIn
}

// MARK: - threadClearanceIn

/// Clearance (through-hole) diameter in inches for a close fit.
///
/// Formula (from app.html FamBlock, lines 5845–5846):
///   allow_mm = major_mm ≤ 5  → 0.2 mm
///            = major_mm ≤ 12 → 0.4 mm
///            = major_mm > 12 → 0.6 mm
///   clearance_mm = major_mm + allow_mm
///
/// The JS has a single tiered allowance (no close/normal/loose variants).
///
/// - Parameter majorIn: Major diameter in inches.
/// - Returns: Clearance drill diameter in inches.
public func threadClearanceIn(majorIn: Double) -> Double {
    let majorMm = majorIn * 25.4
    let allowMm: Double
    if majorMm <= 5.0 {
        allowMm = 0.2
    } else if majorMm <= 12.0 {
        allowMm = 0.4
    } else {
        allowMm = 0.6
    }
    return (majorMm + allowMm) / 25.4
}

// MARK: - nearestThreads

/// Returns the `count` threads in `ThreadFamilies.all` whose major diameter
/// is closest to `toDiaIn`, sorted ascending by |majorIn − toDiaIn|.
///
/// Implements the JS FamBlock "Nearest 6" sort (app.html line 5833):
///   `list.map(t => ({...t, delta: Math.abs(t.d - query)})).sort((a,b) => a.delta - b.delta).slice(0, 6)`
///
/// - Parameters:
///   - toDiaIn: Target diameter in inches.
///   - count:   Number of results to return (default 6).
/// - Returns: Array of up to `count` ThreadSpec values, nearest-first.
public func nearestThreads(toDiaIn: Double, count: Int = 6) -> [ThreadSpec] {
    ThreadFamilies.all
        .sorted { abs($0.majorIn - toDiaIn) < abs($1.majorIn - toDiaIn) }
        .prefix(count)
        .map { $0 }
}
