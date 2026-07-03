import Foundation

// MARK: - Scale Preset Model

/// A named scale ratio (1:N).
public struct ScalePreset: Sendable {
    public let name: String
    public let n: Double
    public init(name: String, n: Double) {
        self.name = name
        self.n = n
    }
}

// MARK: - Rail / Model Railway Scales
// Source: SCALE_PRESETS (app.html line 6116) — ScaleConverter quick-pick buttons

public enum ScalePresets {

    /// Model railway scales — ScaleConverter quick-pick buttons (SCALE_PRESETS, 17 entries).
    public static let rail: [ScalePreset] = [
        ScalePreset(name: "Z 1:220",        n: 220),
        ScalePreset(name: "N 1:160",        n: 160),
        ScalePreset(name: "TT 1:120",       n: 120),
        ScalePreset(name: "HO 1:87",        n: 87.1),
        ScalePreset(name: "OO 1:76",        n: 76.2),
        ScalePreset(name: "S 1:64",         n: 64),
        ScalePreset(name: "O 1:48",         n: 48),
        ScalePreset(name: "O (UK) 1:43.5",  n: 43.5),
        ScalePreset(name: "1 gauge 1:32",   n: 32),
        ScalePreset(name: "G/LGB 1:22.5",   n: 22.5),
        ScalePreset(name: "G 1:29",         n: 29),
        ScalePreset(name: "G 1:24",         n: 24),
        ScalePreset(name: "G 1:20.3",       n: 20.3),
        ScalePreset(name: "Lego ~1:38",     n: 38),
        ScalePreset(name: "1:12 (1\"=1')",  n: 12),
        ScalePreset(name: "1:8",            n: 8),
        ScalePreset(name: "1:16",           n: 16),
    ]

    /// Garden / large-scale railway presets (GARDEN_SCALES, 6 entries).
    public static let garden: [ScalePreset] = [
        ScalePreset(name: "1:32 (3/8\"/ft)",   n: 32),
        ScalePreset(name: "1:29",              n: 29),
        ScalePreset(name: "1:24 (1/2\"/ft)",   n: 24),
        ScalePreset(name: "1:22.5",            n: 22.5),
        ScalePreset(name: "1:20.3 (Fn3)",      n: 20.3),
        ScalePreset(name: "1:19 (16 mm/ft)",   n: 19),
    ]

    /// Live-steam / ride-on gauges (STEAM_GAUGES, 8 entries; n taken from col index 2).
    public static let liveSteam: [ScalePreset] = [
        ScalePreset(name: "2½\" (Gauge 3, 64 mm)", n: 24),
        ScalePreset(name: "3½\"",                  n: 16),
        ScalePreset(name: "4¾\"",                  n: 14.5),
        ScalePreset(name: "5\"",                   n: 12),
        ScalePreset(name: "7¼\" (E. US/Canada/UK)",n: 8),
        ScalePreset(name: "7½\" (W. US)",          n: 8),
        ScalePreset(name: "9\"",                   n: 6),
        ScalePreset(name: "45 mm (gauge 1)",       n: 32),
    ]

    /// Diecast/kit car scales (CAR_SCALES, 7 entries; n from col index 0).
    public static let car: [ScalePreset] = [
        ScalePreset(name: "1:64",        n: 64),
        ScalePreset(name: "1:43",        n: 43),
        ScalePreset(name: "1:32",        n: 32),
        ScalePreset(name: "1:24 (½\"/ft)", n: 24),
        ScalePreset(name: "1:25",        n: 25),
        ScalePreset(name: "1:18",        n: 18),
        ScalePreset(name: "1:12",        n: 12),
    ]

    /// Plastic kit & diecast aircraft scales (AIR_SCALES, 7 entries; n from col index 0).
    public static let aircraft: [ScalePreset] = [
        ScalePreset(name: "1:144",  n: 144),
        ScalePreset(name: "1:72",   n: 72),
        ScalePreset(name: "1:48 (¼\"/ft)", n: 48),
        ScalePreset(name: "1:32 (⅜\"/ft)", n: 32),
        ScalePreset(name: "1:24",   n: 24),
        ScalePreset(name: "1:200",  n: 200),
        ScalePreset(name: "1:400",  n: 400),
    ]

    /// Classic/kit boat scales (BOAT_SCALES, 9 entries; n from col index 0).
    public static let boat: [ScalePreset] = [
        ScalePreset(name: "1:16",              n: 16),
        ScalePreset(name: "1:24",              n: 24),
        ScalePreset(name: "1:32",              n: 32),
        ScalePreset(name: "1:48 (¼\"/ft)",    n: 48),
        ScalePreset(name: "1:64",              n: 64),
        ScalePreset(name: "1:72",              n: 72),
        ScalePreset(name: "1:96 (1/8\"/ft)",  n: 96),
        ScalePreset(name: "1:192 (1/16\"/ft)",n: 192),
        ScalePreset(name: "1:350",             n: 350),
        ScalePreset(name: "1:700",             n: 700),
    ]
}
