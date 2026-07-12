import SwiftUI

struct ToolStylesSubView: View {
    let system: UnitSystem

    // MARK: - Colors (§0 + B1-report bindings)
    // S.panel2 → Catppuccin.surface0 per §0-Addendum ruling 3
    private static let shankFill   = Catppuccin.surface0
    // S.line/S.line2 → Catppuccin.surface1 per §0-Addendum ruling 3
    private static let shankStroke = Catppuccin.surface1
    // head accent: S.violet → Catppuccin.mauve (web default is S.violet)
    private static let headColor   = Catppuccin.mauve

    var body: some View {
        VStack(spacing: 16) {

            // § 2 note pointing to Grinding (verbatim, bold "Grinding")
            (Text("The ") +
             Text("Grinding").fontWeight(.semibold) +
             Text(" view has the four labeled angle diagrams and the per-material grinding table — thirteen materials, in grinding order ① → ⑦."))
                .font(AppFont.body(13))
                .foregroundStyle(Catppuccin.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Catppuccin.blue.opacity(0.12),
                            in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Catppuccin.blue.opacity(0.4)))
                .padding(.horizontal, 16)

            // 5 tool-style cards — adaptive 2-col on iPhone
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(ToolingRef.toolStyles, id: \.typeKey) { row in
                    toolCard(row)
                }
            }
            .padding(.horizontal, 16)

            // Tool-styles summary table
            DataTable(
                columns: ["Name", "Description"],
                rows: ToolingRef.toolStyles.map { row in
                    [row.name, row.description]
                },
                accent: .peach
            )
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Card container

    private func toolCard(_ row: ToolStyleRow) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 110, height: 94)) { svg in
                drawToolStyle(svg, typeKey: row.typeKey)
            }
            .padding(4)
            .background(Catppuccin.mantle, in: RoundedRectangle(cornerRadius: 8))

            Text(row.name)
                .font(AppFont.display(11))
                .foregroundStyle(Catppuccin.mauve)
                .lineLimit(2)

            Text(row.description)
                .font(AppFont.body(10))
                .foregroundStyle(Catppuccin.subtext0)
                .lineLimit(3)
        }
        .padding(10)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Catppuccin.surface1, lineWidth: 1))
    }

    // MARK: - SVG drawing (§2 exact paths)
    //
    // Colors: g  = S.panel2 (shank fill), gl = S.line2 (shank stroke, w=1.5)
    //         head fill = color+"25" (opacity≈0.145), head stroke = color w=2 join=round

    private func drawToolStyle(_ svg: SVGContext, typeKey: String) {
        let g        = Self.shankFill
        let gl       = Self.shankStroke
        let color    = Self.headColor
        let headFill = color.opacity(0.145)   // "25" suffix → 0x25/0xFF ≈ 0.145

        switch typeKey {

        case "rh":
            // Shank: x=48 y=34 w=58 h=40 rx=2
            svg.roundedRect(CGRect(x: 48, y: 34, width: 58, height: 40),
                            cornerRadius: 2, fill: g, stroke: gl, width: 1.5)
            // Head: M16,70 L60,50 L60,78 L42,78 Z
            var h = Path()
            h.move(to: CGPoint(x: 16, y: 70))
            h.addLine(to: CGPoint(x: 60, y: 50))
            h.addLine(to: CGPoint(x: 60, y: 78))
            h.addLine(to: CGPoint(x: 42, y: 78))
            h.closeSubpath()
            svg.ctx.fill(h, with: .color(headFill))
            svg.ctx.stroke(h, with: .color(color),
                           style: StrokeStyle(lineWidth: 2, lineJoin: .round))

        case "lh":
            // Shank: x=4 y=34 w=58 h=40 rx=2
            svg.roundedRect(CGRect(x: 4, y: 34, width: 58, height: 40),
                            cornerRadius: 2, fill: g, stroke: gl, width: 1.5)
            // Head: M94,70 L50,50 L50,78 L68,78 Z
            var h = Path()
            h.move(to: CGPoint(x: 94, y: 70))
            h.addLine(to: CGPoint(x: 50, y: 50))
            h.addLine(to: CGPoint(x: 50, y: 78))
            h.addLine(to: CGPoint(x: 68, y: 78))
            h.closeSubpath()
            svg.ctx.fill(h, with: .color(headFill))
            svg.ctx.stroke(h, with: .color(color),
                           style: StrokeStyle(lineWidth: 2, lineJoin: .round))

        case "face":
            // Shank: x=46 y=38 w=60 h=36 rx=2
            svg.roundedRect(CGRect(x: 46, y: 38, width: 60, height: 36),
                            cornerRadius: 2, fill: g, stroke: gl, width: 1.5)
            // Head: M18,46 L58,44 L58,78 L40,80 Z
            var h = Path()
            h.move(to: CGPoint(x: 18, y: 46))
            h.addLine(to: CGPoint(x: 58, y: 44))
            h.addLine(to: CGPoint(x: 58, y: 78))
            h.addLine(to: CGPoint(x: 40, y: 80))
            h.closeSubpath()
            svg.ctx.fill(h, with: .color(headFill))
            svg.ctx.stroke(h, with: .color(color),
                           style: StrokeStyle(lineWidth: 2, lineJoin: .round))

        case "round":
            // Shank: x=58 y=40 w=48 h=36 rx=2
            svg.roundedRect(CGRect(x: 58, y: 40, width: 48, height: 36),
                            cornerRadius: 2, fill: g, stroke: gl, width: 1.5)
            // Head: M62,42 L46,42 A28,28 0 0,0 46,76 L62,76 Z
            // Arc: from (46,42) to (46,76), r=28, largeArc=0, sweep=0
            // SVG endpoint→center: dx=0, dy=17, d2=289, r2=784
            //   h2=495/289, sign=-1 (largeArc==sweep → both false → true)
            //   sq≈-1.309 → cx≈68.25, cy=59
            //   clockwise = !sweep = !false = true  (UIKit: true=visual CCW → leftward bulge ✓)
            var h = Path()
            h.move(to: CGPoint(x: 62, y: 42))
            h.addLine(to: CGPoint(x: 46, y: 42))
            h.addArc(center: CGPoint(x: 68.25, y: 59), radius: 28,
                     startAngle: .radians(atan2(42.0 - 59.0, 46.0 - 68.25)),
                     endAngle:   .radians(atan2(76.0 - 59.0, 46.0 - 68.25)),
                     clockwise: true)  // !sweep: SVG sweep=0 → UIKit clockwise=true
            h.addLine(to: CGPoint(x: 62, y: 76))
            h.closeSubpath()
            svg.ctx.fill(h, with: .color(headFill))
            svg.ctx.stroke(h, with: .color(color),
                           style: StrokeStyle(lineWidth: 2, lineJoin: .round))

        case "part":
            // Shank: x=30 y=12 w=50 h=22 rx=2
            svg.roundedRect(CGRect(x: 30, y: 12, width: 50, height: 22),
                            cornerRadius: 2, fill: g, stroke: gl, width: 1.5)
            // Head: M48,34 L62,34 L62,84 L48,84 Z
            var h = Path()
            h.move(to: CGPoint(x: 48, y: 34))
            h.addLine(to: CGPoint(x: 62, y: 34))
            h.addLine(to: CGPoint(x: 62, y: 84))
            h.addLine(to: CGPoint(x: 48, y: 84))
            h.closeSubpath()
            svg.ctx.fill(h, with: .color(headFill))
            svg.ctx.stroke(h, with: .color(color),
                           style: StrokeStyle(lineWidth: 2, lineJoin: .round))

        default:
            // threading (else): x=46 y=36 w=60 h=38 rx=2 / M40,84 L24,46 L56,46 Z
            svg.roundedRect(CGRect(x: 46, y: 36, width: 60, height: 38),
                            cornerRadius: 2, fill: g, stroke: gl, width: 1.5)
            var h = Path()
            h.move(to: CGPoint(x: 40, y: 84))
            h.addLine(to: CGPoint(x: 24, y: 46))
            h.addLine(to: CGPoint(x: 56, y: 46))
            h.closeSubpath()
            svg.ctx.fill(h, with: .color(headFill))
            svg.ctx.stroke(h, with: .color(color),
                           style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        }
    }
}

#Preview {
    ScrollView {
        ToolStylesSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
