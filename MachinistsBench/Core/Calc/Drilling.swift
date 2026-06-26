import Foundation

public struct DrillingResult: Sendable {
    public let rpm, ipm, mrr, cutHP, motorHP: Double
}

public func drilling(diameterIn: Double, sfm: Double, feedIPR: Double, efficiency: Double, kp: Double) -> DrillingResult? {
    let eff = efficiency > 0 ? efficiency : 0.8
    for v in [diameterIn, sfm, feedIPR] where v.isNaN || v <= 0 { return nil }

    let rpm = sfm * 12 / (.pi * diameterIn)
    let ipm = rpm * feedIPR
    let mrr = (.pi / 4) * diameterIn * diameterIn * ipm
    let cutHP = kp * mrr
    return DrillingResult(rpm: rpm, ipm: ipm, mrr: mrr, cutHP: cutHP, motorHP: cutHP / eff)
}

public func recommendedDrillSFM(material: Material, tool: Tool, coating: Coating, lube: Lube) -> ClosedRange<Int> {
    let range = tool == .hss ? material.drillSFM : material.drillCarbideSFM
    let lf = lubeFactor(materialID: material.id, lube: lube)
    let cf = coatFactor(tool: tool, coating: coating)
    let lo = Int((Double(range.lowerBound) * lf * cf).rounded())
    let hi = Int((Double(range.upperBound) * lf * cf).rounded())
    return lo...hi
}
