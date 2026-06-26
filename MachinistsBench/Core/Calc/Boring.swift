import Foundation

public struct BoringResult: Sendable {
    public let rpm, ipm, mrr: Double
}

public func boring(diameterIn d: Double, sfm: Double, feedIPR: Double, docIn c: Double) -> BoringResult? {
    for v in [d, sfm, feedIPR, c] where v.isNaN || v <= 0 { return nil }
    let rpm = sfm * 12 / (.pi * d)
    let ipm = rpm * feedIPR
    let mrr = 12 * sfm * feedIPR * c
    return BoringResult(rpm: rpm, ipm: ipm, mrr: mrr)
}

public func boringSeed(material: Material, tool: Tool, lube: Lube, finish: Bool) -> (sfm: Int, feedIPR: Double) {
    let range = tool == .carbide ? material.boreCarbideSFM : material.boreSFM
    let lf = lubeFactor(materialID: material.id, lube: lube)

    if finish {
        // sfmFinish = round(hi(range) * 0.9 * lube)
        let sfm = Int((Double(range.upperBound) * 0.9 * lf).rounded())
        // feedFinish = feedRough * 0.55, feedRough = (carbide ? 0.004 : 0.005)
        let feedRough = tool == .carbide ? 0.004 : 0.005
        let feedIPR = feedRough * 0.55
        return (sfm, feedIPR)
    } else {
        // sfmRough = round(midpoint(b/bc range) * lube)
        let midpoint = (Double(range.lowerBound) + Double(range.upperBound)) / 2
        let sfm = Int((midpoint * lf).rounded())
        // feedRough = (carbide ? 0.004 : 0.005)
        let feedIPR = tool == .carbide ? 0.004 : 0.005
        return (sfm, feedIPR)
    }
}
