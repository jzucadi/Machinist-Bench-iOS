import Foundation

/// Input mode for polygon calculator.
public enum PolyMode {
    case af     // Across Flats
    case ac     // Across Corners
    case side   // Side Length
}

/// Complete polygon dimensions result.
public struct PolygonDims: Sendable {
    public let acrossFlats: Double
    public let acrossCorners: Double
    public let side: Double
    public let apothem: Double
    public let area: Double
    public let perimeter: Double

    public init(acrossFlats: Double, acrossCorners: Double, side: Double,
                apothem: Double, area: Double, perimeter: Double) {
        self.acrossFlats = acrossFlats
        self.acrossCorners = acrossCorners
        self.side = side
        self.apothem = apothem
        self.area = area
        self.perimeter = perimeter
    }
}

/// Calculate all polygon dimensions from one input dimension.
/// - Parameters:
///   - sides: Number of sides (N ≥ 3)
///   - mode: Which dimension is being input (af, ac, or side)
///   - value: The input value in the selected mode
/// - Returns: PolygonDims with all six dimensions
///
/// Formulas:
/// 1. Compute R (circumradius) from input:
///    - If mode = .af:   R = value / (2 * cos(π/N))
///    - If mode = .ac:   R = value / 2
///    - If mode = .side: R = value / (2 * sin(π/N))
/// 2. Derive all dimensions:
///    - acrossFlats = 2 * R * cos(π/N)
///    - acrossCorners = 2 * R
///    - side = 2 * R * sin(π/N)
///    - apothem = R * cos(π/N)
///    - area = 0.5 * N * R² * sin(2π/N)
///    - perimeter = N * side
public func polygon(sides n: Int, mode: PolyMode, value: Double) -> PolygonDims {
    let ang = Double.pi / Double(n)
    let cosAng = cos(ang)
    let sinAng = sin(ang)

    // Compute circumradius R from input mode
    let R: Double
    switch mode {
    case .af:
        R = value / (2 * cosAng)
    case .ac:
        R = value / 2
    case .side:
        R = value / (2 * sinAng)
    }

    // Derive all dimensions
    let acrossFlats = 2 * R * cosAng
    let acrossCorners = 2 * R
    let side = 2 * R * sinAng
    let apothem = R * cosAng
    let area = 0.5 * Double(n) * R * R * sin(2 * ang)
    let perimeter = Double(n) * side

    return PolygonDims(
        acrossFlats: acrossFlats,
        acrossCorners: acrossCorners,
        side: side,
        apothem: apothem,
        area: area,
        perimeter: perimeter
    )
}
