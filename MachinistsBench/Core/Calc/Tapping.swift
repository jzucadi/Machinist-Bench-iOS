import Foundation

// MARK: - Tap drill sizing

/// Returns the ideal tap drill diameter in inches.
/// Formula: idealHoleIn = majorIn - (pct/100) * 1.299 * pitchIn
public func tapDrillIdeal(majorIn: Double, pitchIn: Double, pct: Double) -> Double {
    majorIn - (pct / 100.0) * 1.299 * pitchIn
}

/// Returns the actual thread percentage for a given drill diameter.
/// Formula: actualPct = (majorIn - drillDia) / (1.299 * pitchIn) * 100
public func tapActualPct(majorIn: Double, drillDia: Double, pitchIn: Double) -> Double {
    (majorIn - drillDia) / (1.299 * pitchIn) * 100.0
}

// MARK: - Tapping speed

public struct TapSpeed: Sendable {
    public let rpm: Double
    public let syncFeedIPM: Double

    public init(rpm: Double, syncFeedIPM: Double) {
        self.rpm = rpm
        self.syncFeedIPM = syncFeedIPM
    }
}

/// Calculates tapping RPM and synchronous feed based on major diameter and sfm.
/// RPM = sfm * 12 / (π * majorIn)   — based on major diameter per spec
/// syncFeedIPM = RPM * pitchIn
/// Returns nil if any input is invalid (zero or NaN).
public func tapping(majorIn: Double, pitchIn: Double, sfm: Double) -> TapSpeed? {
    for v in [majorIn, pitchIn, sfm] where v.isNaN || v <= 0 { return nil }
    let rpm = sfm * 12.0 / (.pi * majorIn)
    let syncFeedIPM = rpm * pitchIn
    return TapSpeed(rpm: rpm, syncFeedIPM: syncFeedIPM)
}
