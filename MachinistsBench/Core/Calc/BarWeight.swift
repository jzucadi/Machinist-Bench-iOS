import Foundation

/// Bar cross-sectional shapes
public enum BarShape {
    case round
    case tube
    case square
    case hex
    case rect
}

/// Result of bar weight calculation
public struct BarResult: Sendable {
    /// Cross-sectional area in square inches
    public let areaSqIn: Double
    /// Volume in cubic inches
    public let volCuIn: Double
    /// Weight in pounds
    public let pounds: Double
    /// Weight in kilograms
    public let kg: Double
    /// Weight per foot in pounds per foot
    public let perFootLb: Double
    /// Weight per meter in kilograms per meter
    public let perMeterKg: Double

    public init(areaSqIn: Double, volCuIn: Double, pounds: Double, kg: Double, perFootLb: Double, perMeterKg: Double) {
        self.areaSqIn = areaSqIn
        self.volCuIn = volCuIn
        self.pounds = pounds
        self.kg = kg
        self.perFootLb = perFootLb
        self.perMeterKg = perMeterKg
    }
}

/// Calculate bar weight given shape, material, dimensions, and length.
///
/// - Parameters:
///   - shape: The cross-sectional shape (round, tube, square, hex, rect)
///   - materialKey: Material identifier (must exist in ShopMathData.barDensity)
///   - d1In: Diameter (round), OD (tube), width (square/hex/rect), in inches
///   - d2In: Height (rect only), ignored for other shapes
///   - wallIn: Wall thickness (tube only), ignored for other shapes
///   - lengthIn: Length of the bar in inches
///
/// - Returns: BarResult with calculated area, volume, weight, and per-foot weight, or nil if material not found
public func barWeight(
    shape: BarShape,
    materialKey: String,
    d1In: Double,
    d2In: Double,
    wallIn: Double,
    lengthIn: Double
) -> BarResult? {
    // Look up material density
    guard let density = ShopMathData.barDensity[materialKey] else {
        return nil
    }

    // Calculate cross-sectional area based on shape
    let area: Double
    switch shape {
    case .round:
        // area = (π/4) * D²
        area = (Double.pi / 4.0) * (d1In * d1In)

    case .square:
        // area = D²
        area = d1In * d1In

    case .hex:
        // area = 0.866025 * AF²
        area = 0.866025 * (d1In * d1In)

    case .tube:
        // ID = OD - 2*wall
        // area = (π/4) * (OD² - ID²)
        let id = d1In - 2.0 * wallIn
        area = (Double.pi / 4.0) * (d1In * d1In - id * id)

    case .rect:
        // area = width * height
        area = d1In * d2In
    }

    // Calculate volume and weights
    let vol = area * lengthIn
    let lb = vol * density
    let kgVal = lb * 0.453592
    let perFoot = area * 12.0 * density
    let perMeter = perFoot * 1.48816  // lb/ft → kg/m, same constant as the web source

    return BarResult(
        areaSqIn: area,
        volCuIn: vol,
        pounds: lb,
        kg: kgVal,
        perFootLb: perFoot,
        perMeterKg: perMeter
    )
}
