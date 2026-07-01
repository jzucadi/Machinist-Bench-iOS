import Foundation

/// Complete right triangle solution result.
/// - a: leg opposite angle X (vertical)
/// - b: leg opposite angle Y (horizontal)
/// - h: hypotenuse
/// - angleX: angle at the b–h corner (degrees)
/// - angleY: angle at the a–h corner = 90 − angleX (degrees)
/// - area: 0.5 × a × b
/// - perimeter: a + b + h
public struct TriResult: Sendable {
    public let a: Double
    public let b: Double
    public let h: Double
    public let angleX: Double
    public let angleY: Double
    public let area: Double
    public let perimeter: Double

    public init(a: Double, b: Double, h: Double,
                angleX: Double, angleY: Double,
                area: Double, perimeter: Double) {
        self.a = a
        self.b = b
        self.h = h
        self.angleX = angleX
        self.angleY = angleY
        self.area = area
        self.perimeter = perimeter
    }
}

/// Solve a right triangle given any ≥2 knowns from {a, b, h, angleXDeg, angleYDeg}.
///
/// Naming convention (matches web app Tool 4):
/// - a = leg opposite angle X (vertical leg)
/// - b = leg adjacent to angle X (horizontal leg)
/// - h = hypotenuse
/// - X = angle at the b–h corner (degrees)
/// - Y = 90 − X (degrees)
///
/// Branch cases:
/// **Two sides:**
/// - a & b → H = √(a²+b²)
/// - a & h → B = √(h²−a²)
/// - b & h → A = √(h²−b²)
/// - Then angX = atan2(A,B)×(180/π), angY = 90−angX
///
/// **One side + one angle (resolve X from X or Y):**
/// - a given → H = a/sin(X°), B = a/tan(X°)
/// - b given → H = b/cos(X°), A = b×tan(X°)
/// - h given → A = h×sin(X°), B = h×cos(X°)
///
/// Returns nil if fewer than 2 independent knowns are provided or if the
/// combination is geometrically invalid (e.g. imaginary square root).
public func solveRightTriangle(
    a: Double? = nil,
    b: Double? = nil,
    h: Double? = nil,
    angleXDeg: Double? = nil,
    angleYDeg: Double? = nil
) -> TriResult? {

    // Resolve the working angle X in degrees.
    // Either angleXDeg directly, or 90 − angleYDeg.
    var xDeg: Double? = angleXDeg
    if xDeg == nil, let y = angleYDeg {
        xDeg = 90.0 - y
    }

    // Count how many independent knowns we have.
    let sideCount = [a, b, h].compactMap { $0 }.count
    let hasAngle = xDeg != nil

    // Need ≥2 knowns: two sides, or one side + one angle.
    // An angle alone (or two angles, which collapse to one) is never enough.
    if sideCount == 0 { return nil }
    if sideCount == 1 && !hasAngle { return nil }

    // Variables to resolve
    var A: Double
    var B: Double
    var H: Double
    var angX: Double
    var angY: Double

    if sideCount >= 2 {
        // --- Two-sides branch ---
        if let av = a, let bv = b {
            // a & b known
            A = av
            B = bv
            H = (av * av + bv * bv).squareRoot()
        } else if let av = a, let hv = h {
            // a & h known
            let sq = hv * hv - av * av
            guard sq >= 0 else { return nil }
            A = av
            B = sq.squareRoot()
            H = hv
        } else if let bv = b, let hv = h {
            // b & h known
            let sq = hv * hv - bv * bv
            guard sq >= 0 else { return nil }
            B = bv
            A = sq.squareRoot()
            H = hv
        } else {
            return nil
        }
        angX = atan2(A, B) * (180.0 / Double.pi)
        angY = 90.0 - angX

    } else {
        // --- One side + angle branch ---
        guard let xd = xDeg else { return nil }
        // Validate angle range (must be strictly between 0 and 90)
        guard xd > 0 && xd < 90 else { return nil }

        let xRad = xd * Double.pi / 180.0

        if let av = a {
            // a known
            H = av / sin(xRad)
            B = av / tan(xRad)
            A = av
        } else if let bv = b {
            // b known
            H = bv / cos(xRad)
            A = bv * tan(xRad)
            B = bv
        } else if let hv = h {
            // h known
            A = hv * sin(xRad)
            B = hv * cos(xRad)
            H = hv
        } else {
            return nil
        }

        angX = xd
        angY = 90.0 - xd
    }

    let area = 0.5 * A * B
    let perimeter = A + B + H

    return TriResult(
        a: A,
        b: B,
        h: H,
        angleX: angX,
        angleY: angY,
        area: area,
        perimeter: perimeter
    )
}
