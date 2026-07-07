// ToolingRef.swift — Insert / tooling reference tables
// Source: m7-extraction.md §1c (holder codes), §1d (insert cards, grades, nose radii), §2 (tool styles)
// Node-verified 2026-07-06.
// Core = Foundation only, public, Sendable, Swift 6.

import Foundation

// MARK: - Row types

/// One row of the ISO insert-grade / material-class table (6 entries).
public struct InsertGradeRow: Sendable {
    /// ISO letter, e.g. "P"
    public let letter: String
    /// Workpiece material family, e.g. "Steel"
    public let material: String
    /// Web color token string, e.g. "S.blue"
    public let colorToken: String

    public init(letter: String, material: String, colorToken: String) {
        self.letter     = letter
        self.material   = material
        self.colorToken = colorToken
    }
}

/// One row of the nose-radius / feed / finish table (4 entries).
public struct InsertNoseRadiusRow: Sendable {
    /// Radius in mm, e.g. 0.4
    public let radiusMM: Double
    /// Label string, e.g. "0.4 mm (R01)"
    public let radiusLabel: String
    /// Cut type label, e.g. "Finishing"
    public let cutType: String
    /// Chip-load range string, e.g. "0.002–0.006"
    public let chipLoad: String
    /// Depth-of-cut range string, e.g. "0.005–0.040\u{2033}"
    public let doc: String
    /// Notes
    public let notes: String

    public init(radiusMM: Double, radiusLabel: String, cutType: String,
                chipLoad: String, doc: String, notes: String) {
        self.radiusMM    = radiusMM
        self.radiusLabel = radiusLabel
        self.cutType     = cutType
        self.chipLoad    = chipLoad
        self.doc         = doc
        self.notes       = notes
    }
}

/// One of the 7 highlighted insert-card entries.
public struct InsertCardRow: Sendable {
    /// Insert code, e.g. "CNMG"
    public let code: String
    /// Included angle in degrees, e.g. 80
    public let ang: Int
    /// Shape key string, e.g. "diamond"
    public let sh: String
    /// Number of cutting edges, e.g. 4
    public let edges: Int
    /// Relief description, e.g. "Negative 0°"
    public let relief: String
    /// Slash-separated ISO size designations, e.g. "CNMG 120404/120408/120412"
    public let isoSizes: String
    /// Slash-separated ANSI size designations, e.g. "CNMG 431/432/433"
    public let ansiSizes: String
    /// Available nose radii string, e.g. "0.4/0.8/1.2 mm"
    public let radii: String
    /// Web highlight color token, e.g. "S.amber"
    public let highlight: String
    /// Comma-separated use tags, e.g. "Steel,Roughing,Interrupted,Cast Iron"
    public let useTags: String
    /// Verbatim note from the web card
    public let note: String
    /// True for WNMG and TNMG; false for others (per m7-extraction.md §1d)
    public let yours: Bool

    public init(code: String, ang: Int, sh: String, edges: Int, relief: String,
                isoSizes: String, ansiSizes: String, radii: String,
                highlight: String, useTags: String, note: String, yours: Bool) {
        self.code      = code
        self.ang       = ang
        self.sh        = sh
        self.edges     = edges
        self.relief    = relief
        self.isoSizes  = isoSizes
        self.ansiSizes = ansiSizes
        self.radii     = radii
        self.highlight = highlight
        self.useTags   = useTags
        self.note      = note
        self.yours     = yours
    }
}

/// One row of the ISO 5608 holder-code table (9 entries).
public struct HolderCodeRow: Sendable {
    /// Position label, e.g. "1 · clamp"
    public let position: String
    /// Codes and descriptions at this position
    public let codes: String

    public init(position: String, codes: String) {
        self.position = position
        self.codes    = codes
    }
}

/// One row of the Ra finish table (5 rows, §1d — header: Ra (µin) ≈ feed² ÷ (32 × radius)).
public struct RaFinishRow: Sendable {
    /// Feed rate string, e.g. "0.003\u{2033}"
    public let feed: String
    /// Ra (µin) at 0.4 mm nose radius
    public let ra04: Int
    /// Ra (µin) at 0.8 mm nose radius
    public let ra08: Int
    /// Ra (µin) at 1.2 mm nose radius
    public let ra12: Int
    /// Ra (µin) at 1.6 mm nose radius
    public let ra16: Int

    public init(feed: String, ra04: Int, ra08: Int, ra12: Int, ra16: Int) {
        self.feed = feed
        self.ra04 = ra04
        self.ra08 = ra08
        self.ra12 = ra12
        self.ra16 = ra16
    }
}

/// One HSS tool-style card (5 shown in the `hss` view).
public struct ToolStyleRow: Sendable {
    /// Type key matching ToolStyleSVG, e.g. "rh"
    public let typeKey: String
    /// Display name, e.g. "Right-Hand Turning"
    public let name: String
    /// Description text
    public let description: String

    public init(typeKey: String, name: String, description: String) {
        self.typeKey     = typeKey
        self.name        = name
        self.description = description
    }
}

// MARK: - ToolingRef

/// All tooling reference tables ported verbatim from m7-extraction.md §1c–d, §2.
public enum ToolingRef {

    // MARK: ISO Grades & Coatings — 6 rows

    public static let insertGrades: [InsertGradeRow] = [
        InsertGradeRow(letter: "P", material: "Steel",         colorToken: "S.blue"),
        InsertGradeRow(letter: "M", material: "Stainless",     colorToken: "S.teal"),
        InsertGradeRow(letter: "K", material: "Cast Iron",     colorToken: "S.mut2"),
        InsertGradeRow(letter: "N", material: "Non-ferrous",   colorToken: "S.green"),
        InsertGradeRow(letter: "S", material: "Superalloy",    colorToken: "S.red"),
        InsertGradeRow(letter: "H", material: "Hardened",      colorToken: "S.amber"),
    ]

    // MARK: Nose Radii / Feed Rate / Finish — 4 rows

    public static let insertNoseRadii: [InsertNoseRadiusRow] = [
        InsertNoseRadiusRow(
            radiusMM:    0.4,
            radiusLabel: "0.4 mm (R01)",
            cutType:     "Finishing",
            chipLoad:    "0.002–0.006",
            doc:         "0.005–0.040\u{2033}",
            notes:       "Soft metals and fine finishing; fragile edge"
        ),
        InsertNoseRadiusRow(
            radiusMM:    0.8,
            radiusLabel: "0.8 mm (R02)",
            cutType:     "General",
            chipLoad:    "0.004–0.012",
            doc:         "0.010–0.080\u{2033}",
            notes:       "All-round; the default choice"
        ),
        InsertNoseRadiusRow(
            radiusMM:    1.2,
            radiusLabel: "1.2 mm (R03)",
            cutType:     "Semi-rough",
            chipLoad:    "0.006–0.020",
            doc:         "0.020–0.150\u{2033}",
            notes:       "Strong edge; tolerates scale & interruptions"
        ),
        InsertNoseRadiusRow(
            radiusMM:    1.6,
            radiusLabel: "1.6 mm (R04)",
            cutType:     "Roughing",
            chipLoad:    "0.010–0.030",
            doc:         "0.050–0.250\u{2033}",
            notes:       "Max strength; high radial force, needs rigidity"
        ),
    ]

    // MARK: Insert Cards — 7 rows

    public static let insertCards: [InsertCardRow] = [
        InsertCardRow(
            code:      "WNMG",
            ang:       80,
            sh:        "trigon",
            edges:     6,
            relief:    "Negative 0°",
            isoSizes:  "WNMG 080404/080408/080412",
            ansiSizes: "WNMG 431/432/433",
            radii:     "0.4/0.8/1.2 mm",
            highlight: "S.blue",
            useTags:   "Steel,Alloy,Stainless,Cast Iron",
            note:      "80° trigon — 6 edges, strong corner. Rough-to-semi-finish turning & facing. Most common: WNMG 432 = 080408.",
            yours:     true
        ),
        InsertCardRow(
            code:      "TNMG",
            ang:       60,
            sh:        "triangle",
            edges:     6,
            relief:    "Negative 0°",
            isoSizes:  "TNMG 160404/160408/220408",
            ansiSizes: "TNMG 331/332/432",
            radii:     "0.4/0.8/1.2 mm",
            highlight: "S.teal",
            useTags:   "Steel,Stainless,Finishing",
            note:      "Triangle — 6 edges, good shoulder access. Semi-finish & finish. Most common: TNMG 332 = 160408.",
            yours:     true
        ),
        InsertCardRow(
            code:      "CNMG",
            ang:       80,
            sh:        "diamond",
            edges:     4,
            relief:    "Negative 0°",
            isoSizes:  "CNMG 120404/120408/120412",
            ansiSizes: "CNMG 431/432/433",
            radii:     "0.4/0.8/1.2 mm",
            highlight: "S.amber",
            useTags:   "Steel,Roughing,Interrupted,Cast Iron",
            note:      "80° rhombus — 4 edges, stronger than TNMG. The heavy-roughing & interrupted-cut workhorse.",
            yours:     false
        ),
        InsertCardRow(
            code:      "DNMG",
            ang:       55,
            sh:        "diamond",
            edges:     4,
            relief:    "Negative 0°",
            isoSizes:  "DNMG 110404/110408",
            ansiSizes: "DNMG 431/432",
            radii:     "0.4/0.8 mm",
            highlight: "S.violet",
            useTags:   "Steel,Profiling,Stainless,Finishing",
            note:      "55° rhombus — profiling & shoulder work, moderate depths. Finish & semi-finish.",
            yours:     false
        ),
        InsertCardRow(
            code:      "VNMG",
            ang:       35,
            sh:        "diamond",
            edges:     2,
            relief:    "Negative 0°",
            isoSizes:  "VNMG 160404/160408",
            ansiSizes: "VNMG 331/332",
            radii:     "0.4/0.8 mm",
            highlight: "S.violet",
            useTags:   "Profiling,Finishing",
            note:      "35° — deep profiling & undercuts, 2 fragile edges. Light DOC, no interruptions.",
            yours:     false
        ),
        InsertCardRow(
            code:      "CCMT",
            ang:       80,
            sh:        "diamond",
            edges:     2,
            relief:    "Positive 7°",
            isoSizes:  "CCMT 060202/060204",
            ansiSizes: "CCMT 21.51/21.52",
            radii:     "0.2/0.4 mm",
            highlight: "S.green",
            useTags:   "Aluminum,Stainless,Finishing",
            note:      "Positive, single-sided — low cutting forces. Finishing non-ferrous, stainless, plastics.",
            yours:     false
        ),
        InsertCardRow(
            code:      "TCMT",
            ang:       60,
            sh:        "triangle",
            edges:     3,
            relief:    "Positive 7°",
            isoSizes:  "TCMT 060202/060204",
            ansiSizes: "TCMT 21.51/21.52",
            radii:     "0.2/0.4 mm",
            highlight: "S.green",
            useTags:   "Aluminum,Finishing,Boring",
            note:      "Positive triangle — light forces, common in boring bars and on low-HP lathes.",
            yours:     false
        ),
    ]

    // MARK: Holder Codes (ISO 5608) — 9 rows

    public static let holderCodes: [HolderCodeRow] = [
        HolderCodeRow(
            position: "1 · clamp",
            codes:    "C top clamp · D top+hole · M top+hole · P pin (lever) · S screw · W wedge"
        ),
        HolderCodeRow(
            position: "2 · insert",
            codes:    "C 80° · D 55° · K 55° offset · R round · S 90° · T 60° · V 35° · W 80° trigon"
        ),
        HolderCodeRow(
            position: "3 · style",
            codes:    "A 90 · B 75 · D 45 · E 60 · F 90 face · G 90 offset · J 93 · K 75 · L 95 · M 50 · N 63 · Q 107.5 · S 45 · T 60 · U 93 · V 72.5 · W 60"
        ),
        HolderCodeRow(
            position: "4 · clearance",
            codes:    "N 0° (neg) · C 7° · P 11° · B 5°"
        ),
        HolderCodeRow(
            position: "5 · hand",
            codes:    "R right · L left · N neutral"
        ),
        HolderCodeRow(
            position: "6 · shank",
            codes:    "inch: HxW in 1/16\u{2033} · metric: mm (2020=20×20)"
        ),
        HolderCodeRow(
            position: "7 · edge",
            codes:    "insert IC code"
        ),
        HolderCodeRow(
            position: "bars",
            codes:    "prefix: material (S steel/E carbide) + Ø mm + length letter e.g. S16M-SCLCR-09"
        ),
        HolderCodeRow(
            position: "QCTP",
            codes:    "AXA≤1/2\u{2033} · BXA 5/8\u{2033} · CXA 3/4\u{2033}"
        ),
    ]

    // MARK: HSS Tool Styles — 5 rows (shown in `hss` view)

    public static let toolStyles: [ToolStyleRow] = [
        ToolStyleRow(
            typeKey:     "rh",
            name:        "Right-Hand Turning",
            description: "Cuts right-to-left (toward the headstock). The everyday roughing & general tool."
        ),
        ToolStyleRow(
            typeKey:     "lh",
            name:        "Left-Hand Turning",
            description: "Cuts left-to-right; for facing away from the chuck or working a shoulder from the other side."
        ),
        ToolStyleRow(
            typeKey:     "round",
            name:        "Round-Nose",
            description: "Symmetrical; light roughing, finishing, and forming concave radii in either direction."
        ),
        ToolStyleRow(
            typeKey:     "face",
            name:        "Facing",
            description: "Edge angled to face the end of the work, feeding toward the center."
        ),
        ToolStyleRow(
            typeKey:     "part",
            name:        "Parting / Cutoff",
            description: "Narrow blade fed straight in to part off; keep it on-center and rigid."
        ),
    ]

    // MARK: Ra Finish Table — 5 rows (§1d, Ra (µin) ≈ feed² ÷ (32 × radius))

    public static let raFinishTable: [RaFinishRow] = [
        RaFinishRow(feed: "0.003\u{2033}", ra04: 18,  ra08: 9,   ra12: 6,   ra16: 4),
        RaFinishRow(feed: "0.005\u{2033}", ra04: 50,  ra08: 25,  ra12: 17,  ra16: 12),
        RaFinishRow(feed: "0.008\u{2033}", ra04: 127, ra08: 63,  ra12: 42,  ra16: 32),
        RaFinishRow(feed: "0.012\u{2033}", ra04: 286, ra08: 143, ra12: 95,  ra16: 71),
        RaFinishRow(feed: "0.020\u{2033}", ra04: 794, ra08: 397, ra12: 265, ra16: 198),
    ]
}

// MARK: - A2 Row Types (drill point, files, GD&T)

/// One row of the drill-point angle-by-material table (6 entries, §3).
public struct DrillPointAngleRow: Sendable {
    /// Material description, e.g. "General-purpose steel"
    public let material: String
    /// Included point angle, e.g. "118°"
    public let pointAngle: String
    /// Lip clearance range, e.g. "8–12°"
    public let lipClearance: String
    /// Brief notes
    public let notes: String

    public init(material: String, pointAngle: String, lipClearance: String, notes: String) {
        self.material     = material
        self.pointAngle   = pointAngle
        self.lipClearance = lipClearance
        self.notes        = notes
    }
}

/// One row of the web-thickness-by-drill-size table (5 entries, §3).
public struct DrillWebThicknessRow: Sendable {
    /// Drill diameter, e.g. "1/4\u{2033}"
    public let drillDiam: String
    /// Web thickness as percentage of diameter, e.g. "17%"
    public let webPct: String

    public init(drillDiam: String, webPct: String) {
        self.drillDiam = drillDiam
        self.webPct    = webPct
    }
}

/// One row of the file-shape card table (11 entries, §5).
public struct FileShapeRow: Sendable {
    /// Shape key matching FileXSection SVG, e.g. "flat"
    public let shapeKey: String
    /// Display name, e.g. "Flat"
    public let name: String
    /// Description text (verbatim from §5)
    public let description: String

    public init(shapeKey: String, name: String, description: String) {
        self.shapeKey    = shapeKey
        self.name        = name
        self.description = description
    }
}

/// One row of the file cut / coarseness table (5 entries, §5).
public struct FileGradeRow: Sendable {
    /// Cut name, e.g. "Bastard"
    public let cut: String
    /// Relative coarseness label, e.g. "Coarse"
    public let coarseness: String
    /// Typical use, e.g. "General roughing on steel"
    public let use: String

    public init(cut: String, coarseness: String, use: String) {
        self.cut        = cut
        self.coarseness = coarseness
        self.use        = use
    }
}

/// One row of the GD&T drawing notation table (7 entries, §6.5).
public struct GdtNotationRow: Sendable {
    /// Notation string as it appears on a drawing, e.g. "THRU"
    public let notation: String
    /// Human-readable meaning
    public let meaning: String

    public init(notation: String, meaning: String) {
        self.notation = notation
        self.meaning  = meaning
    }
}

/// One row of the GD&T 14-characteristic table (§6.5).
public struct GdtCharacteristicRow: Sendable {
    /// Control family, e.g. "FORM \u{2014} no datum"
    public let family: String
    /// Short key matching GdtSym SVG, e.g. "flat"
    public let key: String
    /// Full characteristic name, e.g. "Flatness"
    public let name: String
    /// Description (verbatim from §6.5)
    public let description: String

    public init(family: String, key: String, name: String, description: String) {
        self.family      = family
        self.key         = key
        self.name        = name
        self.description = description
    }
}

/// One row of the GD&T material-modifier table (7 entries, §6.5).
public struct GdtModifierRow: Sendable {
    /// Symbol + short name, e.g. "\u{24C2} MMC"
    public let symbol: String
    /// Full name, e.g. "Maximum Material Condition"
    public let name: String
    /// Meaning (verbatim from §6.5)
    public let meaning: String

    public init(symbol: String, name: String, meaning: String) {
        self.symbol  = symbol
        self.name    = name
        self.meaning = meaning
    }
}

// MARK: - ToolingRef A2 tables

extension ToolingRef {

    // MARK: Drill Point Angle by Material — 6 rows (§3)

    public static let drillPointAngles: [DrillPointAngleRow] = [
        DrillPointAngleRow(
            material:     "General-purpose steel",
            pointAngle:   "118\u{00B0}",
            lipClearance: "8\u{2013}12\u{00B0}",
            notes:        "The standard catch-all grind"
        ),
        DrillPointAngleRow(
            material:     "Hard / tough steel, stainless",
            pointAngle:   "135\u{2013}140\u{00B0}",
            lipClearance: "6\u{2013}8\u{00B0}",
            notes:        "Flatter point, more rake at the edge; less lip clearance"
        ),
        DrillPointAngleRow(
            material:     "Cast iron",
            pointAngle:   "90\u{2013}118\u{00B0}",
            lipClearance: "8\u{2013}12\u{00B0}",
            notes:        "Smaller angle resists corner abrasion"
        ),
        DrillPointAngleRow(
            material:     "Brass / bronze",
            pointAngle:   "118\u{00B0}",
            lipClearance: "8\u{2013}12\u{00B0}",
            notes:        "Flatten the lip slightly (\u{2248}0\u{00B0} rake) so it can\u{2019}t grab"
        ),
        DrillPointAngleRow(
            material:     "Aluminum / soft",
            pointAngle:   "90\u{2013}118\u{00B0}",
            lipClearance: "12\u{2013}15\u{00B0}",
            notes:        "More clearance for soft, gummy material"
        ),
        DrillPointAngleRow(
            material:     "Plastics, hard rubber, fiber",
            pointAngle:   "60\u{2013}90\u{00B0}",
            lipClearance: "12\u{2013}15\u{00B0}",
            notes:        "Long, sharp point; wide polished flutes; low helix"
        ),
    ]

    // MARK: Web Thickness by Drill Size — 5 rows (§3)

    public static let drillWebThickness: [DrillWebThicknessRow] = [
        DrillWebThicknessRow(drillDiam: "1/8\u{2033}",    webPct: "20%"),
        DrillWebThicknessRow(drillDiam: "1/4\u{2033}",    webPct: "17%"),
        DrillWebThicknessRow(drillDiam: "1/2\u{2033}",    webPct: "14%"),
        DrillWebThicknessRow(drillDiam: "1\u{2033}",      webPct: "12%"),
        DrillWebThicknessRow(drillDiam: "Over 1\u{2033}", webPct: "11%"),
    ]

    // MARK: File Shapes — 11 rows (§5)

    public static let fileShapes: [FileShapeRow] = [
        FileShapeRow(
            shapeKey:    "flat",
            name:        "Flat",
            description: "Rectangular, double-cut both faces; general stock removal. Tapers in width & thickness."
        ),
        FileShapeRow(
            shapeKey:    "hand",
            name:        "Hand",
            description: "Parallel sides, one safe edge (green). File into a corner without touching the adjacent face."
        ),
        FileShapeRow(
            shapeKey:    "pillar",
            name:        "Pillar",
            description: "Narrow, thick, two safe edges. Slots and keyways where both walls must stay untouched."
        ),
        FileShapeRow(
            shapeKey:    "square",
            name:        "Square",
            description: "Slots, rectangular holes, keyseats. Cuts on all four faces."
        ),
        FileShapeRow(
            shapeKey:    "round",
            name:        "Round",
            description: "\u{201C}Rat-tail.\u{201D} Enlarging holes, radii, concave curves."
        ),
        FileShapeRow(
            shapeKey:    "halfround",
            name:        "Half-Round",
            description: "Flat face + curved back; concave and flat work in one file."
        ),
        FileShapeRow(
            shapeKey:    "triangle",
            name:        "Three-Square",
            description: "60\u{00B0} points; sharp internal angles, V-grooves, saw-tooth setting."
        ),
        FileShapeRow(
            shapeKey:    "knife",
            name:        "Knife",
            description: "Acute wedge; tight grooves and very sharp internal angles."
        ),
        FileShapeRow(
            shapeKey:    "warding",
            name:        "Warding",
            description: "Thin, tapered to a point; narrow slots \u{2014} key/lock work."
        ),
        FileShapeRow(
            shapeKey:    "crossing",
            name:        "Crossing",
            description: "Two curved faces (different radii); inside curves and blending."
        ),
        FileShapeRow(
            shapeKey:    "barrette",
            name:        "Barrette",
            description: "Teeth on the flat face only, safe edges & back; flat filing beside a finished surface."
        ),
    ]

    // MARK: File Grades (Cut / Coarseness) — 5 rows (§5)

    public static let fileGrades: [FileGradeRow] = [
        FileGradeRow(cut: "Rough / Coarse", coarseness: "Coarsest", use: "Heavy, fast removal on soft metals & wood"),
        FileGradeRow(cut: "Bastard",        coarseness: "Coarse",   use: "General roughing on steel"),
        FileGradeRow(cut: "Second-cut",     coarseness: "Medium",   use: "Intermediate shaping toward finish"),
        FileGradeRow(cut: "Smooth",         coarseness: "Fine",     use: "Finishing cuts, light stock"),
        FileGradeRow(cut: "Dead-smooth",    coarseness: "Finest",   use: "Final finish, draw-filing"),
    ]

    // MARK: GD&T Notation — 7 rows (§6.5)

    public static let gdtNotation: [GdtNotationRow] = [
        GdtNotationRow(
            notation: "\u{2300}.500 \u{00B1}.002",
            meaning:  "Diameter 0.500 with bilateral tolerance \u{00B1}0.002"
        ),
        GdtNotationRow(
            notation: ".750 +.000/\u{2212}.005",
            meaning:  "Unilateral tolerance \u{2014} may be up to 0.005 under, never over"
        ),
        GdtNotationRow(
            notation: "2\u{00D7} \u{2300}.250 \u{21A7}.500",
            meaning:  "Two holes, 0.250 diameter, 0.500 deep"
        ),
        GdtNotationRow(
            notation: "\u{2300}.500 \u{2334} \u{2300}.812 \u{21A7}.250",
            meaning:  "0.500 hole with a 0.812 counterbore 0.250 deep"
        ),
        GdtNotationRow(
            notation: "M6\u{00D7}1.0 \u{2212} 6H",
            meaning:  "Metric thread, 6 mm \u{00D7} 1.0 pitch, tolerance class 6H (internal)"
        ),
        GdtNotationRow(
            notation: "THRU",
            meaning:  "Feature passes entirely through the part"
        ),
        GdtNotationRow(
            notation: "TYP",
            meaning:  "Typical \u{2014} applies to all identical features"
        ),
    ]

    // MARK: GD&T 14 Characteristics — 14 rows (§6.5)

    public static let gdtCharacteristics: [GdtCharacteristicRow] = [
        // FORM — no datum
        GdtCharacteristicRow(
            family:      "FORM \u{2014} no datum",
            key:         "straight",
            name:        "Straightness",
            description: "line elements (or an axis) must lie within a zone"
        ),
        GdtCharacteristicRow(
            family:      "FORM \u{2014} no datum",
            key:         "flat",
            name:        "Flatness",
            description: "the whole surface between two parallel planes"
        ),
        GdtCharacteristicRow(
            family:      "FORM \u{2014} no datum",
            key:         "circ",
            name:        "Circularity",
            description: "each cross-section between two concentric circles"
        ),
        GdtCharacteristicRow(
            family:      "FORM \u{2014} no datum",
            key:         "cyl",
            name:        "Cylindricity",
            description: "round and straight along the length, one zone"
        ),
        // ORIENTATION — datum required
        GdtCharacteristicRow(
            family:      "ORIENTATION \u{2014} datum required",
            key:         "par",
            name:        "Parallelism",
            description: "surface or axis held parallel to a datum"
        ),
        GdtCharacteristicRow(
            family:      "ORIENTATION \u{2014} datum required",
            key:         "perp",
            name:        "Perpendicularity",
            description: "square to a datum \u{2014} two planes, or a cylinder for an axis"
        ),
        GdtCharacteristicRow(
            family:      "ORIENTATION \u{2014} datum required",
            key:         "ang",
            name:        "Angularity",
            description: "held at the basic angle to a datum"
        ),
        // PROFILE — datum optional
        GdtCharacteristicRow(
            family:      "PROFILE \u{2014} datum optional",
            key:         "profL",
            name:        "Profile of a line",
            description: "any 2-D slice of a curve within a zone"
        ),
        GdtCharacteristicRow(
            family:      "PROFILE \u{2014} datum optional",
            key:         "profS",
            name:        "Profile of a surface",
            description: "the whole surface within a zone \u{2014} the most versatile control"
        ),
        // LOCATION — datum required
        GdtCharacteristicRow(
            family:      "LOCATION \u{2014} datum required",
            key:         "pos",
            name:        "Position",
            description: "where an axis or center plane must sit, located by basic dims"
        ),
        GdtCharacteristicRow(
            family:      "LOCATION \u{2014} datum required",
            key:         "conc",
            name:        "Concentricity",
            description: "axis coincident with a datum axis \u{2014} notoriously hard to inspect"
        ),
        GdtCharacteristicRow(
            family:      "LOCATION \u{2014} datum required",
            key:         "symm",
            name:        "Symmetry",
            description: "median points held about a center plane"
        ),
        // RUNOUT — datum required
        GdtCharacteristicRow(
            family:      "RUNOUT \u{2014} datum required",
            key:         "runC",
            name:        "Circular runout",
            description: "each circle as the part turns on the datum \u{2014} a dial reading"
        ),
        GdtCharacteristicRow(
            family:      "RUNOUT \u{2014} datum required",
            key:         "runT",
            name:        "Total runout",
            description: "the whole surface as it turns \u{2014} the dial swept along the length"
        ),
    ]

    // MARK: GD&T Material Modifiers — 7 rows (§6.5)

    public static let gdtModifiers: [GdtModifierRow] = [
        GdtModifierRow(
            symbol:  "\u{24C2} MMC",
            name:    "Maximum Material Condition",
            meaning: "tolerance applies at max material; bonus tolerance earned as feature departs"
        ),
        GdtModifierRow(
            symbol:  "\u{24C1} LMC",
            name:    "Least Material Condition",
            meaning: "guards minimum wall thickness"
        ),
        GdtModifierRow(
            symbol:  "\u{24C8} RFS",
            name:    "Regardless of Feature Size",
            meaning: "the default when no modifier shown"
        ),
        GdtModifierRow(
            symbol:  "\u{24C5} Projected",
            name:    "Projected tolerance zone",
            meaning: "extends above a tapped hole"
        ),
        GdtModifierRow(
            symbol:  "\u{24D5} Free state",
            name:    "Free state",
            meaning: "applies unrestrained \u{2014} thin parts"
        ),
        GdtModifierRow(
            symbol:  "\u{24C9} Tangent",
            name:    "Tangent plane",
            meaning: "only high-point plane must comply"
        ),
        GdtModifierRow(
            symbol:  "\u{24CA} Unequal",
            name:    "Unequal bilateral",
            meaning: "profile zone split unevenly"
        ),
    ]
}

// MARK: - MarkRow

/// One entry in the MarkFinder lookup table.
/// - `mark`: the abbreviation, symbol, or standard code (e.g. "A/F", "\u{2300}", "ISO")
/// - `meaning`: human-readable expansion
/// - `context`: "abbr" (abbreviation), "sym" (symbol), or "std" (standards body)
public struct MarkRow: Sendable {
    public let mark: String
    public let meaning: String
    public let context: String

    public init(mark: String, meaning: String, context: String) {
        self.mark    = mark
        self.meaning = meaning
        self.context = context
    }
}

// MARK: - MarkFinder

/// GD&T / drawing mark look-up (119 entries, §6.4, fix pass A2 2026-07-07).
/// Source: app-new.html MarkFinder DATA array (lines 3836–3959).
/// All mark + meaning + context values are verbatim from the web; search rule is the web's exact rule.
public enum MarkFinder {

    // MARK: Data (119 rows)

    public static let all: [MarkRow] = abbr + sym + std

    // MARK: - Abbreviations (67) — context = "abbr"
    // Verbatim from app-new.html MarkFinder DATA, lines 3838–3904 (fix pass A2)

    private static let abbr: [MarkRow] = [
        MarkRow(mark: "A/F",     meaning: "Across flats",                                    context: "abbr"),
        MarkRow(mark: "ASSY",    meaning: "Assembly",                                         context: "abbr"),
        MarkRow(mark: "CL",      meaning: "Center line",                                      context: "abbr"),
        MarkRow(mark: "CM",      meaning: "Centimeters",                                      context: "abbr"),
        MarkRow(mark: "CHAM",    meaning: "Chamfered",                                        context: "abbr"),
        MarkRow(mark: "CH HD",   meaning: "Cheese head",                                      context: "abbr"),
        MarkRow(mark: "C'BORE",  meaning: "Counterbore",                                      context: "abbr"),
        MarkRow(mark: "CSK",     meaning: "Countersunk",                                      context: "abbr"),
        MarkRow(mark: "CSK HD",  meaning: "Countersunk head",                                 context: "abbr"),
        MarkRow(mark: "CYL",     meaning: "Cylinder or cylindrical",                          context: "abbr"),
        MarkRow(mark: "DATUM",   meaning: "Datum system",                                     context: "abbr"),
        MarkRow(mark: "DIA",     meaning: "Diameter",                                         context: "abbr"),
        MarkRow(mark: "DIM",     meaning: "Dimension",                                        context: "abbr"),
        MarkRow(mark: "DRG",     meaning: "Drawing",                                          context: "abbr"),
        MarkRow(mark: "EQUI SP", meaning: "Equally spaced",                                   context: "abbr"),
        MarkRow(mark: "EXT",     meaning: "External",                                         context: "abbr"),
        MarkRow(mark: "FAO",     meaning: "Finish all over",                                  context: "abbr"),
        MarkRow(mark: "FIG",     meaning: "Figure",                                           context: "abbr"),
        MarkRow(mark: "FIM",     meaning: "Full indicator movement (= TIR)",                  context: "abbr"),
        MarkRow(mark: "FT",      meaning: "Foot",                                             context: "abbr"),
        MarkRow(mark: "GAL",     meaning: "Gallon",                                           context: "abbr"),
        MarkRow(mark: "GALV",    meaning: "Galvanized",                                       context: "abbr"),
        MarkRow(mark: "HB",      meaning: "Hardness, Brinell",                                context: "abbr"),
        MarkRow(mark: "HRA",     meaning: "Hardness, Rockwell A scale",                       context: "abbr"),
        MarkRow(mark: "HRB",     meaning: "Hardness, Rockwell B scale",                       context: "abbr"),
        MarkRow(mark: "HRC",     meaning: "Hardness, Rockwell C scale",                       context: "abbr"),
        MarkRow(mark: "HRD",     meaning: "Hardness, Rockwell D scale",                       context: "abbr"),
        MarkRow(mark: "HRE",     meaning: "Hardness, Rockwell E scale",                       context: "abbr"),
        MarkRow(mark: "HV",      meaning: "Hardness, Vickers",                                context: "abbr"),
        MarkRow(mark: "HEX",     meaning: "Hexagon",                                          context: "abbr"),
        MarkRow(mark: "HEX HD",  meaning: "Hexagon head",                                     context: "abbr"),
        MarkRow(mark: "HYD",     meaning: "Hydraulic",                                        context: "abbr"),
        MarkRow(mark: "IN",      meaning: "Inch",                                             context: "abbr"),
        MarkRow(mark: "INSUL",   meaning: "Insulated or insulation",                          context: "abbr"),
        MarkRow(mark: "INT",     meaning: "Internal",                                         context: "abbr"),
        MarkRow(mark: "I/D",     meaning: "Internal diameter",                                context: "abbr"),
        MarkRow(mark: "KG",      meaning: "Kilogram",                                         context: "abbr"),
        MarkRow(mark: "LH",      meaning: "Left hand",                                        context: "abbr"),
        MarkRow(mark: "LG",      meaning: "Long",                                             context: "abbr"),
        MarkRow(mark: "M/C",     meaning: "Machine",                                          context: "abbr"),
        MarkRow(mark: "MATL",    meaning: "Material",                                         context: "abbr"),
        MarkRow(mark: "MAX",     meaning: "Maximum",                                          context: "abbr"),
        MarkRow(mark: "M",       meaning: "Meter",                                            context: "abbr"),
        MarkRow(mark: "MM",      meaning: "Millimeter",                                       context: "abbr"),
        MarkRow(mark: "MIN",     meaning: "Minimum",                                          context: "abbr"),
        MarkRow(mark: "NTS",     meaning: "Not to scale",                                     context: "abbr"),
        MarkRow(mark: "NO.",     meaning: "Number",                                           context: "abbr"),
        MarkRow(mark: "O/D",     meaning: "Outside diameter",                                 context: "abbr"),
        MarkRow(mark: "PCD",     meaning: "Pitch circle diameter (bolt circle)",              context: "abbr"),
        MarkRow(mark: "LB",      meaning: "Pound",                                            context: "abbr"),
        MarkRow(mark: "RAD",     meaning: "Radius (also R)",                                  context: "abbr"),
        MarkRow(mark: "REF",     meaning: "Reference dimension \u{2014} info only, not inspected", context: "abbr"),
        MarkRow(mark: "RPM",     meaning: "Revolutions per minute",                           context: "abbr"),
        MarkRow(mark: "RH",      meaning: "Right hand",                                       context: "abbr"),
        MarkRow(mark: "RD HD",   meaning: "Round head",                                       context: "abbr"),
        MarkRow(mark: "SCR",     meaning: "Screwed",                                          context: "abbr"),
        MarkRow(mark: "SK",      meaning: "Sketch",                                           context: "abbr"),
        MarkRow(mark: "SPEC",    meaning: "Specification",                                    context: "abbr"),
        MarkRow(mark: "SPH",     meaning: "Spherical",                                        context: "abbr"),
        MarkRow(mark: "SQ",      meaning: "Square",                                           context: "abbr"),
        MarkRow(mark: "STD",     meaning: "Standard",                                         context: "abbr"),
        MarkRow(mark: "SWG",     meaning: "Standard (imperial) wire gauge",                   context: "abbr"),
        MarkRow(mark: "THD",     meaning: "Thread",                                           context: "abbr"),
        MarkRow(mark: "TIR",     meaning: "Total indicator reading (runout on a dial)",       context: "abbr"),
        MarkRow(mark: "TPI",     meaning: "Threads per inch",                                 context: "abbr"),
        MarkRow(mark: "VOL",     meaning: "Volume",                                           context: "abbr"),
        MarkRow(mark: "WT",      meaning: "Weight",                                           context: "abbr"),
    ]

    // MARK: - Symbols (35 = 9 drawing + 26 math) — context = "sym"
    // Verbatim from app-new.html MarkFinder DATA, lines 3906–3941 (fix pass A2)

    private static let sym: [MarkRow] = [
        // Drawing symbols (9)
        MarkRow(mark: "\u{2300}",      meaning: "Diameter (precedes the value)",     context: "sym"),
        MarkRow(mark: "S\u{2300}",     meaning: "Spherical diameter",                context: "sym"),
        MarkRow(mark: "SR",            meaning: "Spherical radius",                  context: "sym"),
        MarkRow(mark: "\u{2334}",      meaning: "Counterbore / spotface",            context: "sym"),
        MarkRow(mark: "\u{2335}",      meaning: "Countersink",                       context: "sym"),
        MarkRow(mark: "\u{21A7}",      meaning: "Depth \u{2014} feature goes down this far", context: "sym"),
        MarkRow(mark: "\u{00B0}",      meaning: "Degree (of angle)",                 context: "sym"),
        MarkRow(mark: "\u{2032}",      meaning: "Minute (of angle)",                 context: "sym"),
        MarkRow(mark: "\u{2033}",      meaning: "Second (of angle)",                 context: "sym"),
        // Math symbols (26)
        MarkRow(mark: "+",             meaning: "Plus, or positive",                 context: "sym"),
        MarkRow(mark: "\u{2212}",      meaning: "Minus, or negative",                context: "sym"),
        MarkRow(mark: "\u{00B1}",      meaning: "Plus or minus",                     context: "sym"),
        MarkRow(mark: "\u{00D7}",      meaning: "Multiply by",                       context: "sym"),
        MarkRow(mark: "\u{00F7}",      meaning: "Divided by",                        context: "sym"),
        MarkRow(mark: "=",             meaning: "Equal to",                          context: "sym"),
        MarkRow(mark: "\u{2260}",      meaning: "Not equal to",                      context: "sym"),
        MarkRow(mark: "\u{2248}",      meaning: "Approximately equal to",            context: "sym"),
        MarkRow(mark: "~",             meaning: "Of the order of, similar to",       context: "sym"),
        MarkRow(mark: ">",             meaning: "Greater than",                      context: "sym"),
        MarkRow(mark: "<",             meaning: "Less than",                         context: "sym"),
        MarkRow(mark: "\u{226F}",      meaning: "Not greater than",                  context: "sym"),
        MarkRow(mark: "\u{226E}",      meaning: "Not less than",                     context: "sym"),
        MarkRow(mark: "\u{2265}",      meaning: "Greater than or equal to",          context: "sym"),
        MarkRow(mark: "\u{2264}",      meaning: "Less than or equal to",             context: "sym"),
        MarkRow(mark: "\u{221A}",      meaning: "Square root of",                    context: "sym"),
        MarkRow(mark: "\u{221E}",      meaning: "Infinity",                          context: "sym"),
        MarkRow(mark: "\u{221D}",      meaning: "Proportional to",                   context: "sym"),
        MarkRow(mark: "\u{03A3}",      meaning: "Sum of",                            context: "sym"),
        MarkRow(mark: "\u{03A0}",      meaning: "Product of",                        context: "sym"),
        MarkRow(mark: "\u{0394}",      meaning: "Difference",                        context: "sym"),
        MarkRow(mark: "\u{2234}",      meaning: "Therefore",                         context: "sym"),
        MarkRow(mark: "\u{03C0}",      meaning: "Pi",                                context: "sym"),
        MarkRow(mark: "\u{2225}",      meaning: "Parallel to",                       context: "sym"),
        MarkRow(mark: "\u{22A5}",      meaning: "Perpendicular to",                  context: "sym"),
        MarkRow(mark: ":",             meaning: "Is to (ratio)",                      context: "sym"),
    ]

    // MARK: - Standards bodies (17) — context = "std"
    // Verbatim from app-new.html MarkFinder DATA, lines 3943–3959 (fix pass A2)

    private static let std: [MarkRow] = [
        MarkRow(mark: "ISO",   meaning: "International Organization for Standardization",           context: "std"),
        MarkRow(mark: "AS",    meaning: "Australian Standards",                                      context: "std"),
        MarkRow(mark: "AFNOR", meaning: "French standards (Association Fran\u{00E7}aise de Normalisation)", context: "std"),
        MarkRow(mark: "DIN",   meaning: "German standards (Deutsches Institut f\u{00FC}r Normung)", context: "std"),
        MarkRow(mark: "W.Nr.", meaning: "Werkstoff number \u{2014} German material number",         context: "std"),
        MarkRow(mark: "EN",    meaning: "European Norm \u{2014} harmonized European standard",      context: "std"),
        MarkRow(mark: "UNI",   meaning: "Italian standards (Ente Nazionale Italiano di Unificazione)", context: "std"),
        MarkRow(mark: "JIS",   meaning: "Japanese Industrial Standards",                            context: "std"),
        MarkRow(mark: "KS",    meaning: "Korean Standards",                                         context: "std"),
        MarkRow(mark: "SS",    meaning: "Swedish Standards",                                        context: "std"),
        MarkRow(mark: "BS",    meaning: "British Standards",                                        context: "std"),
        MarkRow(mark: "AISI",  meaning: "American Iron and Steel Institute (steel grades)",         context: "std"),
        MarkRow(mark: "ANSI",  meaning: "American National Standards Institute",                    context: "std"),
        MarkRow(mark: "ASME",  meaning: "American Society of Mechanical Engineers (Y14.5 GD\u{0026}T, B-series)", context: "std"),
        MarkRow(mark: "ASTM",  meaning: "American Society for Testing and Materials",               context: "std"),
        MarkRow(mark: "SAE",   meaning: "Society of Automotive Engineers (fasteners, steels)",      context: "std"),
        MarkRow(mark: "AMS",   meaning: "Aerospace Material Specifications",                        context: "std"),
    ]

    // MARK: Search

    /// Web-exact search rule (fix pass A2 — verbatim port of app-new.html line 3961–3964):
    ///   const s = q.trim().toLowerCase();
    ///   if (!s) return [];
    ///   return DATA.filter(([c,m]) => c.toLowerCase().includes(s) || m.toLowerCase().includes(s)).slice(0,40);
    ///
    /// Empty query returns []; non-empty query: trim + lowercase, substring match on mark OR meaning,
    /// first 40 results. No alphanumeric normalization — "cbore" does NOT match "C'BORE".
    public static func search(_ q: String) -> [MarkRow] {
        let s = q.trimmingCharacters(in: .whitespaces).lowercased()
        guard !s.isEmpty else { return [] }
        return Array(all.filter { row in
            row.mark.lowercased().contains(s) || row.meaning.lowercased().contains(s)
        }.prefix(40))
    }
}
