import SwiftUI

struct GrindingSubView: View {
    let system: UnitSystem

    var body: some View {
        VStack(spacing: 16) {
            NoteView(
                tone: .info,
                text: "HSS tool angles are starting points — adjust for your machine, surface finish, and cut depth. Use a protractor or angle gauge to verify relief angles. Dress the wheel frequently for best results."
            )
            .padding(.horizontal, 16)

            // Four grinding-angle diagrams — adaptive (1 col on iPhone, 2+ on wider)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 12)], spacing: 12) {
                grindCard(planView)
                grindCard(sideView)
                grindCard(frontView)
                grindCard(endView)
            }
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Material", "Appr Relief", "Front Relief", "Top Rake", "Top Relief"],
                rows: RefTables.hssAngles.map { row in
                    [row.material, row.apprRelief, row.frontRelief, row.topRake, row.topRelief]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Job", "Abrasive", "Grit", "Grade"],
                rows: RefTables.grindingWheels.map { row in
                    [row.job, row.abrasive, row.grit, row.grade]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Card wrapper

    private func grindCard(_ draw: @escaping (SVGContext) -> Void) -> some View {
        DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 300, height: 170), draw: draw)
            .padding(6)
            .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Catppuccin.surface1, lineWidth: 1))
    }

    // MARK: - Shared gradient stop arrays (literal — metallic shading exempt from theme mapping)

    private static let gWorkStops: [(Color, CGFloat)] = [
        (Catppuccin.hex(0x283142), 0), (Catppuccin.hex(0x161d27), 1)
    ]
    private static let gBitAStops: [(Color, CGFloat)] = [
        (Catppuccin.hex(0xe6ebf2), 0), (Catppuccin.hex(0xc2c9d4), 0.5), (Catppuccin.hex(0x868d9c), 1)
    ]
    private static let gBitBCStops: [(Color, CGFloat)] = [
        (Catppuccin.hex(0xeef1f6), 0), (Catppuccin.hex(0xc2c9d4), 0.45), (Catppuccin.hex(0x7c8492), 1)
    ]
    private static let gWorkRStops: [(Color, CGFloat)] = [
        (Catppuccin.hex(0x324054), 0), (Catppuccin.hex(0x141b24), 1)
    ]
    private static let bitStroke = Catppuccin.hex(0x5b6472)

    // MARK: - SVG 1 — Plan View ("looking down on the work")

    private func planView(_ svg: SVGContext) {
        let blue   = Catppuccin.blue
        let mut    = Catppuccin.overlay1
        let red    = Catppuccin.red
        let teal   = Catppuccin.teal

        // Work rect — rounded corners (rx=2 per source SVG), vertical gradient
        let workRect = CGRect(x: 16, y: 26, width: 180, height: 44)
        let workPath = Path(roundedRect: workRect, cornerRadius: 2)
        svg.linearGradient(Self.gWorkStops, in: workPath,
                           start: CGPoint(x: 0, y: 26), end: CGPoint(x: 0, y: 70))
        svg.ctx.stroke(workPath, with: .color(blue), lineWidth: 1.3)

        // Work centerline — dash pattern "9 3 2 3"
        svg.line(10, 48, 202, 48, stroke: blue.opacity(0.6), width: 0.8, dash: [9, 3, 2, 3])

        // Feed direction line + arrowhead
        svg.line(150, 14, 64, 14, stroke: mut, width: 1.2)
        svg.poly([CGPoint(x:64,y:14), CGPoint(x:72,y:10.5), CGPoint(x:72,y:17.5)], fill: mut)
        svg.text("feed", x: 108, y: 10, size: 8, color: mut, mono: true, anchor: .middle)

        // Bit body — diagonal gradient (gBitA: x1=0,y1=0,x2=1,y2=1 → bounding box corners)
        var bitPath = Path()
        bitPath.move(to: CGPoint(x:140,y:70));  bitPath.addLine(to: CGPoint(x:123,y:132))
        bitPath.addLine(to: CGPoint(x:192,y:132)); bitPath.addLine(to: CGPoint(x:168,y:92))
        bitPath.closeSubpath()
        svg.linearGradient(Self.gBitAStops, in: bitPath,
                           start: CGPoint(x:123,y:70), end: CGPoint(x:192,y:132))
        svg.ctx.stroke(bitPath, with: .color(Self.bitStroke),
                       style: StrokeStyle(lineWidth: 1.4, lineJoin: .round))

        // Chip shape (Q bezier curves)
        var chipPath = Path()
        chipPath.move(to: CGPoint(x:150,y:88))
        chipPath.addQuadCurve(to: CGPoint(x:156,y:106), control: CGPoint(x:159,y:96))
        chipPath.addQuadCurve(to: CGPoint(x:170,y:94), control: CGPoint(x:168,y:104))
        svg.path(chipPath, stroke: Self.bitStroke, width: 1.2)

        // Chip highlight
        var chipHi = Path()
        chipHi.move(to: CGPoint(x:150,y:88))
        chipHi.addQuadCurve(to: CGPoint(x:156,y:106), control: CGPoint(x:159,y:96))
        svg.path(chipHi, stroke: Color.white.opacity(0.4), width: 0.8)

        // ① Approach angle: reference line + arc + label
        svg.line(140, 70, 140, 114, stroke: red, width: 0.8, dash: [3, 2])
        let arc1 = svgArcPath(from: CGPoint(x:140,y:104), to: CGPoint(x:131.2,y:102.8),
                              r: 34, largeArc: false, sweep: true)
        svg.path(arc1, stroke: red, width: 1.2)
        svg.text("① approach ∠", x: 126, y: 120, size: 10, color: red,
                 mono: true, anchor: .end, weight: .semibold)

        // ⑦ Nose radius callout
        svg.line(146, 74, 168, 62, stroke: teal, width: 0.8)
        svg.text("⑦ nose radius", x: 171, y: 62, size: 10, color: teal,
                 mono: true, anchor: .start, weight: .semibold)

        // Caption
        svg.text("plan view — looking down on the work", x: 150, y: 162, size: 8,
                 color: mut, mono: true, anchor: .middle)
    }

    // MARK: - SVG 2 — Side View ("bare bit, cutting edge at left")

    private func sideView(_ svg: SVGContext) {
        let mut   = Catppuccin.overlay1
        let amber = Catppuccin.peach   // S.amber
        let orange = Catppuccin.peach  // S.orange

        // Bit body — vertical gradient gBitB
        var bitPath = Path()
        bitPath.move(to: CGPoint(x:70,y:52));   bitPath.addLine(to: CGPoint(x:240,y:84))
        bitPath.addLine(to: CGPoint(x:240,y:128)); bitPath.addLine(to: CGPoint(x:86,y:128))
        bitPath.closeSubpath()
        svg.linearGradient(Self.gBitBCStops, in: bitPath,
                           start: CGPoint(x:0,y:52), end: CGPoint(x:0,y:128))
        svg.ctx.stroke(bitPath, with: .color(Self.bitStroke),
                       style: StrokeStyle(lineWidth: 1.4, lineJoin: .round))

        // Top face highlight
        svg.poly([CGPoint(x:70,y:52), CGPoint(x:240,y:84), CGPoint(x:232,y:92), CGPoint(x:78,y:62)],
                 fill: Color.white.opacity(0.18))

        // Chip breaker inset
        var cbPath = Path()
        cbPath.move(to: CGPoint(x:96,y:57));   cbPath.addLine(to: CGPoint(x:120,y:61))
        cbPath.addLine(to: CGPoint(x:116,y:71)); cbPath.addLine(to: CGPoint(x:92,y:67))
        cbPath.closeSubpath()
        // Fill only via svg.path; stroke once with .round lineJoin via ctx (removes duplicate miter stroke)
        svg.path(cbPath, fill: Catppuccin.hex(0x9aa2b1))
        svg.ctx.stroke(cbPath, with: .color(Self.bitStroke),
                       style: StrokeStyle(lineWidth: 1.0, lineJoin: .round))

        // Chip breaker highlight
        svg.line(96, 57, 120, 61, stroke: Color.white.opacity(0.45), width: 0.8)

        // "chip breaker" label
        svg.text("chip breaker", x: 150, y: 108, size: 7.5,
                 color: mut.opacity(0.85), mono: true, anchor: .middle)

        // ⑤ Top rake (back rake): ref line + arc + label
        svg.line(70, 52, 152, 52, stroke: amber, width: 0.8, dash: [3, 2])
        let arc5 = svgArcPath(from: CGPoint(x:126,y:52), to: CGPoint(x:125,y:62.4),
                              r: 56, largeArc: false, sweep: true)
        svg.path(arc5, stroke: amber, width: 1.2)
        svg.text("⑤ top rake (back rake)", x: 150, y: 40, size: 10, color: amber,
                 mono: true, anchor: .middle, weight: .semibold)

        // ④ Front relief: ref line + arc + label
        svg.line(70, 52, 70, 128, stroke: orange, width: 0.8, dash: [3, 2])
        let arc4 = svgArcPath(from: CGPoint(x:70,y:98), to: CGPoint(x:79.5,y:97),
                              r: 46, largeArc: false, sweep: false)
        svg.path(arc4, stroke: orange, width: 1.2)
        svg.text("④ front", x: 8, y: 100, size: 10, color: orange,
                 mono: true, anchor: .start, weight: .semibold)
        svg.text("relief", x: 8, y: 112, size: 10, color: orange,
                 mono: true, anchor: .start, weight: .semibold)

        // Caption
        svg.text("side view — bare bit, cutting edge at left", x: 150, y: 162, size: 8,
                 color: mut, mono: true, anchor: .middle)
    }

    // MARK: - SVG 3 — Front View ("cutting edge at top-left")

    private func frontView(_ svg: SVGContext) {
        let mut   = Catppuccin.overlay1
        let mauve = Catppuccin.mauve   // S.violet
        let green = Catppuccin.green

        // Bit body — vertical gradient gBitC (same stops as gBitB)
        var bitPath = Path()
        bitPath.move(to: CGPoint(x:78,y:58));   bitPath.addLine(to: CGPoint(x:220,y:82))
        bitPath.addLine(to: CGPoint(x:220,y:134)); bitPath.addLine(to: CGPoint(x:92,y:134))
        bitPath.closeSubpath()
        svg.linearGradient(Self.gBitBCStops, in: bitPath,
                           start: CGPoint(x:0,y:58), end: CGPoint(x:0,y:134))
        svg.ctx.stroke(bitPath, with: .color(Self.bitStroke),
                       style: StrokeStyle(lineWidth: 1.4, lineJoin: .round))

        // Top face
        svg.poly([CGPoint(x:78,y:58), CGPoint(x:220,y:82), CGPoint(x:212,y:90), CGPoint(x:86,y:68)],
                 fill: Color.white.opacity(0.16))

        // Chip breaker (Q curves)
        var cbPath = Path()
        cbPath.move(to: CGPoint(x:104,y:64))
        cbPath.addQuadCurve(to: CGPoint(x:112,y:80), control: CGPoint(x:116,y:70))
        cbPath.addQuadCurve(to: CGPoint(x:126,y:68), control: CGPoint(x:124,y:78))
        svg.path(cbPath, stroke: Self.bitStroke, width: 1.1)

        // Chip breaker highlight
        var cbHi = Path()
        cbHi.move(to: CGPoint(x:104,y:64))
        cbHi.addQuadCurve(to: CGPoint(x:112,y:80), control: CGPoint(x:116,y:70))
        svg.path(cbHi, stroke: Color.white.opacity(0.4), width: 0.7)

        // ⑥ Top relief (side rake): ref line + arc + label
        svg.line(78, 58, 152, 58, stroke: mauve, width: 0.8, dash: [3, 2])
        let arc6 = svgArcPath(from: CGPoint(x:130,y:58), to: CGPoint(x:129.3,y:66.7),
                              r: 52, largeArc: false, sweep: true)
        svg.path(arc6, stroke: mauve, width: 1.2)
        svg.text("⑥ top relief (side rake)", x: 150, y: 44, size: 10, color: mauve,
                 mono: true, anchor: .middle, weight: .semibold)

        // ② Approach relief: ref line + arc + labels
        svg.line(78, 58, 78, 134, stroke: green, width: 0.8, dash: [3, 2])
        let arc2 = svgArcPath(from: CGPoint(x:78,y:104), to: CGPoint(x:86.3,y:103.2),
                              r: 46, largeArc: false, sweep: false)
        svg.path(arc2, stroke: green, width: 1.2)
        svg.text("② approach", x: 8, y: 104, size: 10, color: green,
                 mono: true, anchor: .start, weight: .semibold)
        svg.text("relief", x: 8, y: 116, size: 10, color: green,
                 mono: true, anchor: .start, weight: .semibold)

        // Caption
        svg.text("front view — cutting edge at top-left", x: 150, y: 162, size: 8,
                 color: mut, mono: true, anchor: .middle)
    }

    // MARK: - SVG 4 — End View ("tool point on the work centerline")

    private func endView(_ svg: SVGContext) {
        let blue   = Catppuccin.blue
        let mut    = Catppuccin.overlay1
        let teal   = Catppuccin.teal
        let orange = Catppuccin.peach  // S.orange

        // Work cylinder — radial gradient gWorkR
        // objectBoundingBox cx=0.35 cy=0.32 r=0.75 on circle cx=88 cy=72 r=40
        // bbox: x=48 y=32 w=80 h=80 → center=(76, 57.6), endRadius=60
        let workCircle = Path(ellipseIn: CGRect(x: 48, y: 32, width: 80, height: 80))
        svg.radialGradient(Self.gWorkRStops, in: workCircle,
                           center: CGPoint(x: 76, y: 57.6),
                           startRadius: 0, endRadius: 60)
        svg.ctx.stroke(workCircle, with: .color(blue), lineWidth: 1.4)

        // Centerlines
        svg.line(42, 72, 134, 72, stroke: blue.opacity(0.6), width: 0.7, dash: [9, 3, 2, 3])
        svg.line(88, 26, 88, 118, stroke: blue.opacity(0.6), width: 0.7, dash: [9, 3, 2, 3])
        svg.text("work", x: 88, y: 22, size: 8, color: mut, mono: true, anchor: .middle)

        // Bit body — vertical gradient gBitD (same stops as gBitC)
        var bitPath = Path()
        bitPath.move(to: CGPoint(x:128,y:72));  bitPath.addLine(to: CGPoint(x:218,y:70))
        bitPath.addLine(to: CGPoint(x:232,y:124)); bitPath.addLine(to: CGPoint(x:141,y:124))
        bitPath.closeSubpath()
        svg.linearGradient(Self.gBitBCStops, in: bitPath,
                           start: CGPoint(x:0,y:70), end: CGPoint(x:0,y:124))
        svg.ctx.stroke(bitPath, with: .color(Self.bitStroke),
                       style: StrokeStyle(lineWidth: 1.4, lineJoin: .round))

        // Top face highlight
        svg.poly([CGPoint(x:128,y:72), CGPoint(x:218,y:70), CGPoint(x:214,y:80), CGPoint(x:132,y:82)],
                 fill: Color.white.opacity(0.15))

        // ③ Front clearance: ref line + arc + leader + label
        svg.line(128, 72, 128, 126, stroke: orange, width: 0.8, dash: [3, 2])
        let arc3 = svgArcPath(from: CGPoint(x:128,y:110), to: CGPoint(x:137.2,y:108.9),
                              r: 38, largeArc: false, sweep: false)
        svg.path(arc3, stroke: orange, width: 1.2)
        svg.line(130, 114, 112, 142, stroke: orange, width: 0.7)
        svg.text("③ front clearance", x: 12, y: 150, size: 10, color: orange,
                 mono: true, anchor: .start, weight: .semibold)

        // ⑦ Nose radius callout
        svg.line(130, 70, 166, 52, stroke: teal, width: 0.8)
        svg.text("⑦ nose radius", x: 170, y: 52, size: 10, color: teal,
                 mono: true, anchor: .start, weight: .semibold)

        // Caption
        svg.text("end view — tool point on the work centerline", x: 150, y: 162, size: 8,
                 color: mut, mono: true, anchor: .middle)
    }
}

#Preview {
    ScrollView {
        GrindingSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
