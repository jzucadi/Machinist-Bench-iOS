// Threads.swift — pure data, no UIKit/SwiftUI
// Transcribed verbatim from app.html lines 595–597.

public struct InchThread: Sendable {
    public let name:  String
    public let tpi:   Double
    public let major: Double

    public init(name: String, tpi: Double, major: Double) {
        self.name  = name
        self.tpi   = tpi
        self.major = major
    }
}

public struct MetricThread: Sendable {
    public let name:  String
    public let pitch: Double
    public let major: Double   // mm

    public init(name: String, pitch: Double, major: Double) {
        self.name  = name
        self.pitch = pitch
        self.major = major
    }
}

public enum Threads {

    // MARK: - UNC (verbatim from app.html line 595)

    public static let unc: [InchThread] = [
        InchThread(name: "#1-64",    tpi: 64,  major: 0.073),
        InchThread(name: "#2-56",    tpi: 56,  major: 0.086),
        InchThread(name: "#3-48",    tpi: 48,  major: 0.099),
        InchThread(name: "#4-40",    tpi: 40,  major: 0.112),
        InchThread(name: "#6-32",    tpi: 32,  major: 0.138),
        InchThread(name: "#8-32",    tpi: 32,  major: 0.164),
        InchThread(name: "#10-24",   tpi: 24,  major: 0.19),
        InchThread(name: "#12-24",   tpi: 24,  major: 0.216),
        InchThread(name: "1/4-20",   tpi: 20,  major: 0.25),
        InchThread(name: "5/16-18",  tpi: 18,  major: 0.3125),
        InchThread(name: "3/8-16",   tpi: 16,  major: 0.375),
        InchThread(name: "7/16-14",  tpi: 14,  major: 0.4375),
        InchThread(name: "1/2-13",   tpi: 13,  major: 0.5),
        InchThread(name: "9/16-12",  tpi: 12,  major: 0.5625),
        InchThread(name: "5/8-11",   tpi: 11,  major: 0.625),
        InchThread(name: "3/4-10",   tpi: 10,  major: 0.75),
        InchThread(name: "7/8-9",    tpi:  9,  major: 0.875),
        InchThread(name: "1\"-8",    tpi:  8,  major: 1.0),
        InchThread(name: "1-1/8-7",  tpi:  7,  major: 1.125),
        InchThread(name: "1-1/4-7",  tpi:  7,  major: 1.25),
        InchThread(name: "1-1/2-6",  tpi:  6,  major: 1.5),
    ]

    // MARK: - UNF (verbatim from app.html line 596)

    public static let unf: [InchThread] = [
        InchThread(name: "#0-80",    tpi: 80,  major: 0.06),
        InchThread(name: "#1-72",    tpi: 72,  major: 0.073),
        InchThread(name: "#2-64",    tpi: 64,  major: 0.086),
        InchThread(name: "#3-56",    tpi: 56,  major: 0.099),
        InchThread(name: "#4-48",    tpi: 48,  major: 0.112),
        InchThread(name: "#6-40",    tpi: 40,  major: 0.138),
        InchThread(name: "#8-36",    tpi: 36,  major: 0.164),
        InchThread(name: "#10-32",   tpi: 32,  major: 0.19),
        InchThread(name: "#12-28",   tpi: 28,  major: 0.216),
        InchThread(name: "1/4-28",   tpi: 28,  major: 0.25),
        InchThread(name: "5/16-24",  tpi: 24,  major: 0.3125),
        InchThread(name: "3/8-24",   tpi: 24,  major: 0.375),
        InchThread(name: "7/16-20",  tpi: 20,  major: 0.4375),
        InchThread(name: "1/2-20",   tpi: 20,  major: 0.5),
        InchThread(name: "9/16-18",  tpi: 18,  major: 0.5625),
        InchThread(name: "5/8-18",   tpi: 18,  major: 0.625),
        InchThread(name: "3/4-16",   tpi: 16,  major: 0.75),
        InchThread(name: "7/8-14",   tpi: 14,  major: 0.875),
        InchThread(name: "1\"-12",   tpi: 12,  major: 1.0),
        InchThread(name: "1-1/4-12", tpi: 12,  major: 1.25),
        InchThread(name: "1-1/2-12", tpi: 12,  major: 1.5),
    ]

    // MARK: - Metric (verbatim from app.html line 597; names use U+00D7 ×)

    public static let metric: [MetricThread] = [
        MetricThread(name: "M2 \u{D7} 0.4",    pitch: 0.4,   major:  2.0),
        MetricThread(name: "M2.5 \u{D7} 0.45",  pitch: 0.45,  major:  2.5),
        MetricThread(name: "M3 \u{D7} 0.5",     pitch: 0.5,   major:  3.0),
        MetricThread(name: "M3.5 \u{D7} 0.6",   pitch: 0.6,   major:  3.5),
        MetricThread(name: "M4 \u{D7} 0.7",     pitch: 0.7,   major:  4.0),
        MetricThread(name: "M5 \u{D7} 0.8",     pitch: 0.8,   major:  5.0),
        MetricThread(name: "M6 \u{D7} 1.0",     pitch: 1.0,   major:  6.0),
        MetricThread(name: "M8 \u{D7} 1.25",    pitch: 1.25,  major:  8.0),
        MetricThread(name: "M10 \u{D7} 1.5",    pitch: 1.5,   major: 10.0),
        MetricThread(name: "M12 \u{D7} 1.75",   pitch: 1.75,  major: 12.0),
        MetricThread(name: "M14 \u{D7} 2.0",    pitch: 2.0,   major: 14.0),
        MetricThread(name: "M16 \u{D7} 2.0",    pitch: 2.0,   major: 16.0),
        MetricThread(name: "M18 \u{D7} 2.5",    pitch: 2.5,   major: 18.0),
        MetricThread(name: "M20 \u{D7} 2.5",    pitch: 2.5,   major: 20.0),
        MetricThread(name: "M24 \u{D7} 3.0",    pitch: 3.0,   major: 24.0),
        MetricThread(name: "M30 \u{D7} 3.5",    pitch: 3.5,   major: 30.0),
        MetricThread(name: "M36 \u{D7} 4.0",    pitch: 4.0,   major: 36.0),
    ]
}
