public struct Material: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let hardness: String
    public let hssSFM: ClosedRange<Int>
    public let carbideSFM: ClosedRange<Int>
    public let feedIPR: Double
    public let kp: Double
    // Drilling
    public let drillSFM: ClosedRange<Int>
    public let drillCarbideSFM: ClosedRange<Int>
    // Milling
    public let millSFM: ClosedRange<Int>
    public let millCarbideSFM: ClosedRange<Int>
    // Tapping
    public let tapSFM: ClosedRange<Int>
    public let tapCoatedSFM: ClosedRange<Int>
    // Boring
    public let boreSFM: ClosedRange<Int>
    public let boreCarbideSFM: ClosedRange<Int>
    // Reaming
    public let reamSFM: ClosedRange<Int>
    public let reamCarbideSFM: ClosedRange<Int>
    // Feeds
    public let drillFeed: Double
    public let chipLoad: Double
    public let reamFeed: Double
}

public enum Materials {
    public static let all: [Material] = [
        Material(id: "alum",     name: "Aluminum (wrought)",          hardness: "~95 HB",     hssSFM: 250...400, carbideSFM: 600...1200, feedIPR: 0.012, kp: 0.25, drillSFM: 200...300, drillCarbideSFM: 400...700,  millSFM: 200...350, millCarbideSFM: 500...1000, tapSFM: 60...90,  tapCoatedSFM: 90...130,  boreSFM: 200...300, boreCarbideSFM: 500...900, reamSFM: 100...140, reamCarbideSFM: 250...350, drillFeed: 0.006, chipLoad: 0.004, reamFeed: 0.010),
        Material(id: "al6061",   name: "Aluminum 6061-T6",            hardness: "~95 HB",     hssSFM: 250...400, carbideSFM: 600...1200, feedIPR: 0.012, kp: 0.28, drillSFM: 200...300, drillCarbideSFM: 400...700,  millSFM: 200...350, millCarbideSFM: 500...1000, tapSFM: 60...90,  tapCoatedSFM: 90...130,  boreSFM: 200...300, boreCarbideSFM: 500...900, reamSFM: 100...140, reamCarbideSFM: 250...350, drillFeed: 0.006, chipLoad: 0.004, reamFeed: 0.010),
        Material(id: "brass",    name: "Brass (free-cutting)",        hardness: "~120 HB",    hssSFM: 150...300, carbideSFM: 400...700,  feedIPR: 0.010, kp: 0.55, drillSFM: 120...250, drillCarbideSFM: 250...450,  millSFM: 150...300, millCarbideSFM: 400...700,  tapSFM: 50...80,  tapCoatedSFM: 75...110,  boreSFM: 120...250, boreCarbideSFM: 300...550, reamSFM: 80...120,  reamCarbideSFM: 150...250, drillFeed: 0.006, chipLoad: 0.004, reamFeed: 0.010),
        Material(id: "bronze",   name: "Bronze (leaded)",             hardness: "~150 HB",    hssSFM: 90...150,  carbideSFM: 200...400,  feedIPR: 0.010, kp: 0.65, drillSFM: 80...150,  drillCarbideSFM: 150...300,  millSFM: 80...150,  millCarbideSFM: 200...400,  tapSFM: 40...60,  tapCoatedSFM: 60...90,   boreSFM: 80...150,  boreCarbideSFM: 180...350, reamSFM: 50...90,   reamCarbideSFM: 120...200, drillFeed: 0.005, chipLoad: 0.003, reamFeed: 0.009),
        Material(id: "castiron", name: "Cast Iron (gray, soft)",      hardness: "120\u{2013}150 HB", hssSFM: 80...120,  carbideSFM: 250...400,  feedIPR: 0.012, kp: 0.55, drillSFM: 60...100,  drillCarbideSFM: 150...300,  millSFM: 50...90,   millCarbideSFM: 200...400,  tapSFM: 25...40,  tapCoatedSFM: 45...70,   boreSFM: 60...100,  boreCarbideSFM: 180...330, reamSFM: 40...60,   reamCarbideSFM: 100...160, drillFeed: 0.007, chipLoad: 0.005, reamFeed: 0.012),
        Material(id: "ductile",  name: "Cast Iron (ductile/nodular)", hardness: "170\u{2013}200 HB", hssSFM: 60...100,  carbideSFM: 200...350,  feedIPR: 0.011, kp: 0.80, drillSFM: 50...90,   drillCarbideSFM: 130...260,  millSFM: 45...80,   millCarbideSFM: 180...350,  tapSFM: 20...35,  tapCoatedSFM: 35...60,   boreSFM: 50...90,   boreCarbideSFM: 160...300, reamSFM: 35...55,   reamCarbideSFM: 90...150,  drillFeed: 0.006, chipLoad: 0.004, reamFeed: 0.010),
        Material(id: "s12l14",   name: "12L14 Steel (free-mach.)",    hardness: "~160 HB",    hssSFM: 110...160, carbideSFM: 400...700,  feedIPR: 0.013, kp: 0.90, drillSFM: 80...130,  drillCarbideSFM: 250...450,  millSFM: 80...130,  millCarbideSFM: 350...600,  tapSFM: 30...50,  tapCoatedSFM: 50...75,   boreSFM: 100...150, boreCarbideSFM: 350...600, reamSFM: 50...80,   reamCarbideSFM: 130...220, drillFeed: 0.006, chipLoad: 0.0035, reamFeed: 0.009),
        Material(id: "lowc",     name: "Low-Carbon Steel (1018)",     hardness: "~125 HB",    hssSFM: 90...130,  carbideSFM: 350...550,  feedIPR: 0.012, kp: 1.00, drillSFM: 60...100,  drillCarbideSFM: 200...350,  millSFM: 60...110,  millCarbideSFM: 300...500,  tapSFM: 25...40,  tapCoatedSFM: 40...60,   boreSFM: 80...120,  boreCarbideSFM: 300...500, reamSFM: 40...60,   reamCarbideSFM: 110...170, drillFeed: 0.005, chipLoad: 0.003, reamFeed: 0.008),
        Material(id: "medc",     name: "Medium-Carbon Steel (1045)",  hardness: "~180 HB",    hssSFM: 70...100,  carbideSFM: 300...450,  feedIPR: 0.011, kp: 1.10, drillSFM: 50...80,   drillCarbideSFM: 170...300,  millSFM: 50...90,   millCarbideSFM: 250...420,  tapSFM: 20...30,  tapCoatedSFM: 35...50,   boreSFM: 60...100,  boreCarbideSFM: 250...420, reamSFM: 35...55,   reamCarbideSFM: 100...150, drillFeed: 0.004, chipLoad: 0.0025, reamFeed: 0.007),
        Material(id: "alloy",    name: "Alloy Steel (4140)",          hardness: "~200 HB",    hssSFM: 60...90,   carbideSFM: 250...400,  feedIPR: 0.010, kp: 1.40, drillSFM: 40...70,   drillCarbideSFM: 150...280,  millSFM: 40...70,   millCarbideSFM: 200...380,  tapSFM: 15...25,  tapCoatedSFM: 25...40,   boreSFM: 50...80,   boreCarbideSFM: 200...380, reamSFM: 30...50,   reamCarbideSFM: 90...140,  drillFeed: 0.004, chipLoad: 0.002, reamFeed: 0.006),
        Material(id: "o1",       name: "O-1 Tool Steel (annealed)",   hardness: "~190 HB",    hssSFM: 55...80,   carbideSFM: 220...375,  feedIPR: 0.009, kp: 1.50, drillSFM: 40...65,   drillCarbideSFM: 130...260,  millSFM: 40...65,   millCarbideSFM: 180...340,  tapSFM: 12...22,  tapCoatedSFM: 22...35,   boreSFM: 45...75,   boreCarbideSFM: 180...350, reamSFM: 25...45,   reamCarbideSFM: 85...130,  drillFeed: 0.003, chipLoad: 0.0018, reamFeed: 0.005),
        Material(id: "tool",     name: "Tool Steel (annealed)",       hardness: "~220 HB",    hssSFM: 50...70,   carbideSFM: 200...350,  feedIPR: 0.009, kp: 1.40, drillSFM: 35...60,   drillCarbideSFM: 120...240,  millSFM: 35...60,   millCarbideSFM: 180...320,  tapSFM: 12...20,  tapCoatedSFM: 20...32,   boreSFM: 40...70,   boreCarbideSFM: 180...330, reamSFM: 25...45,   reamCarbideSFM: 80...120,  drillFeed: 0.003, chipLoad: 0.0018, reamFeed: 0.005),
        Material(id: "ss303",    name: "Stainless 303 (free-mach.)",  hardness: "~160 HB",    hssSFM: 70...100,  carbideSFM: 250...400,  feedIPR: 0.009, kp: 1.40, drillSFM: 40...70,   drillCarbideSFM: 130...250,  millSFM: 50...90,   millCarbideSFM: 200...350,  tapSFM: 12...22,  tapCoatedSFM: 22...35,   boreSFM: 50...90,   boreCarbideSFM: 200...350, reamSFM: 30...50,   reamCarbideSFM: 90...140,  drillFeed: 0.004, chipLoad: 0.0022, reamFeed: 0.007),
        Material(id: "ss304",    name: "Stainless 304 (austenitic)",  hardness: "~150 HB",    hssSFM: 50...80,   carbideSFM: 200...350,  feedIPR: 0.008, kp: 1.40, drillSFM: 30...50,   drillCarbideSFM: 100...180,  millSFM: 40...70,   millCarbideSFM: 180...320,  tapSFM: 10...18,  tapCoatedSFM: 18...28,   boreSFM: 40...70,   boreCarbideSFM: 150...280, reamSFM: 25...40,   reamCarbideSFM: 70...110,  drillFeed: 0.0035, chipLoad: 0.002, reamFeed: 0.006),
        Material(id: "ss316",    name: "Stainless 316 (austenitic)",  hardness: "~160 HB",    hssSFM: 40...70,   carbideSFM: 175...300,  feedIPR: 0.007, kp: 1.50, drillSFM: 25...45,   drillCarbideSFM: 90...160,   millSFM: 30...60,   millCarbideSFM: 150...280,  tapSFM: 8...15,   tapCoatedSFM: 15...24,   boreSFM: 30...60,   boreCarbideSFM: 120...250, reamSFM: 20...35,   reamCarbideSFM: 60...100,  drillFeed: 0.003, chipLoad: 0.0018, reamFeed: 0.005),
        Material(id: "ss416",    name: "Stainless 416 (free-mach.)",  hardness: "~180 HB",    hssSFM: 80...120,  carbideSFM: 300...450,  feedIPR: 0.009, kp: 1.30, drillSFM: 50...90,   drillCarbideSFM: 150...280,  millSFM: 60...100,  millCarbideSFM: 250...400,  tapSFM: 20...30,  tapCoatedSFM: 30...45,   boreSFM: 60...100,  boreCarbideSFM: 250...400, reamSFM: 40...60,   reamCarbideSFM: 100...150, drillFeed: 0.004, chipLoad: 0.0022, reamFeed: 0.007),
        Material(id: "ti",       name: "Titanium (Ti-6Al-4V)",        hardness: "~330 HB",    hssSFM: 30...50,   carbideSFM: 100...200,  feedIPR: 0.007, kp: 1.20, drillSFM: 20...40,   drillCarbideSFM: 50...100,   millSFM: 30...50,   millCarbideSFM: 100...200,  tapSFM: 8...14,   tapCoatedSFM: 12...20,   boreSFM: 25...40,   boreCarbideSFM: 80...150,  reamSFM: 15...25,   reamCarbideSFM: 40...70,   drillFeed: 0.0025, chipLoad: 0.0015, reamFeed: 0.005),
        Material(id: "inconel",  name: "Inconel / Superalloy",        hardness: "~300 HB",    hssSFM: 15...30,   carbideSFM: 60...120,   feedIPR: 0.006, kp: 2.20, drillSFM: 10...25,   drillCarbideSFM: 40...80,    millSFM: 15...30,   millCarbideSFM: 60...120,   tapSFM: 5...10,   tapCoatedSFM: 10...16,   boreSFM: 12...28,   boreCarbideSFM: 60...110,  reamSFM: 10...18,   reamCarbideSFM: 35...55,   drillFeed: 0.002, chipLoad: 0.0012, reamFeed: 0.004),
        Material(id: "plastic",  name: "Plastic / Nylon / Delrin",    hardness: "\u{2014}",   hssSFM: 200...500, carbideSFM: 400...1000, feedIPR: 0.012, kp: 0.10, drillSFM: 150...300, drillCarbideSFM: 300...600,  millSFM: 150...400, millCarbideSFM: 400...900,  tapSFM: 50...100, tapCoatedSFM: 100...150, boreSFM: 200...350, boreCarbideSFM: 400...700, reamSFM: 120...180, reamCarbideSFM: 200...300, drillFeed: 0.008, chipLoad: 0.005, reamFeed: 0.012),
    ]

    public static func byID(_ id: String) -> Material? { all.first { $0.id == id } }
}
