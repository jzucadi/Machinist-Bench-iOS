import Foundation

/// Hardness conversion table — 22 rows, verbatim from HARD shared-data.
/// Format: (hv, hb, hrc, hrb) — nil where source has null.
/// Table runs highest HV (940) to lowest (85).
public enum HardnessTable {
    public static let rows: [(hv: Double, hb: Double?, hrc: Double?, hrb: Double?)] = [
        (hv: 940, hb: nil,  hrc: 68,   hrb: nil),
        (hv: 800, hb: nil,  hrc: 64,   hrb: nil),
        (hv: 720, hb: nil,  hrc: 61,   hrb: nil),
        (hv: 650, hb: nil,  hrc: 58,   hrb: nil),
        (hv: 600, hb: nil,  hrc: 55,   hrb: nil),
        (hv: 550, hb: 505,  hrc: 52,   hrb: nil),
        (hv: 500, hb: 475,  hrc: 49,   hrb: nil),
        (hv: 450, hb: 428,  hrc: 45,   hrb: nil),
        (hv: 400, hb: 380,  hrc: 41,   hrb: nil),
        (hv: 360, hb: 342,  hrc: 37,   hrb: nil),
        (hv: 320, hb: 304,  hrc: 32,   hrb: nil),
        (hv: 300, hb: 285,  hrc: 30,   hrb: nil),
        (hv: 280, hb: 266,  hrc: 28,   hrb: nil),
        (hv: 250, hb: 238,  hrc: 22,   hrb: 100),
        (hv: 225, hb: 214,  hrc: 18,   hrb: 98),
        (hv: 200, hb: 190,  hrc: nil,  hrb: 93),
        (hv: 180, hb: 171,  hrc: nil,  hrb: 89),
        (hv: 160, hb: 152,  hrc: nil,  hrb: 84),
        (hv: 140, hb: 133,  hrc: nil,  hrb: 78),
        (hv: 120, hb: 114,  hrc: nil,  hrb: 70),
        (hv: 100, hb: 95,   hrc: nil,  hrb: 57),
        (hv:  85, hb: 81,   hrc: nil,  hrb: 48),
    ]
}
