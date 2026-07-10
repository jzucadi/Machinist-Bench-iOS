import SwiftUI

struct InsertsSubView: View {
    let system: UnitSystem

    // MARK: - State

    /// Decoder input — default is §1b's first golden case.
    @State private var codeInput = "CNMG 432"

    /// ToolChooser wizard selections (defaults per §1c / A1 recommend()).
    @State private var op    = "turn"
    @State private var feat  = "plain"
    @State private var bfeat = "thru"
    @State private var cut   = "gen"
    @State private var mat   = "steel"
    @State private var mach  = "mid"

    // MARK: - Color bindings (§0 + B1 report table)

    /// Web highlight token → Catppuccin per the binding mapping table.
    private static func token(_ t: String) -> Color {
        switch t {
        case "S.blue":   return Catppuccin.blue
        case "S.teal":   return Catppuccin.teal
        case "S.green":  return Catppuccin.green
        case "S.amber":  return Catppuccin.peach     // Addendum ruling
        case "S.violet": return Catppuccin.mauve
        case "S.red":    return Catppuccin.red
        case "S.mut2":   return Catppuccin.overlay0
        default:         return Catppuccin.text
        }
    }

    /// §1c MAT2 material-grade map (verbatim) — mat key → (ISO class, grade, edge note).
    private static let mat2: [String: (iso: String, grade: String, edge: String)] = [
        "steel": ("ISO P", "coated carbide (CVD multilayer for turning)",
                  "molded M-tolerance edge is fine"),
        "ss":    ("ISO M", "tough PVD-coated grade",
                  "sharp edge, steady feed \u{2014} stainless work-hardens"),
        "ci":    ("ISO K", "K10\u{2013}K20, uncoated or thin coating",
                  "cuts fine dry"),
        "alu":   ("ISO N", "uncoated \u{00B7} polished \u{00B7} ground periphery \u{2014} GT inserts (CCGT / DCGT)",
                  "molded steel-grade inserts smear; polished edge is the whole game"),
        "pl":    ("ISO N", "same polished GT inserts as aluminum",
                  "high surface speed, gentle feed"),
        "hard":  ("ISO H", "CBN or ceramic for true hard turning (45 HRC and up)",
                  "standard carbide rubs"),
    ]

    /// §1d "Reading an Insert Code" position table (7 rows, verbatim).
    private static let positionRows: [[String]] = [
        ["1 \u{00B7} Shape",
         "C 80\u{00B0}\u{25C7} \u{00B7} D 55\u{00B0}\u{25C7} \u{00B7} R round \u{00B7} S square \u{00B7} T 60\u{00B0}\u{25B3} \u{00B7} V 35\u{00B0}\u{25C7} \u{00B7} W 80\u{00B0} trigon"],
        ["2 \u{00B7} Relief",
         "N 0\u{00B0} (negative) \u{00B7} C 7\u{00B0} \u{00B7} P 11\u{00B0} \u{00B7} B 5\u{00B0} (positive)"],
        ["3 \u{00B7} Tolerance",
         "M medium (\u{00B1}.002\u{2013}.005\u{2033}) \u{00B7} G precision \u{00B7} U utility"],
        ["4 \u{00B7} Hole/Chipbreaker",
         "G hole + chipbreaker \u{00B7} A hole only \u{00B7} N neither"],
        ["5\u{2013}6 \u{00B7} Size (IC)",
         "Metric IC \u{00F7} in mm \u{00B7} ANSI 1st digit = IC in \u{215B}\u{2033}"],
        ["7\u{2013}8 \u{00B7} Thickness",
         "Metric in mm \u{00B7} ANSI 2nd digit = thickness in 1\u{2044}16\u{2033}"],
        ["9\u{2013}10 \u{00B7} Corner Radius",
         "04=0.4mm \u{00B7} 08=0.8mm \u{00B7} 12=1.2mm \u{00B7} ANSI 3rd digit in 1\u{2044}64\u{2033}"],
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {

            // 7 insert silhouette cards (§1a + §1d)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 12)], spacing: 12) {
                ForEach(ToolingRef.insertCards, id: \.code) { card in
                    insertCard(card)
                }
            }
            .padding(.horizontal, 16)

            // Decoder panel (§1b + §1d position table)
            Panel(title: "Reading an Insert Code", accent: .blue) {
                decoderContent
            }
            .padding(.horizontal, 16)

            // Tool Chooser wizard (§1c)
            Panel(title: "Tool Chooser", accent: .green) {
                chooserContent
            }
            .padding(.horizontal, 16)

            // ISO Grades & Coatings — 6 cards (§1d)
            sectionLabel("ISO Grades & Coatings")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                ForEach(ToolingRef.insertGrades, id: \.letter) { g in
                    gradeCard(g)
                }
            }
            .padding(.horizontal, 16)

            // Nose Radii / Feed Rate / Finish (§1d, 4 rows)
            sectionLabel("Nose Radius \u{00B7} Feed \u{00B7} Depth of Cut")
            DataTable(
                columns: ["Radius", "Cut Type", "Chip Load", "DOC", "Notes"],
                rows: ToolingRef.insertNoseRadii.map { r in
                    [r.radiusLabel, r.cutType, r.chipLoad, r.doc, r.notes]
                },
                accent: .peach
            )
            .padding(.horizontal, 16)

            // Ra finish table (§1d, 5 rows) — header verbatim
            sectionLabel("Ra (\u{00B5}in) \u{2248} feed\u{00B2} \u{00F7} (32 \u{00D7} radius)", caps: false)
            DataTable(
                columns: ["Feed", "0.4 mm", "0.8 mm", "1.2 mm", "1.6 mm"],
                rows: ToolingRef.raFinishTable.map { r in
                    [r.feed, String(r.ra04), String(r.ra08), String(r.ra12), String(r.ra16)]
                },
                accent: .teal
            )
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Section label

    private func sectionLabel(_ s: String, caps: Bool = true) -> some View {
        Text(caps ? s.uppercased() : s)
            .font(AppFont.mono(11))
            .foregroundStyle(Catppuccin.subtext0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }

    // MARK: - Insert card (§1a silhouette + §1d fields)

    private func insertCard(_ card: InsertCardRow) -> some View {
        let color = Self.token(card.highlight)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 10) {
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 78, height: 78),
                              maxWidth: 78) { svg in
                    drawInsert(svg, sh: card.sh, ang: card.ang, color: color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(card.code)
                        .font(AppFont.display(16))
                        .foregroundStyle(color)
                    Text("\(card.ang)\u{00B0} \u{00B7} \(card.edges) edges \u{00B7} \(card.relief)")
                        .font(AppFont.mono(11))
                        .foregroundStyle(Catppuccin.subtext0)
                    Text("ISO \(card.isoSizes)")
                        .font(AppFont.mono(10))
                        .foregroundStyle(Catppuccin.overlay0)
                    Text("ANSI \(card.ansiSizes)")
                        .font(AppFont.mono(10))
                        .foregroundStyle(Catppuccin.overlay0)
                    Text("r \(card.radii)")
                        .font(AppFont.mono(10))
                        .foregroundStyle(Catppuccin.overlay0)
                }
            }

            Text(card.note)
                .font(AppFont.body(11))
                .foregroundStyle(Catppuccin.subtext0)
                .fixedSize(horizontal: false, vertical: true)

            // Use tags as chips
            HStack(spacing: 4) {
                ForEach(card.useTags.split(separator: ",").map(String.init), id: \.self) { tag in
                    Text(tag)
                        .font(AppFont.mono(9))
                        .foregroundStyle(color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.13), in: Capsule())
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(card.yours ? color.opacity(0.06) : Catppuccin.surface0,
                    in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(card.yours ? color.opacity(0.7) : Catppuccin.surface1,
                          lineWidth: card.yours ? 1.5 : 1))
    }

    // MARK: - InsertSVG (§1a, element-for-element, size = 78)

    private func drawInsert(_ svg: SVGContext, sh: String, ang: Int, color: Color) {
        let size: CGFloat = 78
        let cx = size / 2, cy = size / 2, r = size * 0.34   // 39, 39, 26.52

        var shape = Path()
        if sh == "triangle" || sh == "trigon" {
            // 3 points at (k*120 − 90)°
            var pts: [CGPoint] = []
            for k in 0..<3 {
                let a: Double = (Double(k) * 120.0 - 90.0) * Double.pi / 180.0
                let px: CGFloat = cx + r * CGFloat(cos(a))
                let py: CGFloat = cy + r * CGFloat(sin(a))
                pts.append(CGPoint(x: px, y: py))
            }
            shape.move(to: pts[0])
            shape.addLine(to: pts[1])
            shape.addLine(to: pts[2])
            shape.closeSubpath()
        } else if sh == "diamond" {
            // half = ang/2 in radians, L = r·1.15
            let half: Double = Double(ang) * Double.pi / 180.0 / 2.0
            let L: CGFloat = r * 1.15
            let dx: CGFloat = L * CGFloat(sin(half))
            shape.move(to: CGPoint(x: cx, y: cy - L))
            shape.addLine(to: CGPoint(x: cx + dx, y: cy))
            shape.addLine(to: CGPoint(x: cx, y: cy + L))
            shape.addLine(to: CGPoint(x: cx - dx, y: cy))
            shape.closeSubpath()
        } else if sh == "square" {
            shape.addRect(CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        } else {
            shape.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        }

        // Group: fill = color+"22" (≈0.13), stroke = color w=1.6 join=round
        svg.ctx.fill(shape, with: .color(color.opacity(0.13)))
        svg.ctx.stroke(shape, with: .color(color),
                       style: StrokeStyle(lineWidth: 1.6, lineJoin: .round))

        // Center dot: r=3, fill = color
        svg.circle(cx: cx, cy: cy, r: 3, fill: color)
    }

    // MARK: - ISO grade card (§1d, 6 cards)

    private func gradeCard(_ g: InsertGradeRow) -> some View {
        let color = Self.token(g.colorToken)
        return VStack(alignment: .leading, spacing: 3) {
            Text(g.letter)
                .font(AppFont.display(20))
                .foregroundStyle(color)
            Text(g.material)
                .font(AppFont.body(11))
                .foregroundStyle(Catppuccin.subtext0)
                .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(color.opacity(0.4), lineWidth: 1))
    }

    // MARK: - Decoder panel content (§1b)

    @ViewBuilder
    private var decoderContent: some View {
        let fields = InsertCode.decode(codeInput)

        Field(label: "Insert Code") {
            TextField("e.g. CNMG 432", text: $codeInput)
                .font(AppFont.mono(16))
                .foregroundStyle(Catppuccin.text)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Catppuccin.blue.opacity(0.2)))
        }

        if fields.isEmpty {
            NoteView(
                tone: .info,
                text: "Type an ANSI or ISO insert code \u{2014} e.g. CNMG 432, TNMG 160408, CCGT 21.51, VBMT 331."
            )
        } else {
            VStack(spacing: 1) {
                ForEach(fields.indices, id: \.self) { i in
                    decodeRow(fields[i], zebra: i % 2 == 0)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Catppuccin.blue.opacity(0.25)))
        }

        // §1d position table
        DataTable(columns: ["Position", "Meaning"],
                  rows: Self.positionRows,
                  accent: .blue)

        // §1d note (verbatim)
        NoteView(
            tone: .info,
            text: "ANSI \u{2194} ISO: WNMG 432 = WNMG 080408 \u{2192} \u{00BD}\u{2033} IC, 3\u{2044}16\u{2033} thick, 0.8 mm radius."
        )
    }

    private func decodeRow(_ f: InsertCodeField, zebra: Bool) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(f.label.uppercased())
                .font(AppFont.mono(10))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(width: 76, alignment: .leading)
            Text(f.code)
                .font(AppFont.display(13))
                .foregroundStyle(Catppuccin.blue)
                .frame(width: 30, alignment: .leading)
            Text(f.meaning)
                .font(AppFont.body(12))
                .foregroundStyle(Catppuccin.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(zebra ? Catppuccin.surface0 : Catppuccin.mantle)
    }

    // MARK: - Tool Chooser content (§1c, 6 segments)

    @ViewBuilder
    private var chooserContent: some View {
        let rec = ToolChooser.recommend(op: op, feat: feat, bfeat: bfeat,
                                        cut: cut, mat: mat, mach: mach)

        Field(label: "Operation") {
            segmentRows($op, ToolChooser.opOptions)
        }
        if op == "turn" {
            Field(label: "Workpiece") {
                segmentRows($feat, ToolChooser.featOptions)
            }
        }
        if op == "bore" {
            Field(label: "Bore") {
                segmentRows($bfeat, ToolChooser.bfeatOptions)
            }
        }
        Field(label: "Cut") {
            segmentRows($cut, ToolChooser.cutOptions)
        }
        Field(label: "Material") {
            segmentRows($mat, ToolChooser.matOptions)
        }
        Field(label: "Machine") {
            segmentRows($mach, ToolChooser.machOptions)
        }

        Readout(label: "Holder", value: rec.holder, unit: "", accent: .green)
        Readout(label: "Insert", value: rec.insert, unit: "", accent: .green)
        if let g = Self.mat2[mat] {
            Readout(label: "Grade", value: g.iso, unit: "",
                    sub: "\(g.grade) \u{00B7} \(g.edge)", accent: .green)
        }
        NoteView(tone: .info, text: rec.note)

        // §1c holder-code table (ISO 5608)
        Text("HOLDER CODE (ISO 5608)")
            .font(AppFont.mono(11))
            .foregroundStyle(Catppuccin.subtext0)
        DataTable(columns: ["Position", "Codes"],
                  rows: ToolingRef.holderCodes.map { [$0.position, $0.codes] },
                  accent: .green)
    }

    /// Segmented control wrapped into rows of ≤3 so 5–6-option web segments fit an iPhone.
    private func segmentRows(_ sel: Binding<String>, _ options: [SegmentOption]) -> some View {
        VStack(spacing: 4) {
            ForEach(Array(stride(from: 0, to: options.count, by: 3)), id: \.self) { start in
                Segmented(
                    selection: sel,
                    options: options[start..<min(start + 3, options.count)]
                        .map { ($0.key, $0.label) },
                    accent: .green
                )
            }
        }
    }
}

#Preview {
    ScrollView {
        InsertsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
