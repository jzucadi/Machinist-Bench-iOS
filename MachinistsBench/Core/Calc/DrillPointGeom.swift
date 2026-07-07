import Foundation

// MARK: - DrillPointGeom

/// Angle-dependent coordinate geometry for the drill-point diagram.
///
/// Ported from `app-new.html` §3 `DrillPointSVG` (node-verified 2026-07-06).
/// Only the coordinates that change when the user selects 60 / 90 / 118 / 135°
/// are exposed here.  Static elements (margin callout, flute callout, photo
/// seam rect, gradient defs) stay in the Phase B Canvas view.
///
/// **SVG coordinate space:** viewBox `0 0 512 512`.
///
/// Scope: Core (Foundation only, no CoreGraphics import needed — CGPoint is
/// available via Foundation on all Apple platforms in this target's SDK).
public enum DrillPointGeom: Sendable {

    // MARK: Private SVG constants (§3, DrillPointSVG)

    /// Y-coordinate where the drill body ends and the cone begins.
    private static let seamY: Double = 428
    /// Left edge of the drill body.
    private static let bodyL: Double = 234
    /// Right edge of the drill body.
    private static let bodyR: Double = 277
    /// Horizontal centre of the drill body.
    private static let cx:    Double = 255
    /// Half-width of the drill body: (bodyR − bodyL) / 2 = 21.5
    private static let halfW: Double = 21.5

    // MARK: Private helpers

    /// Cone height in SVG units, clamped to [20, 120].
    ///
    /// `coneH = clamp(halfW / tan(half), 20, 120)`
    private static func coneH(half: Double) -> Double {
        max(20, min(120, halfW / tan(half)))
    }

    // MARK: Public API

    /// Y-coordinate of the drill tip (`tipY = seamY + coneH`).
    ///
    /// This single value drives the position of every angle-dependent element
    /// in the diagram (cutting-lip lines, chisel-edge mark, arc, labels).
    /// The Phase B view calls this once and uses it for all those elements.
    ///
    /// - Parameter includedDeg: Included point angle in degrees (e.g. 60, 90, 118, 135).
    public static func liplineY(includedDeg: Double) -> Double {
        let half = includedDeg * .pi / 180 / 2
        return seamY + coneH(half: half)
    }

    /// The three vertices of the cone outline triangle.
    ///
    /// Returns `[bodyL/seamY, cx/tipY, bodyR/seamY]` — matching the SVG path
    /// `M {bodyL} {seamY} L {cx} {tipY} L {bodyR} {seamY} Z` (element 4, §3).
    ///
    /// - Parameter includedDeg: Included point angle in degrees.
    public static func outline(includedDeg: Double) -> [CGPoint] {
        let tipY = liplineY(includedDeg: includedDeg)
        return [
            CGPoint(x: bodyL, y: seamY),
            CGPoint(x: cx,    y: tipY),
            CGPoint(x: bodyR, y: seamY),
        ]
    }

    /// Left and right endpoints of the included-angle arc (element 9, §3).
    ///
    /// The arc is centred on the drill tip at radius 26, spanning the included angle:
    /// ```
    /// arcX = 26 × sin(half)
    /// arcY = 26 × cos(half)
    /// left  = (cx − arcX, tipY − arcY)
    /// right = (cx + arcX, tipY − arcY)
    /// ```
    /// Both y-coordinates are equal (the arc endpoints are at the same height).
    ///
    /// - Parameter includedDeg: Included point angle in degrees.
    public static func arcPoints(includedDeg: Double)
        -> (left: CGPoint, right: CGPoint)
    {
        let half = includedDeg * .pi / 180 / 2
        let tipY = liplineY(includedDeg: includedDeg)
        let arcX = 26 * sin(half)
        let arcY = 26 * cos(half)
        return (
            left:  CGPoint(x: cx - arcX, y: tipY - arcY),
            right: CGPoint(x: cx + arcX, y: tipY - arcY)
        )
    }
}
