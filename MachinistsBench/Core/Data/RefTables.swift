// RefTables.swift — Fastening / joining + process reference tables
// Verbatim from app.html Reference component (lines ~3805–4292).
// Tables: Loctite, Model Threads (BA/ME/BSW), Silver Solder, Morse Tapers,
//         ER Collets, Workholding Taper summaries, Heat Treat (harden/quench/temper,
//         tempering colors, non-ferrous annealing), Grinding (HSS angles, wheel
//         selection), and Steam (saturated steam P-T).

import Foundation

// MARK: - HardenTemperRow

/// One row of the heat-treat harden / quench / temper table (6 common steels).
public struct HardenTemperRow: Sendable {
    /// Steel designation, e.g. "O1 (oil-hard.)"
    public let steel:    String
    /// Hardening temperature range string, e.g. "790–815"
    public let hardenC:  String
    /// Quench medium, e.g. "Oil"
    public let quench:   String
    /// Tempering recommendation, e.g. "200–260 °C → ~57–61 HRC"
    public let temper:   String

    public init(steel: String, hardenC: String, quench: String, temper: String) {
        self.steel   = steel
        self.hardenC = hardenC
        self.quench  = quench
        self.temper  = temper
    }
}

// MARK: - TemperingColorRow

/// One row of the tempering-colors table (plain carbon steel).
public struct TemperingColorRow: Sendable {
    /// Color name, e.g. "Pale straw"
    public let color:      String
    /// Temperature in °C (as Int), e.g. 220
    public let tempC:      Int
    /// Typical use description, e.g. "Lathe tools, scrapers — hardest"
    public let typicalUse: String

    public init(color: String, tempC: Int, typicalUse: String) {
        self.color      = color
        self.tempC      = tempC
        self.typicalUse = typicalUse
    }
}

// MARK: - NonFerrousAnnealRow

/// One row of the non-ferrous annealing table (9 metals).
public struct NonFerrousAnnealRow: Sendable {
    /// Metal name, e.g. "Copper"
    public let metal:   String
    /// Anneal temperature string, e.g. "370–650"
    public let annealC: String
    /// Cooling method, e.g. "Water or air"
    public let cool:    String
    /// Additional notes
    public let notes:   String

    public init(metal: String, annealC: String, cool: String, notes: String) {
        self.metal   = metal
        self.annealC = annealC
        self.cool    = cool
        self.notes   = notes
    }
}

// MARK: - HSSAngleRow

/// One row of the HSS grinding-angles-by-material table (13 materials).
public struct HSSAngleRow: Sendable {
    /// Material name, e.g. "Aluminum"
    public let material:    String
    /// ② Approach relief angle string, e.g. "12°"
    public let apprRelief:  String
    /// ③ Front relief angle string, e.g. "8°"
    public let frontRelief: String
    /// ④ Top rake (back rake) angle string, e.g. "35°"
    public let topRake:     String
    /// ⑤ Top relief (side rake) angle string, e.g. "15°"
    public let topRelief:   String

    public init(material: String, apprRelief: String, frontRelief: String, topRake: String, topRelief: String) {
        self.material    = material
        self.apprRelief  = apprRelief
        self.frontRelief = frontRelief
        self.topRake     = topRake
        self.topRelief   = topRelief
    }
}

// MARK: - GrindingWheelRow

/// One row of the grinding wheel selection table (5 rows).
public struct GrindingWheelRow: Sendable {
    /// Job description, e.g. "Rough HSS tools"
    public let job:      String
    /// Abrasive type, e.g. "Aluminum oxide (A)"
    public let abrasive: String
    /// Grit range string, e.g. "36–46"
    public let grit:     String
    /// Grade / hardness, e.g. "Medium (K–M)"
    public let grade:    String

    public init(job: String, abrasive: String, grit: String, grade: String) {
        self.job      = job
        self.abrasive = abrasive
        self.grit     = grit
        self.grade    = grade
    }
}

// MARK: - SteamRow

/// One row of the saturated steam pressure–temperature table (8 rows).
public struct SteamRow: Sendable {
    /// Gauge pressure in psi (as Int), e.g. 0
    public let gaugePSI: Int
    /// Absolute pressure string, e.g. "14.7"
    public let absPSIA:  String
    /// Temperature in °C (as Int), e.g. 100
    public let tempC:    Int
    /// Temperature in °F (as Int), e.g. 212
    public let tempF:    Int

    public init(gaugePSI: Int, absPSIA: String, tempC: Int, tempF: Int) {
        self.gaugePSI = gaugePSI
        self.absPSIA  = absPSIA
        self.tempC    = tempC
        self.tempF    = tempF
    }
}

// MARK: - LoctiteRow

/// One row of the Loctite threadlocker / retainer reference table.
public struct LoctiteRow: Sendable {
    /// Grade number(s), e.g. "222 / 221"
    public let grade:    String
    /// Colour name, e.g. "Purple"
    public let color:    String
    /// Strength label, e.g. "Low", "Medium", "High", "Sealant"
    public let strength: String
    /// Usage description
    public let use:      String

    public init(grade: String, color: String, strength: String, use: String) {
        self.grade    = grade
        self.color    = color
        self.strength = strength
        self.use      = use
    }
}

// MARK: - BARow

/// One row of the British Association (BA) model-thread table.
public struct BARow: Sendable {
    /// Size designation, e.g. "0 BA"
    public let size:      String
    /// Major Ø in mm, e.g. 6.0
    public let majorMM:   Double
    /// Pitch in mm
    public let pitchMM:   Double
    /// Approximate TPI
    public let approxTPI: Double
    /// Tap drill string, e.g. "5.1 mm"
    public let tapDrill:  String

    public init(size: String, majorMM: Double, pitchMM: Double, approxTPI: Double, tapDrill: String) {
        self.size      = size
        self.majorMM   = majorMM
        self.pitchMM   = pitchMM
        self.approxTPI = approxTPI
        self.tapDrill  = tapDrill
    }
}

// MARK: - MERow

/// One row of the Model Engineer (ME) thread table.
public struct MERow: Sendable {
    /// Size designation, e.g. "1/8″ × 40"
    public let size:      String
    /// Threads per inch
    public let tpi:       Int
    /// Tap drill string, e.g. "2.55 mm (#42)"
    public let tapDrill:  String
    /// Common use description
    public let commonUse: String

    public init(size: String, tpi: Int, tapDrill: String, commonUse: String) {
        self.size      = size
        self.tpi       = tpi
        self.tapDrill  = tapDrill
        self.commonUse = commonUse
    }
}

// MARK: - BSWRow

/// One row of the Whitworth (BSW) thread table.
public struct BSWRow: Sendable {
    /// Size designation, e.g. "1/8″ BSW"
    public let size:     String
    /// Threads per inch
    public let tpi:      Int
    /// Tap drill string, e.g. "2.55 mm"
    public let tapDrill: String

    public init(size: String, tpi: Int, tapDrill: String) {
        self.size     = size
        self.tpi      = tpi
        self.tapDrill = tapDrill
    }
}

// MARK: - SilverSolderRow

/// One row of the silver-solder / brazing-filler reference table.
public struct SilverSolderRow: Sendable {
    /// Filler name / product, e.g. "\"Easy-flo\" / 55%"
    public let filler:     String
    /// Silver content string, e.g. "55" or "—"
    public let silverPct:  String
    /// Flow-point string, e.g. "~630 °C"
    public let flowPoint:  String
    /// Usage / notes
    public let notes:      String

    public init(filler: String, silverPct: String, flowPoint: String, notes: String) {
        self.filler    = filler
        self.silverPct = silverPct
        self.flowPoint = flowPoint
        self.notes     = notes
    }
}

// MARK: - MorseTaperRow

/// One row of the Morse Taper self-holding spindle table.
public struct MorseTaperRow: Sendable {
    /// Size designation, e.g. "MT2"
    public let size:       String
    /// Taper per foot string, e.g. "0.59941″"
    public let taperPerFt: String
    /// Large-end (gauge) diameter string, e.g. "0.7000″"
    public let largeDia:   String
    /// Small-end diameter string, e.g. "0.5720″"
    public let smallDia:   String
    /// Plug depth string, e.g. "2-9/16″"
    public let plugDepth:  String

    public init(size: String, taperPerFt: String, largeDia: String, smallDia: String, plugDepth: String) {
        self.size       = size
        self.taperPerFt = taperPerFt
        self.largeDia   = largeDia
        self.smallDia   = smallDia
        self.plugDepth  = plugDepth
    }
}

// MARK: - ERColletRow

/// One row of the ER Collet (DIN 6499) series table.
public struct ERColletRow: Sendable {
    /// Series name, e.g. "ER32"
    public let series:       String
    /// Capacity range string, e.g. "2–20 mm"
    public let capacity:     String
    /// Per-collet collapse range, e.g. "1 mm"
    public let colletRange:  String
    /// Typical application note
    public let typicalHome:  String

    public init(series: String, capacity: String, colletRange: String, typicalHome: String) {
        self.series      = series
        self.capacity    = capacity
        self.colletRange = colletRange
        self.typicalHome = typicalHome
    }
}

// MARK: - WorkholdingTaperRow

/// One row of the Other Common Workholding Tapers summary table.
public struct WorkholdingTaperRow: Sendable {
    /// System name, e.g. "R8 (Bridgeport)"
    public let system:    String
    /// Key facts description
    public let keyFacts:  String

    public init(system: String, keyFacts: String) {
        self.system   = system
        self.keyFacts = keyFacts
    }
}

// MARK: - RefTables

/// All fastening / joining reference tables ported verbatim from app.html.
public enum RefTables {

    // MARK: Loctite — 6 rows

    /// Threadlocker & retainer grade reference (app.html lines ~4064–4072).
    public static let loctite: [LoctiteRow] = [
        LoctiteRow(
            grade:    "222 / 221",
            color:    "Purple",
            strength: "Low",
            use:      "Small screws ≤ ¼″ (M6); adjustment screws you may need to reset. Hand-tool removable."
        ),
        LoctiteRow(
            grade:    "242 / 243",
            color:    "Blue",
            strength: "Medium",
            use:      "The default. Bolts up to ¾″; removable with hand tools. 243 tolerates light oil."
        ),
        LoctiteRow(
            grade:    "271 / 272",
            color:    "Red",
            strength: "High",
            use:      "Permanent studs & bolts; needs heat (~250 °C) to remove. 272 is high-temp."
        ),
        LoctiteRow(
            grade:    "290",
            color:    "Green",
            strength: "Med-High",
            use:      "Wicking grade — penetrates already-assembled threads and set screws by capillary action."
        ),
        LoctiteRow(
            grade:    "638 / 609",
            color:    "Green",
            strength: "High",
            use:      "Retaining compound — bonds slip-fit shafts, bearings, gears into bores (not threads)."
        ),
        LoctiteRow(
            grade:    "545 / 565",
            color:    "Brown/White",
            strength: "Sealant",
            use:      "Hydraulic & pneumatic thread sealant; instant low-pressure seal, lubricates assembly."
        ),
    ]

    // MARK: Model Threads — BA (6 rows)

    /// British Association (BA) 47.5° thread table with tap drills (app.html lines ~4090–4097).
    public static let baThreads: [BARow] = [
        BARow(size: "0 BA",  majorMM: 6.0, pitchMM: 1.00, approxTPI: 25.4, tapDrill: "5.1 mm"),
        BARow(size: "2 BA",  majorMM: 4.7, pitchMM: 0.81, approxTPI: 31.4, tapDrill: "3.9 mm"),
        BARow(size: "4 BA",  majorMM: 3.6, pitchMM: 0.66, approxTPI: 38.5, tapDrill: "3.0 mm"),
        BARow(size: "6 BA",  majorMM: 2.8, pitchMM: 0.53, approxTPI: 47.9, tapDrill: "2.3 mm"),
        BARow(size: "8 BA",  majorMM: 2.2, pitchMM: 0.43, approxTPI: 59.1, tapDrill: "1.8 mm"),
        BARow(size: "10 BA", majorMM: 1.7, pitchMM: 0.35, approxTPI: 72.6, tapDrill: "1.4 mm"),
    ]

    // MARK: Model Threads — ME (6 rows)

    /// Model Engineer (ME) 55° Whitworth-form thread table (app.html lines ~4103–4110).
    public static let meThreads: [MERow] = [
        MERow(size: "1/8″ × 40",  tpi: 40, tapDrill: "2.55 mm (#42)", commonUse: "Small fittings, glands"),
        MERow(size: "3/16″ × 40", tpi: 40, tapDrill: "4.0 mm (#21)",  commonUse: "Unions, bushes"),
        MERow(size: "1/4″ × 40",  tpi: 40, tapDrill: "5.5 mm",        commonUse: "Most common ME fitting"),
        MERow(size: "1/4″ × 32",  tpi: 32, tapDrill: "5.4 mm",        commonUse: "Heavier 1/4″ fittings"),
        MERow(size: "5/16″ × 32", tpi: 32, tapDrill: "7.0 mm",        commonUse: "Larger glands"),
        MERow(size: "3/8″ × 32",  tpi: 32, tapDrill: "8.6 mm",        commonUse: "Boiler bushes, unions"),
    ]

    // MARK: Model Threads — BSW (6 rows)

    /// Whitworth (BSW) 55° thread table with tap drills (app.html lines ~4117–4124).
    public static let bswThreads: [BSWRow] = [
        BSWRow(size: "1/8″ BSW",  tpi: 40, tapDrill: "2.55 mm"),
        BSWRow(size: "3/16″ BSW", tpi: 24, tapDrill: "3.7 mm"),
        BSWRow(size: "1/4″ BSW",  tpi: 20, tapDrill: "5.1 mm"),
        BSWRow(size: "5/16″ BSW", tpi: 18, tapDrill: "6.5 mm"),
        BSWRow(size: "3/8″ BSW",  tpi: 16, tapDrill: "7.9 mm"),
        BSWRow(size: "1/2″ BSW",  tpi: 12, tapDrill: "10.5 mm"),
    ]

    // MARK: Silver Solder — 6 rows

    /// Silver brazing filler reference table (app.html lines ~4138–4145).
    public static let silverSolder: [SilverSolderRow] = [
        SilverSolderRow(
            filler:    "\"Easy-flo\" / 55%",
            silverPct: "55",
            flowPoint: "~630 °C",
            notes:     "Lowest-melt, free-flowing; general silver brazing. Cadmium-free."
        ),
        SilverSolderRow(
            filler:    "Easy",
            silverPct: "~55",
            flowPoint: "~650 °C",
            notes:     "First/lowest step in step-brazing."
        ),
        SilverSolderRow(
            filler:    "Medium",
            silverPct: "~40",
            flowPoint: "~700 °C",
            notes:     "Second step; general-purpose."
        ),
        SilverSolderRow(
            filler:    "Hard",
            silverPct: "~38",
            flowPoint: "~750 °C",
            notes:     "First/highest joint in a multi-step assembly."
        ),
        SilverSolderRow(
            filler:    "Sil-Fos (silver-copper-phos)",
            silverPct: "15",
            flowPoint: "~700 °C",
            notes:     "Self-fluxing on copper-to-copper only — no flux needed. Brittle on steel."
        ),
        SilverSolderRow(
            filler:    "Soft solder (60/40 Sn/Pb)",
            silverPct: "—",
            flowPoint: "~190 °C",
            notes:     "For reference: low strength, electrical & sheet work, not structural."
        ),
    ]

    // MARK: Morse Tapers — 7 rows (MT0–MT6)

    /// Morse Taper self-holding spindle/tailstock dimensions (app.html lines ~4253–4261).
    public static let morseTapers: [MorseTaperRow] = [
        MorseTaperRow(size: "MT0", taperPerFt: "0.62460″", largeDia: "0.3561″", smallDia: "0.2520″", plugDepth: "2.00″"),
        MorseTaperRow(size: "MT1", taperPerFt: "0.59858″", largeDia: "0.4750″", smallDia: "0.3690″", plugDepth: "2-1/8″"),
        MorseTaperRow(size: "MT2", taperPerFt: "0.59941″", largeDia: "0.7000″", smallDia: "0.5720″", plugDepth: "2-9/16″"),
        MorseTaperRow(size: "MT3", taperPerFt: "0.60235″", largeDia: "0.9380″", smallDia: "0.7780″", plugDepth: "3-3/16″"),
        MorseTaperRow(size: "MT4", taperPerFt: "0.62326″", largeDia: "1.2310″", smallDia: "1.0200″", plugDepth: "4-1/16″"),
        MorseTaperRow(size: "MT5", taperPerFt: "0.63151″", largeDia: "1.7480″", smallDia: "1.4750″", plugDepth: "5-3/16″"),
        MorseTaperRow(size: "MT6", taperPerFt: "0.62565″", largeDia: "2.4940″", smallDia: "2.1160″", plugDepth: "7-1/4″"),
    ]

    // MARK: ER Collets — 7 rows (ER8–ER40)

    /// ER Collet (DIN 6499) series table (app.html lines ~4268–4275).
    public static let erCollets: [ERColletRow] = [
        ERColletRow(series: "ER8",  capacity: "0.5–5 mm",  colletRange: "1 mm (0.5 below 1.5)", typicalHome: "Engraving & micro spindles"),
        ERColletRow(series: "ER11", capacity: "0.5–7 mm",  colletRange: "1 mm (0.5 below 1.5)", typicalHome: "High-speed spindles, small cutters"),
        ERColletRow(series: "ER16", capacity: "0.5–10 mm", colletRange: "1 mm",                 typicalHome: "Compact mills · to 3/8″ shanks"),
        ERColletRow(series: "ER20", capacity: "1–13 mm",   colletRange: "1 mm",                 typicalHome: "Light mills · to 1/2″ shanks"),
        ERColletRow(series: "ER25", capacity: "1–16 mm",   colletRange: "1 mm",                 typicalHome: "Bench mills · to 5/8″ shanks"),
        ERColletRow(series: "ER32", capacity: "2–20 mm",   colletRange: "1 mm",                 typicalHome: "The home-shop default · to 3/4″"),
        ERColletRow(series: "ER40", capacity: "3–26 mm",   colletRange: "1 mm",                 typicalHome: "Full-size mills · to 1″"),
    ]

    // MARK: Other Workholding Tapers — 4 rows

    /// Other common workholding taper summary (app.html lines ~4283–4286).
    public static let workholdingTapers: [WorkholdingTaperRow] = [
        WorkholdingTaperRow(
            system:   "R8 (Bridgeport)",
            keyFacts: "Self-releasing mill collet; sizes typically 1/8–3/4″; 7/16-20 drawbar; a spindle pin keys the collet — start it by hand."
        ),
        WorkholdingTaperRow(
            system:   "5C",
            keyFacts: "Lathe & fixture collet to 1-1/16″ round; external nose thread 1.238″-20; vast range of emergency, square, and hex collets."
        ),
        WorkholdingTaperRow(
            system:   "Jacobs (JT)",
            keyFacts: "Short self-holding tapers (JT0–JT6, 2S, 33) mounting drill chucks to arbors — chuck and arbor numbers must match exactly."
        ),
        WorkholdingTaperRow(
            system:   "7:24 (CAT / BT / NMTB)",
            keyFacts: "Steep ≈16.6°-included self-releasing mill spindle taper; needs drawbar or retention-knob hold. Flanges and pull studs differ between CAT, BT, and NMTB even though the cones match."
        ),
    ]

    // MARK: Heat Treat — Harden / Quench / Temper (6 rows)

    /// Common steels harden/quench/temper reference (app.html lines ~4172–4179).
    public static let hardenTemper: [HardenTemperRow] = [
        HardenTemperRow(
            steel:   "W1 (water-hard.)",
            hardenC: "760–790",
            quench:  "Water/brine",
            temper:  "175–315 °C → ~58–62 HRC"
        ),
        HardenTemperRow(
            steel:   "O1 (oil-hard.)",
            hardenC: "790–815",
            quench:  "Oil",
            temper:  "200–260 °C → ~57–61 HRC"
        ),
        HardenTemperRow(
            steel:   "A2 (air-hard.)",
            hardenC: "925–980",
            quench:  "Still air",
            temper:  "175–540 °C → 57–62 HRC"
        ),
        HardenTemperRow(
            steel:   "D2 (air-hard.)",
            hardenC: "1000–1025",
            quench:  "Air",
            temper:  "200–540 °C → 58–62 HRC"
        ),
        HardenTemperRow(
            steel:   "1045",
            hardenC: "820–850",
            quench:  "Water/oil",
            temper:  "As needed; ~55 HRC max"
        ),
        HardenTemperRow(
            steel:   "4140",
            hardenC: "830–860",
            quench:  "Oil",
            temper:  "As needed; tough at 40–48 HRC"
        ),
    ]

    // MARK: Heat Treat — Tempering Colors (7 rows)

    /// Tempering colors for plain carbon steel (app.html lines ~4187–4193).
    public static let temperingColors: [TemperingColorRow] = [
        TemperingColorRow(color: "Pale straw",  tempC: 220, typicalUse: "Lathe tools, scrapers — hardest"),
        TemperingColorRow(color: "Straw",       tempC: 230, typicalUse: "Drills, milling cutters"),
        TemperingColorRow(color: "Dark straw",  tempC: 240, typicalUse: "Punches, taps, dies"),
        TemperingColorRow(color: "Brown",       tempC: 255, typicalUse: "Wood chisels, shear blades"),
        TemperingColorRow(color: "Purple",      tempC: 275, typicalUse: "Cold chisels, axes"),
        TemperingColorRow(color: "Blue",        tempC: 295, typicalUse: "Springs, screwdrivers — toughest"),
        TemperingColorRow(color: "Pale blue",   tempC: 310, typicalUse: "Saws, spanners"),
    ]

    // MARK: Heat Treat — Non-Ferrous Annealing (9 rows)

    /// Non-ferrous metal annealing reference (app.html lines ~4202–4210).
    public static let nonFerrousAnneal: [NonFerrousAnnealRow] = [
        NonFerrousAnnealRow(
            metal:   "Brass (cartridge, 70/30)",
            annealC: "425–600",
            cool:    "Water or air",
            notes:   "Quench is for handling only — softness is set by the heat. Anneal minimally on historic sheet: overheating grows grain that shows as orange-peel under polish."
        ),
        NonFerrousAnnealRow(
            metal:   "Brass (free-cutting, C360)",
            annealC: "425–550",
            cool:    "Water or air",
            notes:   "Leaded — ventilate well and stay below a dull red."
        ),
        NonFerrousAnnealRow(
            metal:   "Copper",
            annealC: "370–650",
            cool:    "Water or air",
            notes:   "Softens regardless of cooling; a quench also pops the scale off."
        ),
        NonFerrousAnnealRow(
            metal:   "Phosphor bronze",
            annealC: "480–675",
            cool:    "Air or water",
            notes:   "Work-hardens fast — expect several anneal cycles while forming."
        ),
        NonFerrousAnnealRow(
            metal:   "Nickel silver",
            annealC: "600–700",
            cool:    "Water or air",
            notes:   "Stiffer than brass; needs the hotter end."
        ),
        NonFerrousAnnealRow(
            metal:   "Sterling silver",
            annealC: "595–650",
            cool:    "Air below red, then quench & pickle",
            notes:   "Dull red in dim light. Soft reducing flame limits firestain; pickle after."
        ),
        NonFerrousAnnealRow(
            metal:   "Fine silver",
            annealC: "600–650",
            cool:    "Quench & pickle",
            notes:   "No firestain; very soft when annealed."
        ),
        NonFerrousAnnealRow(
            metal:   "Aluminum 1100 / 3003",
            annealC: "345",
            cool:    "Air",
            notes:   "Shows no color — mark with Sharpie or soap and anneal when the mark chars or clears."
        ),
        NonFerrousAnnealRow(
            metal:   "Aluminum 6061",
            annealC: "415",
            cool:    "Slow furnace cool",
            notes:   "Full anneal wants ~30 °C/h down to 260 °C; a torch anneal only part-softens."
        ),
    ]

    // MARK: Grinding — HSS Angles by Material (13 rows)

    /// HSS grinding angles by material with grinding-order ①–⑥ (app.html lines ~4232–4244).
    public static let hssAngles: [HSSAngleRow] = [
        HSSAngleRow(material: "Aluminum",           apprRelief: "12°", frontRelief: "8°",  topRake: "35°", topRelief: "15°"),
        HSSAngleRow(material: "Brass / Bronze",      apprRelief: "10°", frontRelief: "8°",  topRake: "0°",  topRelief: "5°"),
        HSSAngleRow(material: "Cast Iron",           apprRelief: "10°", frontRelief: "8°",  topRake: "5°",  topRelief: "12°"),
        HSSAngleRow(material: "Copper",              apprRelief: "14°", frontRelief: "12°", topRake: "16°", topRelief: "20°"),
        HSSAngleRow(material: "Fiber / Laminates",   apprRelief: "15°", frontRelief: "12°", topRake: "0°",  topRelief: "0°"),
        HSSAngleRow(material: "Monel",               apprRelief: "15°", frontRelief: "13°", topRake: "8°",  topRelief: "14°"),
        HSSAngleRow(material: "Nickel",              apprRelief: "15°", frontRelief: "13°", topRake: "8°",  topRelief: "14°"),
        HSSAngleRow(material: "Mild Steel",          apprRelief: "12°", frontRelief: "8°",  topRake: "16°", topRelief: "14°"),
        HSSAngleRow(material: "Med. Carbon Steel",   apprRelief: "10°", frontRelief: "8°",  topRake: "12°", topRelief: "14°"),
        HSSAngleRow(material: "High Tensile Steel",  apprRelief: "10°", frontRelief: "8°",  topRake: "8°",  topRelief: "12°"),
        HSSAngleRow(material: "Stainless Steel",     apprRelief: "10°", frontRelief: "8°",  topRake: "10°", topRelief: "15°"),
        HSSAngleRow(material: "Thermoplastics",      apprRelief: "20°", frontRelief: "15°", topRake: "20°", topRelief: "20°"),
        HSSAngleRow(material: "Molded / Thermoset",  apprRelief: "12°", frontRelief: "10°", topRake: "10°", topRelief: "14°"),
    ]

    // MARK: Grinding — Wheel Selection (5 rows)

    /// Bench grinding wheel selection by job (app.html lines ~4219–4224).
    public static let grindingWheels: [GrindingWheelRow] = [
        GrindingWheelRow(job: "Rough HSS tools",        abrasive: "Aluminum oxide (A)",    grit: "36–46",  grade: "Medium (K–M)"),
        GrindingWheelRow(job: "Finish HSS tools",       abrasive: "Aluminum oxide (A)",    grit: "60–80",  grade: "Medium (J–L)"),
        GrindingWheelRow(job: "Carbide (offhand)",      abrasive: "Silicon carbide (GC)",  grit: "60–100", grade: "Soft (H–J)"),
        GrindingWheelRow(job: "Cast iron / non-ferrous",abrasive: "Silicon carbide (C)",   grit: "36–60",  grade: "Medium"),
        GrindingWheelRow(job: "Drills",                 abrasive: "Aluminum oxide",        grit: "46–60",  grade: "Medium"),
    ]

    // MARK: Steam — Saturated Steam P-T Table (8 rows)

    /// Saturated steam gauge pressure vs temperature (app.html lines ~4137–4144).
    public static let steamTable: [SteamRow] = [
        SteamRow(gaugePSI:   0, absPSIA:  "14.7", tempC: 100, tempF: 212),
        SteamRow(gaugePSI:  15, absPSIA:  "29.7", tempC: 121, tempF: 250),
        SteamRow(gaugePSI:  30, absPSIA:  "44.7", tempC: 134, tempF: 274),
        SteamRow(gaugePSI:  45, absPSIA:  "59.7", tempC: 145, tempF: 292),
        SteamRow(gaugePSI:  60, absPSIA:  "74.7", tempC: 153, tempF: 307),
        SteamRow(gaugePSI:  80, absPSIA:  "94.7", tempC: 162, tempF: 324),
        SteamRow(gaugePSI: 100, absPSIA: "114.7", tempC: 170, tempF: 338),
        SteamRow(gaugePSI: 120, absPSIA: "134.7", tempC: 177, tempF: 350),
    ]
}
