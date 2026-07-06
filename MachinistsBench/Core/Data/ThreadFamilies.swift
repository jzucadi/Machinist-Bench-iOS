// ThreadFamilies.swift — Thread concordance data
// Verbatim from app.html THREAD_RAW (lines 5664–5803), THREAD_FAM_ORDER (line 5663).
// 12 families / 126 threads. pitchIn = pitch_mm / 25.4 for all entries.
// DO NOT CLASH with Threads.swift (InchThread/MetricThread/Threads enum — M2/M3 tap drills).

import Foundation

// MARK: - ThreadSpec

public struct ThreadSpec: Sendable {
    public let name:    String  // Designation string as in app.html
    public let family:  String  // Family key: "un", "metric", "bsw", etc.
    public let majorIn: Double  // Major diameter in inches (major_mm / 25.4)
    public let pitchIn: Double  // Pitch in inches (pitch_mm / 25.4)

    public init(name: String, family: String, majorIn: Double, pitchIn: Double) {
        self.name    = name
        self.family  = family
        self.majorIn = majorIn
        self.pitchIn = pitchIn
    }
}

// MARK: - ThreadFamilies

/// All 12 thread families, 126 entries total, verbatim from app.html THREAD_RAW.
/// Family order: ["un","metric","bsw","bsf","bsb","bsc","bsp","npt","ba","thury","me","photo"]
public enum ThreadFamilies {

    /// Convert mm values to inches for storage (pitchIn = pitch_mm / 25.4, majorIn = major_mm / 25.4)
    private static func t(_ fam: String, _ name: String, _ majorMm: Double, _ pitchMm: Double) -> ThreadSpec {
        ThreadSpec(name: name, family: fam, majorIn: majorMm / 25.4, pitchIn: pitchMm / 25.4)
    }

    public static let all: [ThreadSpec] = [
        // MARK: Unified (UNC/UNF) — 60°
        t("un", "#0-80 UNF",        1.524,  0.3175),
        t("un", "#1-64 UNC",        1.854,  0.3969),
        t("un", "#1-72 UNF",        1.854,  0.3528),
        t("un", "#2-56 UNC",        2.184,  0.4536),
        t("un", "#2-64 UNF",        2.184,  0.3969),
        t("un", "#3-48 UNC",        2.515,  0.5292),
        t("un", "#3-56 UNF",        2.515,  0.4536),
        t("un", "#4-40 UNC",        2.845,  0.635 ),
        t("un", "#6-32 UNC",        3.505,  0.794 ),
        t("un", "#8-32 UNC",        4.166,  0.794 ),
        t("un", "#10-24 UNC",       4.826,  1.058 ),
        t("un", "#10-32 UNF",       4.826,  0.794 ),
        t("un", "1/4-20 UNC",       6.35,   1.27  ),
        t("un", "1/4-28 UNF",       6.35,   0.907 ),
        t("un", "5/16-18 UNC",      7.938,  1.411 ),
        t("un", "3/8-16 UNC",       9.525,  1.5875),
        t("un", "3/8-24 UNF",       9.525,  1.058 ),
        t("un", "1/2-13 UNC",      12.7,    1.954 ),
        t("un", "1/2-20 UNF",      12.7,    1.27  ),
        t("un", "5/8-11 UNC",      15.875,  2.309 ),
        t("un", "3/4-10 UNC",      19.05,   2.54  ),
        t("un", "1\"-8 UNC",       25.4,    3.175 ),

        // MARK: ISO Metric — 60°
        t("metric", "M2 \u{D7} 0.4",          2,    0.4  ),
        t("metric", "M2.5 \u{D7} 0.45",       2.5,  0.45 ),
        t("metric", "M3 \u{D7} 0.5",          3,    0.5  ),
        t("metric", "M4 \u{D7} 0.7",          4,    0.7  ),
        t("metric", "M5 \u{D7} 0.8",          5,    0.8  ),
        t("metric", "M6 \u{D7} 1.0",          6,    1.0  ),
        t("metric", "M8 \u{D7} 1.25",         8,    1.25 ),
        t("metric", "M8 \u{D7} 1.0 fine",     8,    1.0  ),
        t("metric", "M10 \u{D7} 1.5",        10,    1.5  ),
        t("metric", "M10 \u{D7} 1.25 fine",  10,    1.25 ),
        t("metric", "M12 \u{D7} 1.75",       12,    1.75 ),
        t("metric", "M12 \u{D7} 1.25 fine",  12,    1.25 ),
        t("metric", "M16 \u{D7} 2.0",        16,    2.0  ),
        t("metric", "M20 \u{D7} 2.5",        20,    2.5  ),
        t("metric", "M24 \u{D7} 3.0",        24,    3.0  ),

        // MARK: Whitworth BSW — 55°
        t("bsw", "1/8 BSW",    3.175,  0.635 ),
        t("bsw", "3/16 BSW",   4.7625, 1.0583),
        t("bsw", "1/4 BSW",    6.35,   1.27  ),
        t("bsw", "5/16 BSW",   7.9375, 1.4111),
        t("bsw", "3/8 BSW",    9.525,  1.5875),
        t("bsw", "1/2 BSW",   12.7,    2.1167),
        t("bsw", "5/8 BSW",   15.875,  2.3091),
        t("bsw", "3/4 BSW",   19.05,   2.54  ),
        t("bsw", "1\" BSW",   25.4,    3.175 ),

        // MARK: British Fine BSF — 55°
        t("bsf", "3/16 BSF",   4.7625, 0.7938),
        t("bsf", "1/4 BSF",    6.35,   0.9769),
        t("bsf", "5/16 BSF",   7.9375, 1.1545),
        t("bsf", "3/8 BSF",    9.525,  1.27  ),
        t("bsf", "1/2 BSF",   12.7,    1.5875),
        t("bsf", "5/8 BSF",   15.875,  1.8143),

        // MARK: BS Brass (BSB) — 55°, constant 26 TPI (0.9769 mm pitch)
        t("bsb", "1/8 \u{D7} 26 Brass",    3.175,  0.9769),
        t("bsb", "3/16 \u{D7} 26 Brass",   4.7625, 0.9769),
        t("bsb", "1/4 \u{D7} 26 Brass",    6.35,   0.9769),
        t("bsb", "5/16 \u{D7} 26 Brass",   7.9375, 0.9769),
        t("bsb", "3/8 \u{D7} 26 Brass",    9.525,  0.9769),
        t("bsb", "7/16 \u{D7} 26 Brass",  11.1125, 0.9769),
        t("bsb", "1/2 \u{D7} 26 Brass",   12.7,    0.9769),
        t("bsb", "5/8 \u{D7} 26 Brass",   15.875,  0.9769),
        t("bsb", "3/4 \u{D7} 26 Brass",   19.05,   0.9769),
        t("bsb", "1\" \u{D7} 26 Brass",   25.4,    0.9769),

        // MARK: British Cycle BSC — 60° radiused (k=1.0654), 26 TPI
        t("bsc", "1/4 \u{D7} 26 BSC",    6.35,   0.9769),
        t("bsc", "5/16 \u{D7} 26 BSC",   7.9375, 0.9769),
        t("bsc", "3/8 \u{D7} 26 BSC",    9.525,  0.9769),
        t("bsc", "7/16 \u{D7} 26 BSC",  11.1125, 0.9769),
        t("bsc", "1/2 \u{D7} 26 BSC",   12.7,    0.9769),
        t("bsc", "9/16 \u{D7} 26 BSC",  14.2875, 0.9769),

        // MARK: Pipe BSP — 55°, by nominal bore
        t("bsp", "1/8 BSP",    9.728,  0.907 ),
        t("bsp", "1/4 BSP",   13.157,  1.337 ),
        t("bsp", "3/8 BSP",   16.662,  1.337 ),
        t("bsp", "1/2 BSP",   20.955,  1.814 ),
        t("bsp", "3/4 BSP",   26.441,  1.814 ),
        t("bsp", "1\" BSP",   33.249,  2.309 ),

        // MARK: NPT — 60°, tapered 1:16, by nominal bore
        t("npt", "1/8 NPT",   10.287,  0.941 ),
        t("npt", "1/4 NPT",   13.716,  1.411 ),
        t("npt", "3/8 NPT",   17.145,  1.411 ),
        t("npt", "1/2 NPT",   21.336,  1.814 ),
        t("npt", "3/4 NPT",   26.67,   1.814 ),
        t("npt", "1\" NPT",   33.401,  2.209 ),

        // MARK: British Association BA — 47.5°
        t("ba", "0 BA",    6.0,  1.00),
        t("ba", "1 BA",    5.3,  0.90),
        t("ba", "2 BA",    4.7,  0.81),
        t("ba", "3 BA",    4.1,  0.73),
        t("ba", "4 BA",    3.6,  0.66),
        t("ba", "5 BA",    3.2,  0.59),
        t("ba", "6 BA",    2.8,  0.53),
        t("ba", "7 BA",    2.5,  0.48),
        t("ba", "8 BA",    2.2,  0.43),
        t("ba", "9 BA",    1.9,  0.39),
        t("ba", "10 BA",   1.7,  0.35),

        // MARK: Thury — 47.5° (parent of BA)
        t("thury", "T \u{2212}2",          7.7,  1.23),
        t("thury", "T \u{2212}1",          6.8,  1.11),
        t("thury", "T 0 (= 0 BA)",         6.0,  1.00),
        t("thury", "T 5 (= 5 BA)",         3.2,  0.59),
        t("thury", "T 10 (= 10 BA)",       1.7,  0.35),
        t("thury", "T 11 (11 BA)",         1.5,  0.31),
        t("thury", "T 12 (12 BA)",         1.3,  0.28),
        t("thury", "T 13",                 1.2,  0.25),
        t("thury", "T 14",                 1.0,  0.23),
        t("thury", "T 15",                 0.9,  0.21),
        t("thury", "T 16",                 0.79, 0.19),

        // MARK: Model Engineer ME — 55°
        t("me", "1/8 \u{D7} 40 ME",    3.175,  0.635),
        t("me", "3/16 \u{D7} 40 ME",   4.7625, 0.635),
        t("me", "1/4 \u{D7} 40 ME",    6.35,   0.635),
        t("me", "1/4 \u{D7} 32 ME",    6.35,   0.794),
        t("me", "5/16 \u{D7} 32 ME",   7.9375, 0.794),
        t("me", "3/8 \u{D7} 32 ME",    9.525,  0.794),
        t("me", "7/16 \u{D7} 32 ME",  11.1125, 0.794),
        t("me", "1/2 \u{D7} 32 ME",   12.7,    0.794),

        // MARK: Photographic / Optical — 60°
        t("photo", "1/4-20 (camera/tripod)",          6.35,  1.27  ),
        t("photo", "3/8-16 (tripod)",                 9.525, 1.5875),
        t("photo", "M42 \u{D7} 1 (lens screw)",      42.0,  1.0   ),
        t("photo", "T-mount T2 (M42 \u{D7} 0.75)",   42.0,  0.75  ),
        t("photo", "M39 \u{D7} 1/26\" (Leica LTM)",  39.0,  0.977 ),
        t("photo", "M37 \u{D7} 0.75 (filter)",       37.0,  0.75  ),
        t("photo", "M49 \u{D7} 0.75 (filter)",       49.0,  0.75  ),
        t("photo", "M52 \u{D7} 0.75 (filter)",       52.0,  0.75  ),
        t("photo", "M58 \u{D7} 0.75 (filter)",       58.0,  0.75  ),
        t("photo", "M67 \u{D7} 0.75 (filter)",       67.0,  0.75  ),
        t("photo", "M72 \u{D7} 0.75 (filter)",       72.0,  0.75  ),
        t("photo", "M77 \u{D7} 0.75 (filter)",       77.0,  0.75  ),
        t("photo", "C-mount (1\"-32)",               25.4,  0.794 ),
        t("photo", "CS-mount (1\"-32)",              25.4,  0.794 ),
        t("photo", "RMS microscope (0.8\"-36)",      20.32, 0.706 ),
        t("photo", "M25 \u{D7} 0.75 (RMS metric)",  25.0,  0.75  ),
    ]
}
