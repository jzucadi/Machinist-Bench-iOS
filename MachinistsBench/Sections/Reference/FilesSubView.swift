import SwiftUI

struct FilesSubView: View {
    let system: UnitSystem

    // MARK: - Colors (§5 + §0 bindings)
    // S.orange → Catppuccin.peach per §0-Addendum ruling 1 (peach is Mocha's orange)
    private static let fileColor = Catppuccin.peach
    // fill = color + "22" → opacity 0x22/0xFF ≈ 0.133
    private static let fileFill  = Catppuccin.peach.opacity(0.133)
    // safe edge: S.green → Catppuccin.green
    private static let safeEdge  = Catppuccin.green
    // stroke width per §5
    private static let sw: CGFloat = 1.8

    var body: some View {
        VStack(spacing: 16) {

            // 11 file cross-section cards — adaptive grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 10)], spacing: 10) {
                ForEach(ToolingRef.fileShapes, id: \.shapeKey) { row in
                    fileCard(row)
                }
            }
            .padding(.horizontal, 16)

            // §5 note (verbatim)
            NoteView(
                tone: .info,
                text: "Coarseness for a given cut name gets finer as the file gets shorter — a 6\u{2033} bastard is finer than a 12\u{2033} bastard. Swiss-pattern and needle files use numbers instead: 00 (coarsest) through 6 (finest), for precision and die work."
            )
            .padding(.horizontal, 16)

            // Cut / Coarseness table (5-row, accent S.amber → .peach)
            DataTable(
                columns: ["Cut", "Relative Coarseness", "Use"],
                rows: ToolingRef.fileGrades.map { row in
                    [row.cut, row.coarseness, row.use]
                },
                accent: .peach
            )
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Card container

    private func fileCard(_ row: FileShapeRow) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            DiagramCanvas(
                viewBox: CGRect(x: 0, y: 0, width: 60, height: 56),
                maxWidth: 46
            ) { svg in
                drawFileShape(svg, shape: row.shapeKey)
            }

            Text(row.name)
                .font(AppFont.display(10))
                .foregroundStyle(Catppuccin.text)
                .lineLimit(1)

            Text(row.description)
                .font(AppFont.body(9))
                .foregroundStyle(Catppuccin.subtext0)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Catppuccin.surface1, lineWidth: 1))
    }

    // MARK: - SVG drawing (§5 exact paths/elements)
    //
    // Base params: fill = color+"22" (≈0.133 opacity), st = color, sw = 1.8
    // Safe edge (S.green): hand top, pillar top+bottom
    // strokeLinejoin=round where noted

    private func drawFileShape(_ svg: SVGContext, shape: String) {
        let color = Self.fileColor
        let fill  = Self.fileFill
        let green = Self.safeEdge
        let sw    = Self.sw

        switch shape {

        case "flat":
            // rect x=8 y=20 w=44 h=20 rx=2
            svg.roundedRect(CGRect(x: 8, y: 20, width: 44, height: 20),
                            cornerRadius: 2, fill: fill, stroke: color, width: sw)

        case "hand":
            // rect (same as flat) + safe-edge line top
            svg.roundedRect(CGRect(x: 8, y: 20, width: 44, height: 20),
                            cornerRadius: 2, fill: fill, stroke: color, width: sw)
            svg.line(8, 20, 52, 20, stroke: green, width: 2.6)

        case "pillar":
            // rect x=18 y=16 w=24 h=28 rx=2 + safe edges top & bottom
            svg.roundedRect(CGRect(x: 18, y: 16, width: 24, height: 28),
                            cornerRadius: 2, fill: fill, stroke: color, width: sw)
            svg.line(18, 16, 42, 16, stroke: green, width: 2.4)
            svg.line(18, 44, 42, 44, stroke: green, width: 2.4)

        case "square":
            // rect x=16 y=14 w=28 h=28 rx=1.5
            svg.roundedRect(CGRect(x: 16, y: 14, width: 28, height: 28),
                            cornerRadius: 1.5, fill: fill, stroke: color, width: sw)

        case "round":
            // circle cx=30 cy=30 r=15
            svg.circle(cx: 30, cy: 30, r: 15, fill: fill, stroke: color, width: sw)

        case "halfround":
            // M12,38 A18,18 0 0,1 48,38 Z
            // Arc: from (12,38) to (48,38), r=18, largeArc=false, sweep=true
            // Perfect semicircle: center=(30,38), sweep=1 → clockwise=false (visual CW in iOS)
            // Goes downward through (30, 56) — flat top at y=38, curved bottom
            var p = Path()
            p.move(to: CGPoint(x: 12, y: 38))
            p.addArc(center: CGPoint(x: 30, y: 38), radius: 18,
                     startAngle: .radians(Double.pi),
                     endAngle:   .radians(0),
                     clockwise: false)   // !sweep: SVG sweep=1 → UIKit clockwise=false
            p.closeSubpath()
            svg.path(p, fill: fill, stroke: color, width: sw)

        case "triangle":
            // M30,15 L47,42 L13,42 Z  strokeLinejoin=round
            var p = Path()
            p.move(to: CGPoint(x: 30, y: 15))
            p.addLine(to: CGPoint(x: 47, y: 42))
            p.addLine(to: CGPoint(x: 13, y: 42))
            p.closeSubpath()
            svg.ctx.fill(p, with: .color(fill))
            svg.ctx.stroke(p, with: .color(color),
                           style: StrokeStyle(lineWidth: sw, lineJoin: .round))

        case "knife":
            // M14,22 L46,30 L14,38 Z  strokeLinejoin=round
            var p = Path()
            p.move(to: CGPoint(x: 14, y: 22))
            p.addLine(to: CGPoint(x: 46, y: 30))
            p.addLine(to: CGPoint(x: 14, y: 38))
            p.closeSubpath()
            svg.ctx.fill(p, with: .color(fill))
            svg.ctx.stroke(p, with: .color(color),
                           style: StrokeStyle(lineWidth: sw, lineJoin: .round))

        case "warding":
            // M10,22 L50,26 L50,34 L10,38 Z  strokeLinejoin=round
            var p = Path()
            p.move(to: CGPoint(x: 10, y: 22))
            p.addLine(to: CGPoint(x: 50, y: 26))
            p.addLine(to: CGPoint(x: 50, y: 34))
            p.addLine(to: CGPoint(x: 10, y: 38))
            p.closeSubpath()
            svg.ctx.fill(p, with: .color(fill))
            svg.ctx.stroke(p, with: .color(color),
                           style: StrokeStyle(lineWidth: sw, lineJoin: .round))

        case "crossing":
            // M12,30 A20,20 0 0,1 48,30 A28,28 0 0,1 12,30 Z
            //
            // Arc 1: from (12,30) to (48,30), r=20, largeArc=false, sweep=true
            //   SVG endpoint→center: dx=18, dy=0, d2=324, r2=400, h2=76/324
            //   sign=+1 (largeArc≠sweep) → sq≈+0.484 → cx=30, cy≈38.718
            //   clockwise=false (visual CW in iOS), sweeps ABOVE chord through y≈18.7
            //
            // Arc 2: from (48,30) to (12,30), r=28, largeArc=false, sweep=true
            //   dx=-18, dy=0, d2=324, r2=784, h2=460/324
            //   sign=+1 → sq≈+1.192 → cx=30, cy≈8.552
            //   clockwise=false, sweeps BELOW chord through y≈36.6
            var p = Path()
            p.move(to: CGPoint(x: 12, y: 30))
            // Arc 1
            p.addArc(center: CGPoint(x: 30, y: 38.718), radius: 20,
                     startAngle: .radians(atan2(30.0 - 38.718, 12.0 - 30.0)),
                     endAngle:   .radians(atan2(30.0 - 38.718, 48.0 - 30.0)),
                     clockwise: false)   // !sweep: SVG sweep=1 → UIKit clockwise=false
            // Arc 2 (continues from (48,30))
            p.addArc(center: CGPoint(x: 30, y: 8.552), radius: 28,
                     startAngle: .radians(atan2(30.0 - 8.552, 48.0 - 30.0)),
                     endAngle:   .radians(atan2(30.0 - 8.552, 12.0 - 30.0)),
                     clockwise: false)   // !sweep: SVG sweep=1 → UIKit clockwise=false
            p.closeSubpath()
            svg.path(p, fill: fill, stroke: color, width: sw)

        case "barrette":
            // path: M10,24 L50,28 L50,30 L10,34 Z  strokeLinejoin=round
            // line: x1=10 y1=24 x2=50 y2=28 stroke={st} sw=2.4 (teeth on flat face)
            var p = Path()
            p.move(to: CGPoint(x: 10, y: 24))
            p.addLine(to: CGPoint(x: 50, y: 28))
            p.addLine(to: CGPoint(x: 50, y: 30))
            p.addLine(to: CGPoint(x: 10, y: 34))
            p.closeSubpath()
            svg.ctx.fill(p, with: .color(fill))
            svg.ctx.stroke(p, with: .color(color),
                           style: StrokeStyle(lineWidth: sw, lineJoin: .round))
            // Teeth line (top/flat face)
            svg.line(10, 24, 50, 28, stroke: color, width: 2.4)

        default:
            // Fallback — same as flat
            svg.roundedRect(CGRect(x: 8, y: 20, width: 44, height: 20),
                            cornerRadius: 2, fill: fill, stroke: color, width: sw)
        }
    }
}

#Preview {
    ScrollView {
        FilesSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
