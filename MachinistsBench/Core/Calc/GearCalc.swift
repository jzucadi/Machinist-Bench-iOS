import Foundation

/// Complete gear calculation result.
public struct GearResult: Sendable {
    public let ratio: Double
    public let rpmOut: Double
    public let centerDistance: Double
    public let pdDriver: Double
    public let pdDriven: Double
    public let odDriver: Double
    public let odDriven: Double

    public init(ratio: Double, rpmOut: Double, centerDistance: Double,
                pdDriver: Double, pdDriven: Double, odDriver: Double, odDriven: Double) {
        self.ratio = ratio
        self.rpmOut = rpmOut
        self.centerDistance = centerDistance
        self.pdDriver = pdDriver
        self.pdDriven = pdDriven
        self.odDriver = odDriver
        self.odDriven = odDriven
    }
}

/// Calculate gear ratio and geometry.
/// - Parameters:
///   - driveT: Number of teeth on driver gear (must be > 0)
///   - drivenT: Number of teeth on driven gear (must be > 0)
///   - rpmIn: Input speed in RPM
///   - dp: Diametral pitch in teeth/inch (must be > 0)
/// - Returns: GearResult with all calculated values, or nil if any of driveT, drivenT, or dp ≤ 0
///
/// Formulas:
/// - ratio = drivenT / driveT
/// - rpmOut = rpmIn × driveT / drivenT
/// - pdDriver = driveT / DP
/// - pdDriven = drivenT / DP
/// - odDriver = (driveT + 2) / DP
/// - odDriven = (drivenT + 2) / DP
/// - centerDistance = (driveT + drivenT) / (2 × DP)
public func gearCalc(driveT: Int, drivenT: Int, rpmIn: Double, dp: Double) -> GearResult? {
    guard driveT > 0, drivenT > 0, dp > 0 else {
        return nil
    }

    let driveTDouble = Double(driveT)
    let drivenTDouble = Double(drivenT)

    let ratio = drivenTDouble / driveTDouble
    let rpmOut = rpmIn * driveTDouble / drivenTDouble
    let pdDriver = driveTDouble / dp
    let pdDriven = drivenTDouble / dp
    let odDriver = (driveTDouble + 2) / dp
    let odDriven = (drivenTDouble + 2) / dp
    let centerDistance = (driveTDouble + drivenTDouble) / (2 * dp)

    return GearResult(
        ratio: ratio,
        rpmOut: rpmOut,
        centerDistance: centerDistance,
        pdDriver: pdDriver,
        pdDriven: pdDriven,
        odDriver: odDriver,
        odDriven: odDriven
    )
}
