// TorqueCharts.swift — Fastener torque reference data
// Verbatim from app.html TORQUE_DATA (lines 5874–5905).
// SAE Grade 5 / ISO 8.8, dry threads (K≈0.2), 75% of proof load.
// unit: "in" = in·lb (small sizes), "ft" = ft·lb (larger sizes)

import Foundation

// MARK: - TorqueEntry

public struct TorqueEntry: Sendable {
    /// Thread designation, e.g. "#4-40", "1/4-20", "M6"
    public let thread:     String
    /// "in" = in·lb / N·cm; "ft" = ft·lb / N·m
    public let unit:       String
    /// Torque into steel (SAE G5 / ISO 8.8)
    public let steelValue: Double
    /// Torque into aluminum, iron, or brass (~60% of steel)
    public let softValue:  Double

    public init(thread: String, unit: String, steelValue: Double, softValue: Double) {
        self.thread     = thread
        self.unit       = unit
        self.steelValue = steelValue
        self.softValue  = softValue
    }
}

// MARK: - TorqueCharts

public enum TorqueCharts {

    /// 18-row SAE inch torque chart (app.html TORQUE_DATA.inch).
    public static let inch: [TorqueEntry] = [
        TorqueEntry(thread: "#4-40",    unit: "in", steelValue:   9,   softValue:   5),
        TorqueEntry(thread: "#6-32",    unit: "in", steelValue:  16,   softValue:  10),
        TorqueEntry(thread: "#8-32",    unit: "in", steelValue:  29,   softValue:  18),
        TorqueEntry(thread: "#10-24",   unit: "in", steelValue:  42,   softValue:  25),
        TorqueEntry(thread: "#10-32",   unit: "in", steelValue:  48,   softValue:  29),
        TorqueEntry(thread: "1/4-20",   unit: "ft", steelValue:   8,   softValue:   5),
        TorqueEntry(thread: "1/4-28",   unit: "ft", steelValue:  10,   softValue:   6),
        TorqueEntry(thread: "5/16-18",  unit: "ft", steelValue:  17,   softValue:  10),
        TorqueEntry(thread: "5/16-24",  unit: "ft", steelValue:  19,   softValue:  12),
        TorqueEntry(thread: "3/8-16",   unit: "ft", steelValue:  31,   softValue:  19),
        TorqueEntry(thread: "3/8-24",   unit: "ft", steelValue:  35,   softValue:  21),
        TorqueEntry(thread: "7/16-14",  unit: "ft", steelValue:  49,   softValue:  30),
        TorqueEntry(thread: "7/16-20",  unit: "ft", steelValue:  55,   softValue:  33),
        TorqueEntry(thread: "1/2-13",   unit: "ft", steelValue:  75,   softValue:  45),
        TorqueEntry(thread: "1/2-20",   unit: "ft", steelValue:  85,   softValue:  51),
        TorqueEntry(thread: "5/8-11",   unit: "ft", steelValue: 150,   softValue:  90),
        TorqueEntry(thread: "3/4-10",   unit: "ft", steelValue: 266,   softValue: 160),
        TorqueEntry(thread: "1-8",      unit: "ft", steelValue: 644,   softValue: 386),
    ]

    /// 7-row ISO metric torque chart (app.html TORQUE_DATA.metric).
    public static let metric: [TorqueEntry] = [
        TorqueEntry(thread: "M3",  unit: "in", steelValue:  12,  softValue:   7),
        TorqueEntry(thread: "M4",  unit: "in", steelValue:  27,  softValue:  16),
        TorqueEntry(thread: "M5",  unit: "ft", steelValue:   4.6, softValue:  2.8),
        TorqueEntry(thread: "M6",  unit: "ft", steelValue:   7.7, softValue:  4.6),
        TorqueEntry(thread: "M8",  unit: "ft", steelValue:  19,  softValue:  11),
        TorqueEntry(thread: "M10", unit: "ft", steelValue:  37,  softValue:  22),
        TorqueEntry(thread: "M12", unit: "ft", steelValue:  65,  softValue:  39),
    ]
}
