// InsertCode.swift — Insert-code decoder and ToolChooser
// Source: m7-extraction.md §1b, §1c (node-verified 2026-07-06)
// Core = Foundation only, public, Sendable, Swift 6.

import Foundation

// MARK: - InsertCodeField

/// One decoded position in an insert designation string.
public struct InsertCodeField: Sendable {
    /// Human-readable position label, e.g. "Shape", "IC", "Summary".
    public let label: String
    /// The raw code character(s) at this position, e.g. "C" or "16".
    public let code: String
    /// Full meaning string, e.g. "80° diamond" or "1/2\u{2033} (12.7 mm)".
    public let meaning: String

    public init(label: String, code: String, meaning: String) {
        self.label = label
        self.code = code
        self.meaning = meaning
    }
}

// MARK: - InsertCode

/// Decodes ANSI / ISO insert designation strings into labelled fields.
public enum InsertCode {

    // ── Lookup tables (node-verified) ────────────────────────────────────

    private static let insShape: [Character: String] = [
        "A": "85° parallelogram",
        "B": "82° parallelogram",
        "C": "80° diamond",
        "D": "55° diamond",
        "E": "75° diamond",
        "H": "hexagon",
        "K": "55° parallelogram",
        "L": "rectangle",
        "M": "86° diamond",
        "O": "octagon",
        "P": "pentagon",
        "R": "round",
        "S": "square 90°",
        "T": "triangle 60°",
        "V": "35° diamond",
        "W": "trigon 80° × 3",
        "X": "special",
    ]

    /// Relief letter → clearance degrees (N=0 means negative-rake).
    private static let insClear: [Character: Int] = [
        "A": 3, "B": 5, "C": 7, "D": 15, "E": 20, "F": 25, "G": 30, "N": 0, "P": 11,
    ]

    private static let insTol: [Character: String] = [
        "G": "ground periphery — precision",
        "E": "ground — close",
        "M": "molded — standard sintered (IC tolerance grows with size)",
        "U": "molded utility — widest",
    ]

    private static let insType: [Character: String] = [
        "N": "no hole, no chipbreaker — clamp-down (ceramics, plain tops)",
        "A": "hole, plain top — clamp or pin",
        "R": "no hole, chipbreaker one face",
        "F": "no hole, chipbreakers both faces",
        "M": "hole, chipbreaker one face",
        "G": "hole, chipbreakers both faces — double-sided",
        "W": "countersunk hole, plain — screw-down",
        "T": "countersunk hole + chipbreaker one face — the screw-lock positive",
        "U": "countersunk hole, chipbreakers both faces",
        "X": "special",
    ]

    /// ISO IC edge-length codes: shape → (edgeCode → IC mm)
    private static let insIC: [Character: [String: Double]] = [
        "C": ["06": 6.35,  "09": 9.525, "12": 12.7, "16": 15.875, "19": 19.05],
        "D": ["07": 6.35,  "11": 9.525, "15": 12.7],
        "S": ["06": 6.35,  "09": 9.525, "12": 12.7, "15": 15.875, "19": 19.05],
        "T": ["11": 6.35,  "16": 9.525, "22": 12.7, "27": 15.875, "33": 19.05],
        "V": ["11": 6.35,  "16": 9.525],
        "W": ["06": 9.525, "08": 12.7],
        "K": ["16": 9.525],
    ]

    /// ISO thickness codes (code → mm)
    private static let insThk: [String: Double] = [
        "01": 1.59, "02": 2.38, "03": 3.18, "T3": 3.97,
        "04": 4.76, "06": 6.35, "07": 7.94,
    ]

    /// Fractional-inch lookup table (mm → fraction string with ″).
    private static let mmInTable: [(key: Double, frac: String)] = [
        (0.2,    "≈.008\u{2033}"),
        (0.4,    "1/64\u{2033}"),
        (0.8,    "1/32\u{2033}"),
        (1.2,    "3/64\u{2033}"),
        (1.59,   "1/16\u{2033}"),
        (1.6,    "1/16\u{2033}"),
        (2.38,   "3/32\u{2033}"),
        (2.4,    "3/32\u{2033}"),
        (3.18,   "1/8\u{2033}"),
        (3.97,   "5/32\u{2033}"),
        (4.76,   "3/16\u{2033}"),
        (6.35,   "1/4\u{2033}"),
        (7.94,   "5/16\u{2033}"),
        (9.525,  "3/8\u{2033}"),
        (12.7,   "1/2\u{2033}"),
        (15.875, "5/8\u{2033}"),
        (19.05,  "3/4\u{2033}"),
    ]

    // ── Helpers ───────────────────────────────────────────────────────────

    /// Nearest-match lookup → (fraction string, matched key mm).
    private static func insIn(_ mm: Double) -> (frac: String, key: Double) {
        var best = mmInTable[0]
        var bestDist = abs(mm - best.key)
        for entry in mmInTable.dropFirst() {
            let d = abs(mm - entry.key)
            if d < bestDist { bestDist = d; best = entry }
        }
        return (best.frac, best.key)
    }

    /// Format a mm value with up to 5 significant figures, stripping trailing zeros.
    private static func fmtMM(_ v: Double) -> String { String(format: "%.5g", v) }

    /// Build the IC / thickness / nose-radius meaning string.
    private static func dimMeaning(_ mm: Double) -> String {
        let (frac, key) = insIn(mm)
        return "\(frac) (\(fmtMM(key)) mm)"
    }

    // ── ANSI size parser ──────────────────────────────────────────────────

    private struct ANSISize {
        let icDigit: Double   // e.g. 4.0
        let tDigit: Double    // e.g. 3.0 or 1.5
        let rDigit: Int       // e.g. 2
        let rawCode: String   // original size substring, e.g. "432" or "21.51"
    }

    /// Returns nil if `s` does not match the ANSI size pattern.
    private static func parseANSI(_ s: String) -> ANSISize? {
        let chars = Array(s)
        guard chars.count >= 3 else { return nil }

        // Position 0: single digit (IC in eighths)
        guard let d0 = chars[0].wholeNumberValue else { return nil }

        // Position 1: single digit or digit.5 (thickness in sixteenths)
        guard let d1 = chars[1].wholeNumberValue else { return nil }
        var pos = 2
        let tDigit: Double
        if pos + 1 < chars.count && chars[pos] == "." && chars[pos + 1] == "5" {
            tDigit = Double(d1) + 0.5
            pos += 2
        } else {
            tDigit = Double(d1)
        }

        // Next position: single digit (nose radius in sixty-fourths)
        guard pos < chars.count, let d2 = chars[pos].wholeNumberValue else { return nil }
        pos += 1

        // Remaining must be empty or start with a letter (chipbreaker suffix)
        if pos < chars.count && !chars[pos].isLetter { return nil }

        return ANSISize(icDigit: Double(d0), tDigit: tDigit, rDigit: d2, rawCode: s)
    }

    // ── ISO size parser ───────────────────────────────────────────────────

    private struct ISOSize {
        let edgeCode: String  // e.g. "16"
        let thkCode: String   // e.g. "04" or "T3"
        let nrCode: String    // e.g. "08"
        let rawCode: String   // original size substring
    }

    /// Returns nil if `s` does not match the ISO size pattern.
    private static func parseISO(_ s: String) -> ISOSize? {
        let chars = Array(s)
        guard chars.count >= 6 else { return nil }

        // First two chars: edge-length digits
        guard chars[0].isNumber, chars[1].isNumber else { return nil }
        let edgeCode = String(chars[0...1])
        var pos = 2

        // Thickness: T\d or \d{2}
        let thkCode: String
        if pos + 1 < chars.count {
            if chars[pos] == "T" && chars[pos + 1].isNumber {
                thkCode = String(chars[pos...pos + 1])
                pos += 2
            } else if chars[pos].isNumber && chars[pos + 1].isNumber {
                thkCode = String(chars[pos...pos + 1])
                pos += 2
            } else {
                return nil
            }
        } else {
            return nil
        }

        // Nose-radius code: \d{2} or [A-Z]\d
        guard pos + 1 < chars.count else { return nil }
        let nrCode: String
        if chars[pos].isNumber && chars[pos + 1].isNumber {
            nrCode = String(chars[pos...pos + 1])
            pos += 2
        } else if chars[pos].isLetter && chars[pos + 1].isNumber {
            nrCode = String(chars[pos...pos + 1])
            pos += 2
        } else {
            return nil
        }

        // Optional suffix: letters/digits/hyphens only
        if pos < chars.count {
            let rest = chars[pos...]
            for ch in rest where !ch.isLetter && !ch.isNumber && ch != "-" { return nil }
        }

        return ISOSize(edgeCode: edgeCode, thkCode: thkCode, nrCode: nrCode, rawCode: s)
    }

    // ── Public API ────────────────────────────────────────────────────────

    /// Decode an insert designation string into labelled fields.
    /// Returns an empty array for completely unparseable input.
    public static func decode(_ code: String) -> [InsertCodeField] {
        // 1. Clean: uppercase, strip chars that are not A-Z, 0-9, or "."
        let clean = String(code.uppercased().filter { $0.isLetter || $0.isNumber || $0 == "." })
        guard clean.count >= 4 else { return [] }

        let chars = Array(clean)
        let shapeCh  = chars[0]
        let clearCh  = chars[1]
        let tolCh    = chars[2]
        let typeCh   = chars[3]
        let sizeStr  = clean.count > 4 ? String(chars[4...]) : ""

        // 2. Shape must be recognised
        guard let shapeMeaning = insShape[shapeCh] else { return [] }

        var fields: [InsertCodeField] = []

        // Position 1 — Shape
        fields.append(.init(label: "Shape", code: String(shapeCh), meaning: shapeMeaning))

        // Position 2 — Relief / clearance
        let clearDeg = insClear[clearCh]
        let clearMeaning: String
        if let deg = clearDeg {
            clearMeaning = deg == 0 ? "0° (negative)" : "\(deg)° (positive)"
        } else {
            clearMeaning = String(clearCh)
        }
        fields.append(.init(label: "Relief", code: String(clearCh), meaning: clearMeaning))

        // Position 3 — Tolerance
        if let tolMeaning = insTol[tolCh] {
            fields.append(.init(label: "Tolerance", code: String(tolCh), meaning: tolMeaning))
        }

        // Position 4 — Hole / chipbreaker type
        if let typeMeaning = insType[typeCh] {
            fields.append(.init(label: "Type", code: String(typeCh), meaning: typeMeaning))
        }

        // 3. Size fields
        var sizeFormat = ""   // "ANSI" or "ISO"
        var sizeCode   = sizeStr

        if !sizeStr.isEmpty {
            if let ansi = parseANSI(sizeStr) {
                sizeFormat = "ANSI"
                sizeCode   = ansi.rawCode

                let icMM = ansi.icDigit * 3.175
                let thkMM = ansi.tDigit * 1.5875
                let nrMM  = Double(ansi.rDigit) * 0.396875

                fields.append(.init(label: "IC",        code: String(Int(ansi.icDigit)), meaning: dimMeaning(icMM)))
                fields.append(.init(label: "Thickness", code: ansi.tDigit == Double(Int(ansi.tDigit))
                                                               ? String(Int(ansi.tDigit))
                                                               : String(ansi.tDigit),
                                    meaning: dimMeaning(thkMM)))
                fields.append(.init(label: "Corner R",  code: String(ansi.rDigit), meaning: dimMeaning(nrMM)))

            } else if let iso = parseISO(sizeStr) {
                sizeFormat = "ISO"
                sizeCode   = iso.rawCode

                // IC from shape-keyed table
                if let icMM = insIC[shapeCh]?[iso.edgeCode] {
                    fields.append(.init(label: "IC", code: iso.edgeCode, meaning: dimMeaning(icMM)))
                }

                // Thickness
                if let thkMM = insThk[iso.thkCode] {
                    fields.append(.init(label: "Thickness", code: iso.thkCode, meaning: dimMeaning(thkMM)))
                }

                // Nose radius: nrCode as integer ÷ 10
                if let nrInt = Int(iso.nrCode) {
                    let nrMM = Double(nrInt) / 10.0
                    fields.append(.init(label: "Corner R", code: iso.nrCode, meaning: dimMeaning(nrMM)))
                }
            }
        }

        // 4. Holder seat
        let seatMeaning: String
        if typeCh == "T" || typeCh == "W" || typeCh == "U" {
            seatMeaning = "screw-lock seats (SCLCR style)"
        } else if clearDeg == 0 {
            seatMeaning = "negative seats — pin / top clamp (MCLNR style)"
        } else {
            seatMeaning = "clamp or pin seats"
        }
        fields.append(.init(label: "Seat", code: "", meaning: seatMeaning))

        // 5. Summary
        let clearDesc: String
        if let deg = clearDeg {
            clearDesc = deg == 0 ? "negative" : "positive \(deg)°"
        } else {
            clearDesc = String(clearCh)
        }
        let summaryMeaning: String
        if sizeFormat.isEmpty {
            summaryMeaning = "\(shapeMeaning), \(clearDesc)"
        } else {
            summaryMeaning = "\(shapeMeaning), \(clearDesc) · \(sizeFormat) \(sizeCode)"
        }
        fields.append(.init(label: "Summary", code: "", meaning: summaryMeaning))

        return fields
    }
}

// MARK: - ToolRecommendation

public struct ToolRecommendation: Sendable {
    /// Recommended holder code, e.g. "MCLNR" or "SCLCR".
    public let holder: String
    /// Recommended insert + engagement note, e.g. "CNMG — negative, double-sided".
    public let insert: String
    /// Geometry rationale + nose-radius note.
    public let note: String

    public init(holder: String, insert: String, note: String) {
        self.holder = holder
        self.insert = insert
        self.note   = note
    }
}

// MARK: - SegmentOption

/// One (key, display-label) pair for a ToolChooser wizard segment.
public struct SegmentOption: Sendable {
    /// Web-key string used in decision logic, e.g. "sq", "rough", "alu".
    public let key: String
    /// Human-readable label for the UI, e.g. "Square Corner", "Rough", "Aluminum".
    public let label: String

    public init(key: String, label: String) {
        self.key   = key
        self.label = label
    }
}

// MARK: - ToolChooser

/// Tool recommendation decision tree from app-new.html lines 4017–4238.
/// All parameter names and defaults mirror the web wizard (m7-extraction.md §1c).
public enum ToolChooser {

    // ── Segment option arrays (key + display label) ───────────────────────

    /// Operation segment — 5 options.
    public static let opOptions: [SegmentOption] = [
        SegmentOption(key: "turn",   label: "Turn"),
        SegmentOption(key: "face",   label: "Face"),
        SegmentOption(key: "prof",   label: "Profile"),
        SegmentOption(key: "bore",   label: "Bore"),
        SegmentOption(key: "thread", label: "Thread"),
    ]

    /// Workpiece feature (turning) — 2 options.
    public static let featOptions: [SegmentOption] = [
        SegmentOption(key: "plain", label: "Plain"),
        SegmentOption(key: "sq",    label: "Square Corner"),
    ]

    /// Bore feature — 3 options.
    public static let bfeatOptions: [SegmentOption] = [
        SegmentOption(key: "thru",  label: "Through"),
        SegmentOption(key: "blind", label: "Blind"),
        SegmentOption(key: "prof",  label: "Profile"),
    ]

    /// Cut type — 3 options.
    public static let cutOptions: [SegmentOption] = [
        SegmentOption(key: "rough", label: "Rough"),
        SegmentOption(key: "gen",   label: "General"),
        SegmentOption(key: "fin",   label: "Finish"),
    ]

    /// Material — 6 options.
    public static let matOptions: [SegmentOption] = [
        SegmentOption(key: "steel", label: "Steel"),
        SegmentOption(key: "ss",    label: "Stainless"),
        SegmentOption(key: "ci",    label: "Cast Iron"),
        SegmentOption(key: "alu",   label: "Aluminum"),
        SegmentOption(key: "pl",    label: "Plastic"),
        SegmentOption(key: "hard",  label: "Hardened"),
    ]

    /// Machine / setup rigidity — 3 options.
    public static let machOptions: [SegmentOption] = [
        SegmentOption(key: "light",  label: "Light"),
        SegmentOption(key: "mid",    label: "Medium"),
        SegmentOption(key: "rigid",  label: "Rigid"),
    ]

    // ── Backward-compat flat key arrays ──────────────────────────────────

    /// All operation keys (derived from opOptions).
    public static var ops: [String] { opOptions.map(\.key) }

    /// All material keys (derived from matOptions).
    public static var materials: [String] { matOptions.map(\.key) }

    /// All rigidity / machine keys (derived from machOptions).
    public static var rigidities: [String] { machOptions.map(\.key) }

    // ── Geometry record ───────────────────────────────────────────────────

    private struct Geo {
        let hl: String   // left-hand (positive) holder
        let hr: String   // right-hand / negative holder
        let pos: String  // positive insert
        let gt: String   // polished GT insert (soft materials)
        let neg: String  // negative insert
        let why: String  // rationale text
    }

    // ── Geometry constants (§1c decision table, verbatim) ─────────────────

    /// turn + feat=sq  →  D 55°, 93° lead
    private static let geoTurnSq = Geo(
        hl: "SDJCR", hr: "MDJNR", pos: "DCMT", gt: "DCGT", neg: "DNMG",
        why: "55\u{00B0} point reaches into a square corner"
    )

    /// turn + rough + rigid + !soft  →  S 90°, 45° lead
    private static let geoTurnStrong = Geo(
        hl: "SSDCN", hr: "MSSNR", pos: "SCMT", gt: "SCGT", neg: "SNMG",
        why: "45\u{00B0} lead thins chip; square corner strongest"
    )

    /// turn default (plain)  →  C 80°, 95° lead
    private static let geoTurn = Geo(
        hl: "SCLCR", hr: "MCLNR", pos: "CCMT", gt: "CCGT", neg: "CNMG",
        why: "everyday geometry; 95\u{00B0} turns up to square shoulder"
    )

    /// face  →  T 60°, 90° lead
    private static let geoFace = Geo(
        hl: "STFCR", hr: "MTFNR", pos: "TCMT", gt: "TCGT", neg: "TNMG",
        why: "90\u{00B0} lead presents edge square to face"
    )

    /// profiling  →  V 35°, 93° lead
    private static let geoProf = Geo(
        hl: "SVJBR", hr: "MVJNR", pos: "VBMT", gt: "VBGT", neg: "VNMG",
        why: "slim 35\u{00B0} point clears both flanks"
    )

    /// bore + blind  →  D 55°, 93° lead boring bar
    private static let geoBoreBlind = Geo(
        hl: "SDUCR bar", hr: "SDUCR bar", pos: "DCMT", gt: "DCGT", neg: "DCMT",
        why: "93\u{00B0} with 55\u{00B0} reaches corner of blind bore"
    )

    /// bore + prof  →  V 35°, 93° lead boring bar
    private static let geoBoreProf = Geo(
        hl: "SVUCR bar", hr: "SVUCR bar", pos: "VBMT", gt: "VBGT", neg: "VBMT",
        why: "profiling inside; wider points foul"
    )

    /// bore (thru, default)  →  C 80°, 95° lead boring bar
    private static let geoBore = Geo(
        hl: "SCLCR bar", hr: "SCLCR bar", pos: "CCMT", gt: "CCGT", neg: "CCMT",
        why: "through bore default geometry"
    )

    // ── Public recommend ──────────────────────────────────────────────────

    /// Returns a tool recommendation for the given wizard selections.
    ///
    /// Parameter names and defaults mirror the web wizard (m7-extraction.md §1c):
    /// - `op`    operation key            default "turn"
    /// - `feat`  turning workpiece feature default "plain"
    /// - `bfeat` bore feature             default "thru"
    /// - `cut`   cut type                 default "gen"
    /// - `mat`   material key             default "steel"
    /// - `mach`  machine/rigidity key     default "light"
    public static func recommend(
        op:    String = "turn",
        feat:  String = "plain",
        bfeat: String = "thru",
        cut:   String = "gen",
        mat:   String = "steel",
        mach:  String = "light"
    ) -> ToolRecommendation {

        // Thread is a special case — laydown insert, no geometry table
        if op == "thread" {
            return ToolRecommendation(
                holder: "CER (ext) / CIR (int)",
                insert: "16ER/16IR",
                note:   "laydown insert, pitch-matched"
            )
        }

        // soft = alu or plastic  (§1c verbatim)
        let soft = (mat == "alu" || mat == "pl")

        // wantNeg: prefer negative insert  (§1c verbatim)
        // !soft && op≠bore && (rigid || (mid && rough))
        let wantNeg = !soft && op != "bore" &&
                      (mach == "rigid" || (mach == "mid" && cut == "rough"))

        // ── Geometry selection (§1c table, in order) ──────────────────────
        let g: Geo
        switch op {
        case "turn":
            if feat == "sq" {
                g = geoTurnSq
            } else if !soft && cut == "rough" && mach == "rigid" {
                // S 90° only when rigid (not mid) — matches §1c row exactly
                g = geoTurnStrong
            } else {
                g = geoTurn
            }
        case "face":
            g = geoFace
        case "prof":
            g = geoProf
        case "bore":
            switch bfeat {
            case "blind": g = geoBoreBlind
            case "prof":  g = geoBoreProf
            default:      g = geoBore      // thru is default
            }
        default:
            return ToolRecommendation(holder: "—", insert: "—", note: "unknown op")
        }

        // ── Holder selection (§1c verbatim) ───────────────────────────────
        let holder = wantNeg ? g.hr : g.hl

        // ── Insert selection (§1c verbatim) ───────────────────────────────
        let insert: String
        if mat == "hard" {
            insert = "CBN / ceramic insert in the same seat"
        } else if soft {
            insert = "\(g.gt) \u{2014} polished GT"
        } else if wantNeg {
            insert = "\(g.neg) \u{2014} negative, double-sided"
        } else {
            insert = "\(g.pos) \u{2014} positive, single-sided"
        }

        // ── Nose-radius note (§1c verbatim) ───────────────────────────────
        let noseNote: String
        switch cut {
        case "rough":
            noseNote = "1/32\u{2013}3/64\u{2033} (0.8\u{2013}1.2 mm) \u{2014} ANSI last digit 2\u{2013}3"
        case "fin":
            noseNote = "1/64\u{2033} (0.4 mm) \u{2014} last digit 1 \u{00B7} keep feed \u{2264} r/2"
        default:  // gen
            noseNote = "1/32\u{2033} (0.8 mm) \u{2014} last digit 2"
        }

        return ToolRecommendation(holder: holder, insert: insert,
                                  note: "\(g.why) \u{00B7} \(noseNote)")
    }
}
