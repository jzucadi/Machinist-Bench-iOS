// Drills.swift — pure data + lookup, no UIKit/SwiftUI
// Transcribed verbatim from app.html (WIRE ~line 479, LETTER ~line 480,
// buildFrac/FRAC ~lines 481-493, ALL_INCH ~line 494,
// nearestInchDrill ~line 495, nearestMetricDrill ~line 506).

public struct Drill: Sendable {
    public let name: String
    public let dia:  Double
    public let kind: String   // "wire" | "ltr" | "frac"

    public init(name: String, dia: Double, kind: String) {
        self.name = name
        self.dia  = dia
        self.kind = kind
    }
}

public enum Drills {

    // MARK: - Wire gauge drills #80…#1 (verbatim from app.html line 479)

    public static let wire: [Drill] = [
        Drill(name: "#80", dia: 0.0135,  kind: "wire"),
        Drill(name: "#79", dia: 0.0145,  kind: "wire"),
        Drill(name: "#78", dia: 0.016,   kind: "wire"),
        Drill(name: "#77", dia: 0.018,   kind: "wire"),
        Drill(name: "#76", dia: 0.02,    kind: "wire"),
        Drill(name: "#75", dia: 0.021,   kind: "wire"),
        Drill(name: "#74", dia: 0.0225,  kind: "wire"),
        Drill(name: "#73", dia: 0.024,   kind: "wire"),
        Drill(name: "#72", dia: 0.025,   kind: "wire"),
        Drill(name: "#71", dia: 0.026,   kind: "wire"),
        Drill(name: "#70", dia: 0.028,   kind: "wire"),
        Drill(name: "#69", dia: 0.0292,  kind: "wire"),
        Drill(name: "#68", dia: 0.031,   kind: "wire"),
        Drill(name: "#67", dia: 0.032,   kind: "wire"),
        Drill(name: "#66", dia: 0.033,   kind: "wire"),
        Drill(name: "#65", dia: 0.035,   kind: "wire"),
        Drill(name: "#64", dia: 0.036,   kind: "wire"),
        Drill(name: "#63", dia: 0.037,   kind: "wire"),
        Drill(name: "#62", dia: 0.038,   kind: "wire"),
        Drill(name: "#61", dia: 0.039,   kind: "wire"),
        Drill(name: "#60", dia: 0.04,    kind: "wire"),
        Drill(name: "#59", dia: 0.041,   kind: "wire"),
        Drill(name: "#58", dia: 0.042,   kind: "wire"),
        Drill(name: "#57", dia: 0.043,   kind: "wire"),
        Drill(name: "#56", dia: 0.0465,  kind: "wire"),
        Drill(name: "#55", dia: 0.052,   kind: "wire"),
        Drill(name: "#54", dia: 0.055,   kind: "wire"),
        Drill(name: "#53", dia: 0.0595,  kind: "wire"),
        Drill(name: "#52", dia: 0.0635,  kind: "wire"),
        Drill(name: "#51", dia: 0.067,   kind: "wire"),
        Drill(name: "#50", dia: 0.07,    kind: "wire"),
        Drill(name: "#49", dia: 0.073,   kind: "wire"),
        Drill(name: "#48", dia: 0.076,   kind: "wire"),
        Drill(name: "#47", dia: 0.0785,  kind: "wire"),
        Drill(name: "#46", dia: 0.081,   kind: "wire"),
        Drill(name: "#45", dia: 0.082,   kind: "wire"),
        Drill(name: "#44", dia: 0.086,   kind: "wire"),
        Drill(name: "#43", dia: 0.089,   kind: "wire"),
        Drill(name: "#42", dia: 0.0935,  kind: "wire"),
        Drill(name: "#41", dia: 0.096,   kind: "wire"),
        Drill(name: "#40", dia: 0.098,   kind: "wire"),
        Drill(name: "#39", dia: 0.0995,  kind: "wire"),
        Drill(name: "#38", dia: 0.1015,  kind: "wire"),
        Drill(name: "#37", dia: 0.104,   kind: "wire"),
        Drill(name: "#36", dia: 0.1065,  kind: "wire"),
        Drill(name: "#35", dia: 0.11,    kind: "wire"),
        Drill(name: "#34", dia: 0.111,   kind: "wire"),
        Drill(name: "#33", dia: 0.113,   kind: "wire"),
        Drill(name: "#32", dia: 0.116,   kind: "wire"),
        Drill(name: "#31", dia: 0.12,    kind: "wire"),
        Drill(name: "#30", dia: 0.1285,  kind: "wire"),
        Drill(name: "#29", dia: 0.136,   kind: "wire"),
        Drill(name: "#28", dia: 0.1405,  kind: "wire"),
        Drill(name: "#27", dia: 0.144,   kind: "wire"),
        Drill(name: "#26", dia: 0.147,   kind: "wire"),
        Drill(name: "#25", dia: 0.1495,  kind: "wire"),
        Drill(name: "#24", dia: 0.152,   kind: "wire"),
        Drill(name: "#23", dia: 0.154,   kind: "wire"),
        Drill(name: "#22", dia: 0.157,   kind: "wire"),
        Drill(name: "#21", dia: 0.159,   kind: "wire"),
        Drill(name: "#20", dia: 0.161,   kind: "wire"),
        Drill(name: "#19", dia: 0.166,   kind: "wire"),
        Drill(name: "#18", dia: 0.1695,  kind: "wire"),
        Drill(name: "#17", dia: 0.173,   kind: "wire"),
        Drill(name: "#16", dia: 0.177,   kind: "wire"),
        Drill(name: "#15", dia: 0.18,    kind: "wire"),
        Drill(name: "#14", dia: 0.182,   kind: "wire"),
        Drill(name: "#13", dia: 0.185,   kind: "wire"),
        Drill(name: "#12", dia: 0.189,   kind: "wire"),
        Drill(name: "#11", dia: 0.191,   kind: "wire"),
        Drill(name: "#10", dia: 0.1935,  kind: "wire"),
        Drill(name: "#9",  dia: 0.196,   kind: "wire"),
        Drill(name: "#8",  dia: 0.199,   kind: "wire"),
        Drill(name: "#7",  dia: 0.201,   kind: "wire"),
        Drill(name: "#6",  dia: 0.204,   kind: "wire"),
        Drill(name: "#5",  dia: 0.2055,  kind: "wire"),
        Drill(name: "#4",  dia: 0.209,   kind: "wire"),
        Drill(name: "#3",  dia: 0.213,   kind: "wire"),
        Drill(name: "#2",  dia: 0.221,   kind: "wire"),
        Drill(name: "#1",  dia: 0.228,   kind: "wire"),
    ]

    // MARK: - Letter drills A…Z (verbatim from app.html line 480)

    public static let letter: [Drill] = [
        Drill(name: "A", dia: 0.234, kind: "ltr"),
        Drill(name: "B", dia: 0.238, kind: "ltr"),
        Drill(name: "C", dia: 0.242, kind: "ltr"),
        Drill(name: "D", dia: 0.246, kind: "ltr"),
        Drill(name: "E", dia: 0.25,  kind: "ltr"),
        Drill(name: "F", dia: 0.257, kind: "ltr"),
        Drill(name: "G", dia: 0.261, kind: "ltr"),
        Drill(name: "H", dia: 0.266, kind: "ltr"),
        Drill(name: "I", dia: 0.272, kind: "ltr"),
        Drill(name: "J", dia: 0.277, kind: "ltr"),
        Drill(name: "K", dia: 0.281, kind: "ltr"),
        Drill(name: "L", dia: 0.29,  kind: "ltr"),
        Drill(name: "M", dia: 0.295, kind: "ltr"),
        Drill(name: "N", dia: 0.302, kind: "ltr"),
        Drill(name: "O", dia: 0.316, kind: "ltr"),
        Drill(name: "P", dia: 0.323, kind: "ltr"),
        Drill(name: "Q", dia: 0.332, kind: "ltr"),
        Drill(name: "R", dia: 0.339, kind: "ltr"),
        Drill(name: "S", dia: 0.348, kind: "ltr"),
        Drill(name: "T", dia: 0.358, kind: "ltr"),
        Drill(name: "U", dia: 0.368, kind: "ltr"),
        Drill(name: "V", dia: 0.377, kind: "ltr"),
        Drill(name: "W", dia: 0.386, kind: "ltr"),
        Drill(name: "X", dia: 0.397, kind: "ltr"),
        Drill(name: "Y", dia: 0.404, kind: "ltr"),
        Drill(name: "Z", dia: 0.413, kind: "ltr"),
    ]

    // MARK: - Fractional drills (buildFrac verbatim: n/64 reduced, n=1…64)
    // Names use `"` suffix to match JavaScript: `${a}/${b}"`

    public static let frac: [Drill] = buildFrac()

    private static func buildFrac() -> [Drill] {
        var result: [Drill] = []
        for n in 1...64 {
            var a = n
            var b = 64
            while a % 2 == 0 && b % 2 == 0 {
                a /= 2
                b /= 2
            }
            let dia = Double(n) / 64.0
            result.append(Drill(name: "\(a)/\(b)\"", dia: dia, kind: "frac"))
        }
        return result
    }

    // MARK: - Combined list (wire + letter + frac, matching ALL_INCH order)

    public static let allInch: [Drill] = wire + letter + frac

    // MARK: - Nearest drill lookups

    /// Returns the drill in `allInch` whose diameter is closest to `target` (inches).
    /// Mirrors `nearestInchDrill` in app.html line 495.
    public static func nearestInch(_ target: Double) -> Drill {
        var best = allInch[0]
        var bestDelta = abs(best.dia - target)
        for entry in allInch {
            let delta = abs(entry.dia - target)
            if delta < bestDelta {
                best = entry
                bestDelta = delta
            }
        }
        return best
    }

    /// Rounds `mm` to the nearest metric drill step:
    /// 0.05 mm below 3 mm, 0.1 mm at or above 3 mm.
    /// Mirrors `nearestMetricDrill` in app.html line 506.
    public static func nearestMetricMM(_ mm: Double) -> Double {
        let step = mm < 3 ? 0.05 : 0.1
        return (mm / step).rounded() * step
    }
}
