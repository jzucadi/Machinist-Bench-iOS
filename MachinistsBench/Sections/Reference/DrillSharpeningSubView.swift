import SwiftUI

/// Reference → Drill Sharpening (M7 B4).
/// Interactive drill-point diagram (§3 DrillPointSVG / DrillPointInteractive)
/// + point-angle, web-thickness, and deep-hole reduction tables (§3).
struct DrillSharpeningSubView: View {
    let system: UnitSystem

    /// Included point angle — §3 DrillPointInteractive default 118°.
    @State private var included: Double = 118

    /// §3 DrillPointInteractive: `const options = [60, 90, 118, 135]`.
    private static let presets: [(Double, String)] = [
        (60, "60\u{00B0}"), (90, "90\u{00B0}"), (118, "118\u{00B0}"), (135, "135\u{00B0}"),
    ]

    // MARK: - §3 static colors

    /// Photo-seam cover / diagram background (`#10151c`, element 3).
    private static let coverColor = Catppuccin.hex(0x10151c)
    /// Cone outline stroke (`#3a404a`, element 4).
    private static let coneStroke = Catppuccin.hex(0x3a404a)
    /// `dpCone` linear-gradient stops (element 1, verbatim).
    private static let coneStops: [(Color, CGFloat)] = [
        (Catppuccin.hex(0x6f7782), 0),
        (Catppuccin.hex(0xcfd5de), 0.28),
        (Catppuccin.hex(0x9aa1ac), 0.5),
        (Catppuccin.hex(0xc4cad3), 0.72),
        (Catppuccin.hex(0x5e6671), 1),
    ]

    // MARK: - §3 Deep-hole reduction tables (view-local, extraction-verbatim)

    private static let deepHoleSpeedRows: [[String]] = [
        ["3 \u{00D7} dia", "\u{2212}10%"],
        ["4 \u{00D7} dia", "\u{2212}20%"],
        ["5 \u{00D7} dia", "\u{2212}30%"],
        ["6\u{2013}8 \u{00D7} dia", "\u{2212}35 to \u{2212}40%"],
    ]
    private static let deepHoleFeedRows: [[String]] = [
        ["3\u{2013}4 \u{00D7} dia", "\u{2212}10%"],
        ["5\u{2013}8 \u{00D7} dia", "\u{2212}20%"],
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {

            // The Drill Point — interactive diagram (§3, accent S.teal)
            Panel(title: "The Drill Point", accent: .teal) {
                Segmented(selection: $included, options: Self.presets, accent: .teal)

                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 512, height: 512)) { svg in
                    drawDrillPoint(svg)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 16)

            // Point Angle by Material (§3, 6 rows, accent S.amber)
            Panel(title: "Point Angle by Material", accent: .peach,
                  subtitle: "included angle ground at the tip") {
                DataTable(
                    columns: ["Material", "Included Point Angle", "Lip Clearance", "Notes"],
                    rows: ToolingRef.drillPointAngles.map {
                        [$0.material, $0.pointAngle, $0.lipClearance, $0.notes]
                    },
                    accent: .peach
                )
            }
            .padding(.horizontal, 16)

            // Web Thinning (§3, 5 rows, accent S.violet)
            Panel(title: "Web Thinning", accent: .mauve) {
                DataTable(
                    columns: ["Drill \u{00D8}", "Web Thickness (% of \u{00D8})"],
                    rows: ToolingRef.drillWebThickness.map { [$0.drillDiam, $0.webPct] },
                    accent: .mauve
                )
            }
            .padding(.horizontal, 16)

            // Deep-Hole Speed & Feed Reduction (§3, accent S.orange → peach)
            Panel(title: "Deep-Hole Speed & Feed Reduction", accent: .peach,
                  subtitle: "reduce from the table values past ~3\u{00D7} diameter deep") {
                sectionLabel("Speed")
                DataTable(columns: ["Hole Depth", "Speed Cut"],
                          rows: Self.deepHoleSpeedRows, accent: .peach)
                sectionLabel("Feed")
                DataTable(columns: ["Hole Depth", "Feed Cut"],
                          rows: Self.deepHoleFeedRows, accent: .peach)
            }
            .padding(.horizontal, 16)
        }
    }

    private func sectionLabel(_ s: String) -> some View {
        Text(s.uppercased())
            .font(AppFont.mono(11))
            .foregroundStyle(Catppuccin.subtext0)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - §3 DrillPointSVG (element-for-element; color = S.teal per DrillPointInteractive)

    private func drawDrillPoint(_ svg: SVGContext) {
        // Angle-dependent geometry — Core only, never recomputed here.
        // outline() = [(bodyL, seamY), (cx, tipY), (bodyR, seamY)]
        let outline = DrillPointGeom.outline(includedDeg: included)
        let arc     = DrillPointGeom.arcPoints(includedDeg: included)
        let bodyL = outline[0].x, seamY = outline[0].y
        let cx    = outline[1].x, tipY  = outline[1].y
        let bodyR = outline[2].x

        let green  = Catppuccin.green            // S.green
        let amber  = Catppuccin.peach            // S.amber
        let teal   = Catppuccin.teal             // color = S.teal
        let mut    = Catppuccin.overlay1         // S.mut
        let mut2   = Catppuccin.overlay0         // S.mut2

        // Element 2 substitute — the web embeds a base64 drill photo; the
        // extraction directs "substitute a rendered SwiftUI drawing".
        // Dark photo background + gradient-shaded drill body above the seam.
        svg.rect(CGRect(x: 0, y: 0, width: 512, height: 512), fill: Self.coverColor)
        var bodyRect = Path()
        bodyRect.addRect(CGRect(x: bodyL, y: 0, width: bodyR - bodyL, height: seamY))
        svg.linearGradient(Self.coneStops, in: bodyRect,
                           start: CGPoint(x: bodyL, y: 0), end: CGPoint(x: bodyR, y: 0))
        svg.ctx.stroke(bodyRect, with: .color(Self.coneStroke), lineWidth: 1.2)
        // Flute-spiral suggestion (substitute detail only)
        for y in stride(from: CGFloat(40), through: 400, by: 72) {
            svg.line(bodyL, y + 26, bodyR, y,
                     stroke: Self.coverColor.opacity(0.55), width: 5)
        }

        // Element 3 — black cover below the photo seam (#10151c)
        svg.rect(CGRect(x: 0, y: seamY, width: 512, height: 512 - seamY),
                 fill: Self.coverColor)

        // Element 4 — cone triangle, dpCone gradient fill + #3a404a stroke 1.2 join=round
        var cone = Path()
        cone.move(to: outline[0])
        cone.addLine(to: outline[1])
        cone.addLine(to: outline[2])
        cone.closeSubpath()
        svg.linearGradient(Self.coneStops, in: cone,
                           start: CGPoint(x: bodyL, y: seamY),
                           end: CGPoint(x: bodyR, y: seamY))
        svg.ctx.stroke(cone, with: .color(Self.coneStroke),
                       style: StrokeStyle(lineWidth: 1.2, lineJoin: .round))

        // Elements 5–6 — edge highlights
        svg.line(bodyL + 1.5, seamY, bodyL + 1.5, seamY + 4,
                 stroke: .white.opacity(0.5), width: 1.6)
        svg.line(bodyR - 1.5, seamY, bodyR - 1.5, seamY + 4,
                 stroke: .white.opacity(0.3), width: 1.4)

        // Elements 7–8 — cutting lips, S.green 2.6 cap=round
        let lipStyle = StrokeStyle(lineWidth: 2.6, lineCap: .round)
        var lipL = Path(); lipL.move(to: CGPoint(x: cx, y: tipY)); lipL.addLine(to: CGPoint(x: bodyL, y: seamY))
        var lipR = Path(); lipR.move(to: CGPoint(x: cx, y: tipY)); lipR.addLine(to: CGPoint(x: bodyR, y: seamY))
        svg.ctx.stroke(lipL, with: .color(green), style: lipStyle)
        svg.ctx.stroke(lipR, with: .color(green), style: lipStyle)

        // Element 9 — included-angle arc `A 26 26 0 0 0`, S.green 1.4 opacity 0.85
        let arcPath = svgArcPath(from: arc.left, to: arc.right,
                                 r: 26, largeArc: false, sweep: false)
        svg.path(arcPath, stroke: green.opacity(0.85), width: 1.4)

        // Element 10 — dashed centerline, S.mut 1.2 dash "5 4" opacity 0.5
        svg.line(cx, seamY - 6, cx, tipY + 8,
                 stroke: mut.opacity(0.5), width: 1.2, dash: [5, 4])

        // Element 11 — "{included}° included", S.green mono 17 w700 middle
        svg.text("\(Int(included))\u{00B0} included", x: cx, y: tipY + 26, size: 17,
                 color: green, mono: true, anchor: .middle, weight: .bold)

        // Element 12 — chisel edge mark, S.amber 4 cap=round
        var chisel = Path()
        chisel.move(to: CGPoint(x: cx - 9, y: tipY - 3))
        chisel.addLine(to: CGPoint(x: cx + 9, y: tipY - 3))
        svg.ctx.stroke(chisel, with: .color(amber),
                       style: StrokeStyle(lineWidth: 4, lineCap: .round))

        // Elements 13–14 — chisel edge callout + label
        svg.line(cx + 9, tipY - 4, 376, tipY - 30, stroke: amber, width: 1.2)
        svg.text("chisel edge", x: 380, y: tipY - 32, size: 15,
                 color: amber, mono: true, anchor: .start, weight: .semibold)

        // Elements 15–17 — cutting lip callout + dot + label (color = S.teal)
        let lipMidX = (bodyL + cx) / 2
        let lipMidY = (seamY + tipY) / 2
        svg.line(lipMidX, lipMidY, 120, lipMidY - 18, stroke: teal, width: 1.2)
        svg.circle(cx: lipMidX, cy: lipMidY, r: 2.6, fill: teal)
        svg.text("cutting lip", x: 116, y: lipMidY - 20, size: 15,
                 color: teal, mono: true, anchor: .end, weight: .semibold)

        // Elements 18–20 — margin callout + dot + label (S.mut2)
        svg.line(275, 300, 384, 284, stroke: mut2, width: 1.2)
        svg.circle(cx: 275, cy: 300, r: 2.6, fill: mut2)
        svg.text("margin", x: 388, y: 286, size: 14,
                 color: mut2, mono: true, anchor: .start, weight: .semibold)

        // Elements 21–23 — flute callout + dot + label (S.mut2)
        svg.line(255, 360, 384, 360, stroke: mut2, width: 1.2)
        svg.circle(cx: 255, cy: 360, r: 2.6, fill: mut2)
        svg.text("flute", x: 388, y: 364, size: 14,
                 color: mut2, mono: true, anchor: .start, weight: .semibold)
    }
}

#Preview {
    ScrollView {
        DrillSharpeningSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
