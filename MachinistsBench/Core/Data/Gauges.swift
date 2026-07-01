// Gauges.swift — wire/sheet gauge tables (SWG, USS, AWG) + nearest-gauge lookup.
// SWG and USS verbatim from app.html (~lines 510, 559).
// AWG computed via awgDia(n) = 0.005 * 92^((36-n)/39), n = -3…40,
// labels "0000","000","00","0","1"…"40" — verified with node.

import Foundation

public struct Gauge: Sendable {
    public let label: String
    public let dia: Double

    public init(label: String, dia: Double) {
        self.label = label
        self.dia = dia
    }
}

public enum Gauges {

    // MARK: - SWG (Standard Wire Gauge / British) — 47 rows, gauge 7/0 → 40
    // Verbatim from app.html line 510

    public static let swg: [Gauge] = [
        Gauge(label: "7/0", dia: 0.5),
        Gauge(label: "6/0", dia: 0.464),
        Gauge(label: "5/0", dia: 0.432),
        Gauge(label: "4/0", dia: 0.4),
        Gauge(label: "3/0", dia: 0.372),
        Gauge(label: "2/0", dia: 0.348),
        Gauge(label: "0", dia: 0.324),
        Gauge(label: "1", dia: 0.3),
        Gauge(label: "2", dia: 0.276),
        Gauge(label: "3", dia: 0.252),
        Gauge(label: "4", dia: 0.232),
        Gauge(label: "5", dia: 0.212),
        Gauge(label: "6", dia: 0.192),
        Gauge(label: "7", dia: 0.176),
        Gauge(label: "8", dia: 0.16),
        Gauge(label: "9", dia: 0.144),
        Gauge(label: "10", dia: 0.128),
        Gauge(label: "11", dia: 0.116),
        Gauge(label: "12", dia: 0.104),
        Gauge(label: "13", dia: 0.092),
        Gauge(label: "14", dia: 0.08),
        Gauge(label: "15", dia: 0.072),
        Gauge(label: "16", dia: 0.064),
        Gauge(label: "17", dia: 0.056),
        Gauge(label: "18", dia: 0.048),
        Gauge(label: "19", dia: 0.04),
        Gauge(label: "20", dia: 0.036),
        Gauge(label: "21", dia: 0.032),
        Gauge(label: "22", dia: 0.028),
        Gauge(label: "23", dia: 0.024),
        Gauge(label: "24", dia: 0.022),
        Gauge(label: "25", dia: 0.02),
        Gauge(label: "26", dia: 0.018),
        Gauge(label: "27", dia: 0.0164),
        Gauge(label: "28", dia: 0.0148),
        Gauge(label: "29", dia: 0.0136),
        Gauge(label: "30", dia: 0.0124),
        Gauge(label: "31", dia: 0.0116),
        Gauge(label: "32", dia: 0.0108),
        Gauge(label: "33", dia: 0.01),
        Gauge(label: "34", dia: 0.0092),
        Gauge(label: "35", dia: 0.0084),
        Gauge(label: "36", dia: 0.0076),
        Gauge(label: "37", dia: 0.0068),
        Gauge(label: "38", dia: 0.006),
        Gauge(label: "39", dia: 0.0052),
        Gauge(label: "40", dia: 0.0048),
    ]

    // MARK: - USS (US Standard Sheet Steel) — 28 rows, gauge 3 → 30
    // Verbatim from app.html line 559

    public static let uss: [Gauge] = [
        Gauge(label: "3",  dia: 0.2391),
        Gauge(label: "4",  dia: 0.2242),
        Gauge(label: "5",  dia: 0.2092),
        Gauge(label: "6",  dia: 0.1943),
        Gauge(label: "7",  dia: 0.1793),
        Gauge(label: "8",  dia: 0.1644),
        Gauge(label: "9",  dia: 0.1495),
        Gauge(label: "10", dia: 0.1345),
        Gauge(label: "11", dia: 0.1196),
        Gauge(label: "12", dia: 0.1046),
        Gauge(label: "13", dia: 0.0897),
        Gauge(label: "14", dia: 0.0747),
        Gauge(label: "15", dia: 0.0673),
        Gauge(label: "16", dia: 0.0598),
        Gauge(label: "17", dia: 0.0538),
        Gauge(label: "18", dia: 0.0478),
        Gauge(label: "19", dia: 0.0418),
        Gauge(label: "20", dia: 0.0359),
        Gauge(label: "21", dia: 0.0329),
        Gauge(label: "22", dia: 0.0299),
        Gauge(label: "23", dia: 0.0269),
        Gauge(label: "24", dia: 0.0239),
        Gauge(label: "25", dia: 0.0209),
        Gauge(label: "26", dia: 0.0179),
        Gauge(label: "27", dia: 0.0164),
        Gauge(label: "28", dia: 0.0149),
        Gauge(label: "29", dia: 0.0135),
        Gauge(label: "30", dia: 0.012),
    ]

    // MARK: - AWG (American Wire Gauge) — 44 rows, gauge 0000 → 40
    // Computed via awgDia(n) = 0.005 * 92^((36-n)/39), n = -3…40
    // Values generated via node for exact IEEE 754 match with source.

    public static let awg: [Gauge] = [
        Gauge(label: "0000", dia: 0.46),
        Gauge(label: "000",  dia: 0.40964183004149546),
        Gauge(label: "00",   dia: 0.36479658460814224),
        Gauge(label: "0",    dia: 0.324860740242971),
        Gauge(label: "1",    dia: 0.2892968437864468),
        Gauge(label: "2",    dia: 0.25762627937806243),
        Gauge(label: "3",    dia: 0.2294228272852414),
        Gauge(label: "4",    dia: 0.2043069278748266),
        Gauge(label: "5",    dia: 0.18194057353217344),
        Gauge(label: "6",    dia: 0.1620227597837366),
        Gauge(label: "7",    dia: 0.14428543440474667),
        Gauge(label: "8",    dia: 0.12848988999541863),
        Gauge(label: "9",    dia: 0.1144235514772907),
        Gauge(label: "10",   dia: 0.10189711527609699),
        Gauge(label: "11",   dia: 0.09074200169054264),
        Gauge(label: "12",   dia: 0.08080808616117904),
        Gauge(label: "13",   dia: 0.07196167890699179),
        Gauge(label: "14",   dia: 0.06408372573982303),
        Gauge(label: "15",   dia: 0.057068205843344336),
        Gauge(label: "16",   dia: 0.050820704954026824),
        Gauge(label: "17",   dia: 0.04525714474210097),
        Gauge(label: "18",   dia: 0.04030265129262411),
        Gauge(label: "19",   dia: 0.03589054745877126),
        Gauge(label: "20",   dia: 0.031961455526526523),
        Gauge(label: "21",   dia: 0.028462498114513474),
        Gauge(label: "22",   dia: 0.025346586554743283),
        Gauge(label: "23",   dia: 0.022571787177370007),
        Gauge(label: "24",   dia: 0.02010075697096742),
        Gauge(label: "25",   dia: 0.017900241023492258),
        Gauge(label: "26",   dia: 0.015940624980537436),
        Gauge(label: "27",   dia: 0.014195536497896812),
        Gauge(label: "28",   dia: 0.012641490324824547),
        Gauge(label: "29",   dia: 0.011257572241549971),
        Gauge(label: "30",   dia: 0.01002515759750624),
        Gauge(label: "31",   dia: 0.008927660662384474),
        Gauge(label: "32",   dia: 0.007950311416801404),
        Gauge(label: "33",   dia: 0.007079956778648524),
        Gauge(label: "34",   dia: 0.006304883590044072),
        Gauge(label: "35",   dia: 0.005614660982661407),
        Gauge(label: "36",   dia: 0.005),
        Gauge(label: "37",   dia: 0.004452628587407559),
        Gauge(label: "38",   dia: 0.003965180267479808),
        Gauge(label: "39",   dia: 0.0035310950026409887),
        Gauge(label: "40",   dia: 0.0031445309107222476),
    ]

    // MARK: - Nearest gauge lookup

    /// Returns the row in `table` whose `.dia` is closest to `fv` (in inches).
    public static func nearest(_ table: [Gauge], toIn fv: Double) -> Gauge {
        table.min(by: { abs($0.dia - fv) < abs($1.dia - fv) })!
    }
}
