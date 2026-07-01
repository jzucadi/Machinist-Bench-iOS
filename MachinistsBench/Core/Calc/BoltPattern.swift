import Foundation

public struct Hole: Sendable {
    public let n: Int
    public let x, y: Double
    public let angle: Double

    public init(n: Int, x: Double, y: Double, angle: Double) {
        self.n = n
        self.x = x
        self.y = y
        self.angle = angle
    }
}

/// Calculate holes on a bolt circle.
/// - Parameters:
///   - count: Number of holes
///   - bcdIn: Bolt circle diameter
///   - centerX: X coordinate of circle center
///   - centerY: Y coordinate of circle center
///   - startDeg: Starting angle in degrees
/// - Returns: Array of Hole positions. For hole i: angle = startDeg + i*360/count (degrees),
///            x = centerX + r*cos(angle), y = centerY + r*sin(angle), where r = bcdIn/2
public func boltCircle(count: Int, bcdIn: Double, centerX: Double, centerY: Double, startDeg: Double) -> [Hole] {
    let r = bcdIn / 2
    var holes: [Hole] = []

    for i in 0..<count {
        let angleDeg = startDeg + Double(i) * 360.0 / Double(count)
        let angleRad = angleDeg * .pi / 180.0
        let x = centerX + r * cos(angleRad)
        let y = centerY + r * sin(angleRad)
        holes.append(Hole(n: i, x: x, y: y, angle: angleDeg))
    }

    return holes
}

/// Calculate the chord distance between adjacent holes on a bolt circle.
/// - Parameters:
///   - count: Number of holes
///   - bcdIn: Bolt circle diameter
/// - Returns: Chord distance = 2*r*sin(π/count), where r = bcdIn/2
public func boltCircleChord(count: Int, bcdIn: Double) -> Double {
    let r = bcdIn / 2
    return 2 * r * sin(.pi / Double(count))
}

/// Calculate holes on a straight line.
/// - Parameters:
///   - count: Number of holes
///   - pitchIn: Distance between holes
///   - angleDeg: Angle of the line in degrees from horizontal
///   - x0: X coordinate of first hole
///   - y0: Y coordinate of first hole
/// - Returns: Array of Hole positions. For hole i: x = x0 + i*pitch*cos(angleDeg),
///            y = y0 + i*pitch*sin(angleDeg). Angle field is unused (set to 0).
public func straightLineHoles(count: Int, pitchIn: Double, angleDeg: Double, x0: Double, y0: Double) -> [Hole] {
    let angleRad = angleDeg * .pi / 180.0
    let cosAngle = cos(angleRad)
    let sinAngle = sin(angleRad)
    var holes: [Hole] = []

    for i in 0..<count {
        let x = x0 + Double(i) * pitchIn * cosAngle
        let y = y0 + Double(i) * pitchIn * sinAngle
        holes.append(Hole(n: i, x: x, y: y, angle: 0))
    }

    return holes
}
