import SwiftUI

/// Reference → Print Symbols (M7 B4).
/// Mark Finder search (§6.4), drawing-symbol cards (§6.1), notation table (§6.5),
/// feature-control-frame anatomy (§6.3), material modifiers (§6.5),
/// and the 14 GD&T characteristics with GdtSym icons (§6.2 + §6.5).
struct PrintsSubView: View {
    let system: UnitSystem

    @State private var query = ""

    // MARK: - §6.1 symbol cards (key, name, description — web-verbatim)

    private static let symbolCards: [(key: String, name: String, desc: String)] = [
        ("dia", "\u{2300} Diameter",
         "Precedes a value to mean the dimension is a diameter (round feature)."),
        ("radius", "R Radius",
         "Precedes a value for a radius \u{2014} e.g. R0.25."),
        ("cbore", "\u{2334} Counterbore",
         "Flat-bottomed enlargement for a socket-head cap to sit flush; also spotface."),
        ("csink", "\u{2335} Countersink",
         "Conical recess for a flat-head screw (usually 82\u{00B0} or 90\u{00B0})."),
        ("depth", "\u{21A7} Depth",
         "\"Deep\" \u{2014} the feature goes down this far (paired with \u{2300} or thread)."),
        ("square", "\u{25A1} Square",
         "The feature is square, across flats."),
    ]

    /// Family group order for the 14 characteristics (§6.5 order preserved).
    private static let familyOrder: [String] = {
        var seen: [String] = []
        for row in ToolingRef.gdtCharacteristics where !seen.contains(row.family) {
            seen.append(row.family)
        }
        return seen
    }()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {

            // Mark Finder (§6.4, accent S.blue)
            Panel(title: "Mark Finder", accent: .blue,
                  subtitle: "abbreviations \u{00B7} symbols \u{00B7} standards bodies") {
                markFinderContent
            }
            .padding(.horizontal, 16)

            // Drawing & Print Symbols (§6.1 cards + §6.5 notation, accent S.blue)
            Panel(title: "Drawing & Print Symbols", accent: .blue,
                  subtitle: "reading the shop drawing") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)],
                          spacing: 12) {
                    ForEach(Self.symbolCards, id: \.key) { card in
                        symbolCard(card)
                    }
                }
                DataTable(
                    columns: ["Notation", "Meaning"],
                    rows: ToolingRef.gdtNotation.map { [$0.notation, $0.meaning] },
                    accent: .blue
                )
                NoteView(
                    tone: .info,
                    text: "Surface finish is called out with a check-mark symbol and a number, e.g. 32 = 32 \u{00B5}in Ra. Feature-control frames \u{2014} the boxed GD&T callouts \u{2014} are decoded below."
                )
            }
            .padding(.horizontal, 16)

            // GD&T — Reading the Frame (§6.3 + modifiers §6.5, accent S.violet)
            Panel(title: "GD&T \u{2014} Reading the Frame", accent: .mauve,
                  subtitle: "ASME Y14.5 feature control frame") {
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 300, height: 118)) { svg in
                    drawGdtFrame(svg)
                }
                Text("MATERIAL MODIFIERS")
                    .font(AppFont.mono(11))
                    .foregroundStyle(Catppuccin.overlay1)
                DataTable(
                    columns: ["Symbol", "Name", "Meaning"],
                    rows: ToolingRef.gdtModifiers.map { [$0.symbol, $0.name, $0.meaning] },
                    accent: .mauve
                )
            }
            .padding(.horizontal, 16)

            // GD&T — The 14 Characteristics (§6.2 icons + §6.5 rows, accent S.violet)
            Panel(title: "GD&T \u{2014} The 14 Characteristics", accent: .mauve,
                  subtitle: "form \u{00B7} orientation \u{00B7} profile \u{00B7} location \u{00B7} runout") {
                ForEach(Self.familyOrder, id: \.self) { family in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(family.uppercased())
                            .font(AppFont.mono(11))
                            .foregroundStyle(Catppuccin.mauve)
                            .padding(.top, 6)
                            .padding(.bottom, 4)
                        ForEach(ToolingRef.gdtCharacteristics.filter { $0.family == family },
                                id: \.key) { row in
                            characteristicRow(row)
                        }
                    }
                }
                NoteView(
                    tone: .info,
                    text: "Per ASME Y14.5-2009, which most prints in circulation still use. The 2018 revision deleted concentricity and symmetry \u{2014} both are better measured as runout or position \u{2014} so expect those two on older drawings only."
                )
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Mark Finder (§6.4)

    @ViewBuilder
    private var markFinderContent: some View {
        TextField("type a mark or a meaning \u{2014} PCD, flats, therefore, JIS\u{2026}",
                  text: $query)
            .font(AppFont.mono(15))
            .foregroundStyle(Catppuccin.text)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Catppuccin.blue.opacity(0.2)))

        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            // Web-faithful (§6.4): empty query shows the hint only, no table.
            Text("~120 drawing abbreviations, math symbols, and standards bodies \u{2014} searches both directions.")
                .font(AppFont.mono(11))
                .foregroundStyle(Catppuccin.overlay1)
        } else {
            let hits = MarkFinder.search(query)
            if hits.isEmpty {
                Text("No match \u{2014} try fewer letters, or a word from the meaning.")
                    .font(AppFont.body(13))
                    .foregroundStyle(Catppuccin.overlay0)
            } else {
                markTable(hits)
                if hits.count == 40 {
                    Text("first 40 shown \u{2014} keep typing")
                        .font(AppFont.mono(11))
                        .foregroundStyle(Catppuccin.overlay1)
                }
            }
        }
    }

    private func markTable(_ rows: [MarkRow]) -> some View {
        DataTable(
            columns: ["Mark", "Meaning", "Type"],
            rows: rows.map { [$0.mark, $0.meaning, $0.context] },
            accent: .blue
        )
    }

    // MARK: - Symbol card (§6.1, viewBox 0 0 48 48 rendered at 38×38)

    private func symbolCard(_ card: (key: String, name: String, desc: String)) -> some View {
        VStack(spacing: 0) {
            DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 48, height: 48),
                          maxWidth: 38) { svg in
                Self.drawGDTSymbol(svg, sym: card.key)
            }
            Text(card.name)
                .font(AppFont.display(12))
                .foregroundStyle(Catppuccin.blue)
                .padding(.top, 8)
            Text(card.desc)
                .font(AppFont.body(11))
                .foregroundStyle(Catppuccin.overlay0)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 5)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Catppuccin.surface1, lineWidth: 1))
    }

    /// §6.1 GDTSymbol — st = S.blue, sw = 3.2, element-for-element.
    private static func drawGDTSymbol(_ svg: SVGContext, sym: String) {
        let st = Catppuccin.blue
        let sw: CGFloat = 3.2
        let round = StrokeStyle(lineWidth: sw, lineCap: .round, lineJoin: .round)

        switch sym {
        case "dia":
            svg.circle(cx: 24, cy: 24, r: 13, stroke: st, width: sw)
            svg.line(13, 35, 35, 13, stroke: st, width: sw)
        case "radius":
            // <text x=24 y=33 fontFamily="Georgia,serif" fontSize=30 fontWeight=700>R</text>
            let resolved = svg.ctx.resolve(
                Text("R")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(st)
            )
            let w = resolved.measure(in: CGSize(width: 100, height: 100)).width
            svg.ctx.draw(resolved,
                         at: CGPoint(x: 24 - w / 2, y: 33 - 30 * 0.75),
                         anchor: .topLeading)
        case "cbore":
            var p = Path()
            p.move(to: CGPoint(x: 11, y: 12))
            p.addLine(to: CGPoint(x: 11, y: 36))
            p.addLine(to: CGPoint(x: 37, y: 36))
            p.addLine(to: CGPoint(x: 37, y: 12))
            svg.ctx.stroke(p, with: .color(st), style: round)
        case "csink":
            var p = Path()
            p.move(to: CGPoint(x: 10, y: 15))
            p.addLine(to: CGPoint(x: 24, y: 35))
            p.addLine(to: CGPoint(x: 38, y: 15))
            svg.ctx.stroke(p, with: .color(st), style: round)
        case "depth":
            svg.line(24, 11, 24, 35, stroke: st, width: sw)
            var p = Path()
            p.move(to: CGPoint(x: 16, y: 28))
            p.addLine(to: CGPoint(x: 24, y: 37))
            p.addLine(to: CGPoint(x: 32, y: 28))
            svg.ctx.stroke(p, with: .color(st), style: round)
        case "square":
            svg.rect(CGRect(x: 12, y: 12, width: 24, height: 24), stroke: st, width: sw)
        default:
            break
        }
    }

    // MARK: - Characteristic row (§6.2 icon + §6.5 name/description)

    private func characteristicRow(_ row: GdtCharacteristicRow) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Catppuccin.mantle)   // web S.inset → mantle (§0-Addendum ruling 3)
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 22, height: 22),
                              maxWidth: 22) { svg in
                    Self.drawGdtSym(svg, key: row.key)
                }
            }
            .frame(width: 30, height: 30)

            (Text(row.name)
                .font(AppFont.body(13).weight(.semibold))
                .foregroundColor(Catppuccin.text)
             + Text("  ")
             + Text(row.description)
                .font(AppFont.body(12))
                .foregroundColor(Catppuccin.overlay0))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
        }
        .padding(.vertical, 7)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Catppuccin.surface1).frame(height: 1)
        }
    }

    /// §6.2 GdtSym — P = {stroke: S.ink, sw 1.5, cap/join round}, element-for-element.
    private static func drawGdtSym(_ svg: SVGContext, key: String) {
        let ink = Catppuccin.text
        let style = StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)

        func stroke(_ p: Path) { svg.ctx.stroke(p, with: .color(ink), style: style) }
        func ln(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat) {
            var p = Path()
            p.move(to: CGPoint(x: x1, y: y1))
            p.addLine(to: CGPoint(x: x2, y: y2))
            stroke(p)
        }
        func circ(_ r: CGFloat) {
            stroke(Path(ellipseIn: CGRect(x: 11 - r, y: 11 - r, width: r * 2, height: r * 2)))
        }
        /// Arc "M4,14 A8,8 0 0 1 18,14" (profL / profS)
        func profArc() {
            stroke(svgArcPath(from: CGPoint(x: 4, y: 14), to: CGPoint(x: 18, y: 14),
                              r: 8, largeArc: false, sweep: true))
        }

        switch key {
        case "straight":
            ln(3, 11, 19, 11)
        case "flat":
            var p = Path()
            p.move(to: CGPoint(x: 4, y: 15))
            p.addLine(to: CGPoint(x: 8, y: 7))
            p.addLine(to: CGPoint(x: 18, y: 7))
            p.addLine(to: CGPoint(x: 14, y: 15))
            p.closeSubpath()
            stroke(p)
        case "circ":
            circ(6)
        case "cyl":
            circ(5); ln(5, 18, 9, 4); ln(13, 18, 17, 4)
        case "par":
            ln(7, 17, 12, 5); ln(12, 17, 17, 5)
        case "perp":
            ln(11, 5, 11, 16); ln(4, 16, 18, 16)
        case "ang":
            ln(4, 16, 18, 16); ln(4, 16, 15, 6)
        case "profL":
            profArc()
        case "profS":
            profArc(); ln(4, 14, 18, 14)
        case "pos":
            circ(5); ln(2, 11, 20, 11); ln(11, 2, 11, 20)
        case "conc":
            circ(3); circ(6.5)
        case "symm":
            ln(5, 7, 17, 7); ln(3, 11, 19, 11); ln(5, 15, 17, 15)
        case "runC":
            ln(5, 17, 15, 7)
            // "M15,7 L10,8.2 M15,7 L13.8,12"
            ln(15, 7, 10, 8.2); ln(15, 7, 13.8, 12)
        case "runT":
            ln(3, 17, 11, 9)
            // "M11,9 L6.6,10 M11,9 L10,13.4"
            ln(11, 9, 6.6, 10); ln(11, 9, 10, 13.4)
            ln(9, 17, 17, 9)
            // "M17,9 L12.6,10 M17,9 L16,13.4"
            ln(17, 9, 12.6, 10); ln(17, 9, 16, 13.4)
        default:
            break
        }
    }

    // MARK: - §6.3 GdtFrame (viewBox 0 0 300 118, 19 elements)

    private func drawGdtFrame(_ svg: SVGContext) {
        let boxStroke = Catppuccin.surface1     // S.line2
        let lead      = Catppuccin.overlay1     // S.mut
        let lt        = Catppuccin.overlay0     // S.mut2
        let ink       = Catppuccin.text         // S.ink

        // 1 — outer frame
        svg.rect(CGRect(x: 10, y: 14, width: 206, height: 28),
                 stroke: boxStroke, width: 1.4)
        // 2 — compartment dividers at x = [40, 118, 144, 168, 192]
        for x in [40, 118, 144, 168, 192] {
            svg.line(CGFloat(x), 14, CGFloat(x), 42, stroke: boxStroke, width: 1.4)
        }
        // 3–5 — position symbol (circle + crosshair)
        svg.circle(cx: 25, cy: 28, r: 6.5, stroke: ink, width: 1.5)
        svg.line(15, 28, 35, 28, stroke: ink, width: 1.5)
        svg.line(25, 18, 25, 38, stroke: ink, width: 1.5)
        // 6 — "⌀ .005"
        svg.text("\u{2300} .005", x: 79, y: 32, size: 12, color: ink,
                 mono: true, anchor: .middle)
        // 7–8 — MMC circle + "M"
        svg.circle(cx: 131, cy: 28, r: 8, stroke: ink, width: 1.3)
        svg.text("M", x: 131, y: 31.5, size: 9, color: ink, mono: true, anchor: .middle)
        // 9–11 — datums A B C
        svg.text("A", x: 156, y: 32, size: 12, color: ink, mono: true, anchor: .middle)
        svg.text("B", x: 180, y: 32, size: 12, color: ink, mono: true, anchor: .middle)
        svg.text("C", x: 204, y: 32, size: 12, color: ink, mono: true, anchor: .middle)
        // 12–13 — datums lead + label
        svg.line(180, 42, 180, 56, stroke: lead, width: 1)
        svg.text("datums 1\u{00B0} \u{00B7} 2\u{00B0} \u{00B7} 3\u{00B0}", x: 186, y: 59,
                 size: 8.5, color: lt, mono: true, anchor: .start)
        // 14–15 — material modifier lead + label
        svg.line(131, 42, 131, 72, stroke: lead, width: 1)
        svg.text("material modifier", x: 137, y: 75,
                 size: 8.5, color: lt, mono: true, anchor: .start)
        // 16–17 — zone shape · tolerance lead + label
        svg.line(79, 42, 79, 88, stroke: lead, width: 1)
        svg.text("zone shape \u{00B7} tolerance", x: 85, y: 91,
                 size: 8.5, color: lt, mono: true, anchor: .start)
        // 18–19 — geometric characteristic lead + label
        svg.line(25, 42, 25, 104, stroke: lead, width: 1)
        svg.text("geometric characteristic", x: 31, y: 107,
                 size: 8.5, color: lt, mono: true, anchor: .start)
    }
}

#Preview {
    ScrollView {
        PrintsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
