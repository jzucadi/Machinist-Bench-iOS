import SwiftUI

// MARK: - SVGAnchor

enum SVGAnchor {
    case start, middle, end
}

// MARK: - SVGContext

/// Wraps a pre-scaled GraphicsContext so callers draw in raw SVG viewBox coordinates.
struct SVGContext {
    let ctx: GraphicsContext

    // MARK: line

    func line(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat,
              stroke: Color, width: CGFloat, dash: [CGFloat]? = nil) {
        var p = Path()
        p.move(to: CGPoint(x: x1, y: y1))
        p.addLine(to: CGPoint(x: x2, y: y2))
        let style = dash.map { StrokeStyle(lineWidth: width, dash: $0) }
                    ?? StrokeStyle(lineWidth: width)
        ctx.stroke(p, with: .color(stroke), style: style)
    }

    // MARK: poly

    func poly(_ pts: [CGPoint], fill: Color? = nil, stroke: Color? = nil, width: CGFloat = 1) {
        guard pts.count >= 2 else { return }
        var p = Path()
        p.move(to: pts[0])
        for pt in pts.dropFirst() { p.addLine(to: pt) }
        p.closeSubpath()
        if let fill { ctx.fill(p, with: .color(fill)) }
        if let stroke { ctx.stroke(p, with: .color(stroke), lineWidth: width) }
    }

    // MARK: rect

    func rect(_ r: CGRect, fill: Color? = nil, stroke: Color? = nil,
              width: CGFloat = 1, opacity: Double = 1) {
        let p = Path(roundedRect: r, cornerRadius: 0)
        if let fill { ctx.fill(p, with: .color(fill.opacity(opacity))) }
        if let stroke { ctx.stroke(p, with: .color(stroke), lineWidth: width) }
    }

    // MARK: roundedRect

    func roundedRect(_ r: CGRect, cornerRadius: CGFloat, fill: Color? = nil,
                     stroke: Color? = nil, width: CGFloat = 1, opacity: Double = 1) {
        let p = Path(roundedRect: r, cornerRadius: cornerRadius)
        if let fill { ctx.fill(p, with: .color(fill.opacity(opacity))) }
        if let stroke { ctx.stroke(p, with: .color(stroke), lineWidth: width) }
    }

    // MARK: circle

    func circle(cx: CGFloat, cy: CGFloat, r: CGFloat,
                fill: Color? = nil, stroke: Color? = nil, width: CGFloat = 1) {
        let p = Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        if let fill { ctx.fill(p, with: .color(fill)) }
        if let stroke { ctx.stroke(p, with: .color(stroke), lineWidth: width) }
    }

    // MARK: path

    func path(_ p: Path, fill: Color? = nil, stroke: Color? = nil, width: CGFloat = 1) {
        if let fill { ctx.fill(p, with: .color(fill)) }
        if let stroke { ctx.stroke(p, with: .color(stroke), lineWidth: width) }
    }

    // MARK: text
    // SVG text y is the baseline. We resolve to a SwiftUI Text and draw at the baseline point.

    func text(_ s: String, x: CGFloat, y: CGFloat, size: CGFloat,
              color: Color, mono: Bool, anchor: SVGAnchor, weight: Font.Weight = .regular) {
        let font: Font = mono
            ? .system(size: size, weight: weight).monospacedDigit()
            : .system(size: size, weight: weight)
        let resolved = ctx.resolve(Text(s).font(font).foregroundStyle(color))
        // Approximate baseline offset: cap-height ≈ 0.7 × size, so ascender ≈ 0.75 × size
        let ascent: CGFloat = size * 0.75
        let w = resolved.measure(in: CGSize(width: 1000, height: 200)).width
        let anchorX: CGFloat = switch anchor {
            case .start:  x
            case .middle: x - w / 2
            case .end:    x - w
        }
        ctx.draw(resolved, at: CGPoint(x: anchorX, y: y - ascent), anchor: .topLeading)
    }

    // MARK: arrowhead

    func arrowhead(at tip: CGPoint, toward base: CGPoint, size: CGFloat, color: Color) {
        let dx = base.x - tip.x, dy = base.y - tip.y
        let len = sqrt(dx * dx + dy * dy)
        guard len > 0 else { return }
        let ux = dx / len, uy = dy / len
        let px = -uy, py = ux
        let half = size * 0.4
        let pts = [
            tip,
            CGPoint(x: tip.x + ux * size + px * half, y: tip.y + uy * size + py * half),
            CGPoint(x: tip.x + ux * size - px * half, y: tip.y + uy * size - py * half)
        ]
        poly(pts, fill: color)
    }

    // MARK: linearGradient

    func linearGradient(_ stops: [(Color, CGFloat)], in shape: Path,
                        start: CGPoint, end: CGPoint) {
        let gradient = Gradient(stops: stops.map { Gradient.Stop(color: $0.0, location: $0.1) })
        ctx.fill(shape, with: .linearGradient(gradient,
            startPoint: start, endPoint: end))
    }

    // MARK: radialGradient

    func radialGradient(_ stops: [(Color, CGFloat)], in shape: Path,
                        center: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        let gradient = Gradient(stops: stops.map { Gradient.Stop(color: $0.0, location: $0.1) })
        ctx.fill(shape, with: .radialGradient(gradient,
            center: center, startRadius: startRadius, endRadius: endRadius))
    }
}

// MARK: - SVG arc → SwiftUI Path
// Converts one SVG arc segment (circular only, phi=0) to a SwiftUI Path.
// sweep=true → SVG positive direction (clockwise in y-down space).
func svgArcPath(from start: CGPoint, to end: CGPoint,
                r: CGFloat, largeArc: Bool, sweep: Bool) -> Path {
    var p = Path()
    p.move(to: start)
    let dx = (end.x - start.x) / 2
    let dy = (end.y - start.y) / 2
    let d2 = dx * dx + dy * dy
    let r2 = r * r
    guard d2 > 0, r2 >= d2 else { p.addLine(to: end); return p }
    let h2 = max(0, (r2 - d2) / d2)
    let sign: CGFloat = (largeArc == sweep) ? -1 : 1
    let sq = sign * sqrt(h2)
    // Center (SVG endpoint-to-center parameterization, phi=0)
    let cx = sq * (-dy) + (start.x + end.x) / 2
    let cy = sq * dx + (start.y + end.y) / 2
    let startAngle = atan2(start.y - cy, start.x - cx)
    let endAngle   = atan2(end.y   - cy, end.x   - cx)
    // In y-down space (iOS/UIKit): clockwise=false is visually clockwise (SVG sweep=1)
    p.addArc(center: CGPoint(x: cx, y: cy), radius: r,
             startAngle: .radians(startAngle), endAngle: .radians(endAngle),
             clockwise: !sweep)
    return p
}

// MARK: - DiagramCanvas

struct DiagramCanvas: View {
    let viewBox: CGRect
    var maxWidth: CGFloat? = nil
    let draw: (SVGContext) -> Void

    var body: some View {
        Canvas { ctx, size in
            let scale = size.width / viewBox.width
            ctx.translateBy(x: -viewBox.minX * scale, y: -viewBox.minY * scale)
            ctx.scaleBy(x: scale, y: scale)
            draw(SVGContext(ctx: ctx))
        }
        .aspectRatio(viewBox.width / viewBox.height, contentMode: .fit)
        .frame(maxWidth: maxWidth)
    }
}
