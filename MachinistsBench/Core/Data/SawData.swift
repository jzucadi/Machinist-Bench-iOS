import Foundation

// MARK: - SawMaterial

public struct SawMaterial: Sendable {
    public let key: String
    public let name: String
    public let kind: String          // "metal" | "wood" | "plastic"
    public let sfm: [Int]            // 4 FPM values for section bands [<1", 1-3", 3-6", >6"] (metals only)
    public let range: ClosedRange<Int>?  // FPM range for wood/plastic (nil for metals)
    public let note: String

    public init(key: String, name: String, kind: String,
                sfm: [Int] = [], range: ClosedRange<Int>? = nil, note: String) {
        self.key = key
        self.name = name
        self.kind = kind
        self.sfm = sfm
        self.range = range
        self.note = note
    }
}

// MARK: - SawData

public enum SawData {

    // MARK: materials — verbatim from SAW_MAT in app.html

    public static let materials: [SawMaterial] = [
        SawMaterial(key: "mild",    name: "Steel \u{2014} mild / low-carbon (1018, A36)",         kind: "metal",   sfm: [300, 280, 260, 250], note: "The friendly case \u{2014} full feed, watch for stringy chips on very mild grades."),
        SawMaterial(key: "free",    name: "Steel \u{2014} free-machining (12L14, 1215)",           kind: "metal",   sfm: [310, 290, 270, 250], note: "Cuts fast and clean; the sulphur/lead makes nice short chips."),
        SawMaterial(key: "med",     name: "Steel \u{2014} medium-carbon (1045)",                   kind: "metal",   sfm: [240, 230, 205, 190], note: "A bit slower than mild; fine as supplied, harder if heat-treated."),
        SawMaterial(key: "high",    name: "Steel \u{2014} high-carbon (1080, 1095)",               kind: "metal",   sfm: [200, 190, 180, 130], note: "Slow down; if hardened, treat like tool steel and expect short blade life."),
        SawMaterial(key: "4140",    name: "Steel \u{2014} alloy (4140 / 4150 Cr-Mo)",             kind: "metal",   sfm: [220, 210, 190, 170], note: "Pre-hard (PH/HT) stock runs at the low end of this range."),
        SawMaterial(key: "4340",    name: "Steel \u{2014} alloy (4340 Ni-Cr-Mo)",                 kind: "metal",   sfm: [200, 180, 160, 140], note: "Tough; keep feed firm so teeth cut rather than rub and glaze."),
        SawMaterial(key: "spring",  name: "Steel \u{2014} spring (5160, 6150)",                   kind: "metal",   sfm: [205, 190, 170, 150], note: "In the hardened/tempered state, slower and abrasive on the blade."),
        SawMaterial(key: "52100",   name: "Steel \u{2014} bearing (52100)",                       kind: "metal",   sfm: [175, 140, 130, 110], note: "Hard and abrasive even annealed \u{2014} slow, firm, patient."),
        SawMaterial(key: "o1",      name: "Tool steel \u{2014} O1 (oil-hardening)",               kind: "metal",   sfm: [240, 230, 200, 180], note: "Annealed cuts reasonably; never try to saw it hardened."),
        SawMaterial(key: "a2",      name: "Tool steel \u{2014} A2 (air-hardening)",               kind: "metal",   sfm: [210, 190, 190, 160], note: "Annealed only; the chromium makes it a touch gummy."),
        SawMaterial(key: "d2",      name: "Tool steel \u{2014} D2 (high-C / high-Cr)",            kind: "metal",   sfm: [135, 115, 120,  80], note: "Very abrasive carbides \u{2014} slow speed, generous feed, bi-metal or carbide blade."),
        SawMaterial(key: "h13",     name: "Tool steel \u{2014} H13 (hot-work)",                   kind: "metal",   sfm: [235, 200, 190, 170], note: "Annealed cuts like a mid-alloy steel."),
        SawMaterial(key: "hss",     name: "High-speed steel (M2)",                                kind: "metal",   sfm: [165, 150, 145, 100], note: "Slow and abrasive; a sharp bi-metal or carbide blade and light feed."),
        SawMaterial(key: "ss304",   name: "Stainless \u{2014} 304 (austenitic)",                  kind: "metal",   sfm: [135, 120, 120,  85], note: "Work-hardens fast: keep the blade CUTTING with firm, steady feed \u{2014} never let it rub."),
        SawMaterial(key: "ss316",   name: "Stainless \u{2014} 316 (austenitic)",                  kind: "metal",   sfm: [100,  90,  80,  60], note: "Gummier and slower than 304; coolant helps, dwelling kills the blade."),
        SawMaterial(key: "ss303",   name: "Stainless \u{2014} 303 (free-machining)",              kind: "metal",   sfm: [160, 140, 135,  90], note: "The easy stainless thanks to its sulphur \u{2014} still keep feed positive."),
        SawMaterial(key: "ss410",   name: "Stainless \u{2014} 410 / 420 (martensitic)",           kind: "metal",   sfm: [170, 155, 145, 100], note: "Cuts better than austenitic; slower if hardened."),
        SawMaterial(key: "ss416",   name: "Stainless \u{2014} 416 (free-machining mart.)",        kind: "metal",   sfm: [220, 200, 190, 150], note: "Most band-saw-friendly stainless; firm feed still wins."),
        SawMaterial(key: "ci20",    name: "Cast iron \u{2014} gray, soft (Class 20)",             kind: "metal",   sfm: [210, 200, 180, 160], note: "Powdery chips and dust \u{2014} no coolant (it makes abrasive paste); brush it clear."),
        SawMaterial(key: "ci40",    name: "Cast iron \u{2014} gray, hard (Class 40)",             kind: "metal",   sfm: [170, 160, 140, 120], note: "Harder pearlitic matrix; slower and dustier."),
        SawMaterial(key: "ductile", name: "Ductile iron (60-40-18)",                              kind: "metal",   sfm: [240, 230, 230, 220], note: "Cuts more like steel than gray iron; tolerates a good feed."),
        SawMaterial(key: "ducth",   name: "Ductile iron, hard (80-55-06)",                        kind: "metal",   sfm: [140, 130, 120, 110], note: "Stronger grade \u{2014} back the speed off."),
        SawMaterial(key: "alum",    name: "Aluminum alloys (2024, 6061, 7075)",                   kind: "metal",   sfm: [800, 700, 600, 500], note: "Wants high speed and a coarse hook/skip tooth with big gullets; a wax/release stick stops the gullets loading. Most horizontal saws top out ~300\u{2013}400 FPM, so you may be machine-limited \u{2014} non-ferrous saws run 1000 FPM and up."),
        SawMaterial(key: "brass",   name: "Brass \u{2014} free-cutting (C360, cartridge)",        kind: "metal",   sfm: [300, 270, 240, 210], note: "Very free-cutting; a near-0\u{B0} (regular) tooth stops it grabbing and self-feeding. Soft non-ferrous spans ~200\u{2013}1000 FPM depending on the machine \u{2014} these are representative bi-metal figures."),
        SawMaterial(key: "copper",  name: "Copper (pure / electrolytic)",                         kind: "metal",   sfm: [200, 180, 160, 140], note: "Gummy and grabby \u{2014} coarse tooth, big gullets, a release stick, and steady feed."),
        SawMaterial(key: "bronze",  name: "Bronze (most: tin, phosphor, bearing)",                kind: "metal",   sfm: [230, 205, 180, 140], note: "Generally well-behaved; leaded bearing bronzes cut especially cleanly."),
        SawMaterial(key: "albr",    name: "Aluminum bronze (C954, C630)",                        kind: "metal",   sfm: [100,  95,  85,  70], note: "Tough and abrasive for a copper alloy \u{2014} much slower than tin bronze."),
        SawMaterial(key: "monel",   name: "Nickel \u{2014} Monel 400",                            kind: "metal",   sfm: [100,  90,  85,  65], note: "Work-hardens like stainless \u{2014} firm continuous feed, sharp blade, no rubbing."),
        SawMaterial(key: "inconel", name: "Nickel \u{2014} Inconel 718",                          kind: "metal",   sfm: [ 95,  80,  70,  40], note: "Gummy, work-hardening, hard on blades; slow, firm, and patient with coolant."),
        SawMaterial(key: "hast",    name: "Nickel \u{2014} Hastelloy C",                          kind: "metal",   sfm: [100,  90,  80,  65], note: "Similar story to Inconel \u{2014} low speed, positive feed."),
        SawMaterial(key: "ti",      name: "Titanium \u{2014} 6Al-4V",                             kind: "metal",   sfm: [ 65,  50,  50,  40], note: "Very slow. Chips are flammable \u{2014} keep feed positive (rubbing builds heat), clear swarf, and have the fines under control."),
        SawMaterial(key: "plhard",  name: "Plastic \u{2014} acrylic / polycarbonate (hard)",     kind: "plastic", range: 500...1000,  note: "Skip or fine regular tooth; too much speed re-welds the kerf behind the blade. For thin acrylic go very fine (10\u{2013}18+ TPI) to stop chipping."),
        SawMaterial(key: "plsoft",  name: "Plastic \u{2014} PVC / HDPE / UHMW / nylon (soft)",  kind: "plastic", range: 800...1500,  note: "Skip tooth with big gullets; soft plastics smear and melt readily, so keep them moving and let chips clear."),
        SawMaterial(key: "plphen",  name: "Plastic \u{2014} phenolic / G-10 / composite",        kind: "plastic", range: 300...800,   note: "Abrasive and glass-loaded \u{2014} a bi-metal or carbide blade, slower speed, and dust extraction (the dust is nasty)."),
        SawMaterial(key: "wdsoft",  name: "Wood \u{2014} softwood / general",                    kind: "wood",    range: 2000...4000, note: "Hook or skip tooth, 3\u{2013}6 teeth in the cut for chip clearance; full speed is fine."),
        SawMaterial(key: "wdhard",  name: "Wood \u{2014} hardwood (finish cuts)",                kind: "wood",    range: 1500...3000, note: "A few more teeth for a cleaner edge; let the feed match so you get curls, not dust."),
        SawMaterial(key: "wdresaw", name: "Wood \u{2014} resawing (deep rip)",                   kind: "wood",    range: 2500...5000, note: "Coarse 2\u{2013}3 TPI hook with a wide blade and big gullets to clear the long chip; the most speed-hungry job."),
    ]

    // MARK: diaPitch — verbatim from SAW_DIA_PITCH in app.html

    public static let diaPitch: [(maxIn: Double, label: String, avg: Double)] = [
        (0.125, "18\u{2013}24", 21),
        (0.25,  "14\u{2013}18", 16),
        (0.5,   "10\u{2013}14", 12),
        (1,     "8\u{2013}12",  10),
        (2,     "6\u{2013}10",   8),
        (3,     "5\u{2013}8",    6.5),
        (4,     "4\u{2013}6",    5),
        (6,     "3\u{2013}4",    3.5),
        (12,    "2\u{2013}3",    2.5),
        (1e9,   "1.4\u{2013}2",  1.7),
    ]
}
