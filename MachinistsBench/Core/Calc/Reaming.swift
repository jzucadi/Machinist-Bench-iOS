import Foundation

public struct ReamingResult: Sendable {
    public let rpm, ipm, stock, preDrill, lowLimit, highLimit: Double
}

public func reaming(diameterIn: Double, sfm: Double, feedIPR: Double) -> ReamingResult? {
    for v in [diameterIn, sfm, feedIPR] where v.isNaN || v <= 0 { return nil }

    // Calculate RPM: sfm * 12 / (π * D)
    let rpm = sfm * 12 / (.pi * diameterIn)

    // Calculate IPM: RPM * feed
    let ipm = rpm * feedIPR

    // Stock to leave based on diameter
    let stock: Double
    if diameterIn < 0.25 {
        stock = 0.005
    } else if diameterIn < 0.50 {
        stock = 0.010
    } else if diameterIn < 1.00 {
        stock = 0.015
    } else {
        stock = 0.020
    }

    // Pre-drill diameter
    let preDrill = diameterIn - stock

    // Tolerance based on diameter
    let tol: Double
    if diameterIn < 0.50 {
        tol = 0.0005
    } else if diameterIn < 1.00 {
        tol = 0.0008
    } else {
        tol = 0.001
    }

    // Limits
    let lowLimit = diameterIn
    let highLimit = diameterIn + tol

    return ReamingResult(rpm: rpm, ipm: ipm, stock: stock, preDrill: preDrill, lowLimit: lowLimit, highLimit: highLimit)
}
