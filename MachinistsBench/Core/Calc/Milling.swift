import Foundation

public struct MillingResult: Sendable {
    public let rpm: Double
    public let ipm: Double
    public let mrr: Double
    public let cutHP: Double
    public let motorHP: Double
    public let deff: Double
    public let ctf: Double
    public let fzProg: Double
}

/// Milling speeds, feeds, MRR, and power with chip-thinning compensation.
/// Cutting forces and tool deflection are deferred.
public func milling(
    diameterIn D: Double,
    cornerRIn cornerR: Double,
    sfm: Double,
    chipLoad: Double,
    flutes: Int,
    adocIn adoc: Double,
    rdocIn rdoc: Double,
    leadDeg: Double,
    efficiency: Double,
    kp: Double
) -> MillingResult? {
    let eff = efficiency > 0 ? efficiency : 0.8
    guard D > 0, sfm > 0, chipLoad > 0, flutes > 0 else { return nil }

    // Effective diameter (bull-nose / corner-radius compensation)
    let deff: Double
    if cornerR > 0 && adoc < cornerR {
        deff = D - 2 * cornerR + 2 * sqrt(adoc * (2 * cornerR - adoc))
    } else {
        deff = D
    }

    let rpm = sfm * 12 / (.pi * deff)

    // Radial chip-thinning
    let aeR = min(rdoc, deff)
    let rctf: Double
    if aeR < deff / 2 {
        rctf = deff / (2 * sqrt(aeR * (deff - aeR)))
    } else {
        rctf = 1.0
    }

    // Lead-angle factor
    let laf: Double = (leadDeg > 0 && leadDeg < 90) ? 1 / sin(leadDeg * .pi / 180) : 1

    let ctf = rctf * laf
    let fzProg = chipLoad * ctf
    let ipm = rpm * fzProg * Double(flutes)
    let mrr = ipm * adoc * rdoc
    let cutHP = kp * mrr
    let motorHP = cutHP / eff

    return MillingResult(rpm: rpm, ipm: ipm, mrr: mrr, cutHP: cutHP,
                         motorHP: motorHP, deff: deff, ctf: ctf, fzProg: fzProg)
}

public func recommendedMillSFM(material: Material, tool: Tool, coating: Coating, lube: Lube) -> ClosedRange<Int> {
    let range = tool == .hss ? material.millSFM : material.millCarbideSFM
    let lf = lubeFactor(materialID: material.id, lube: lube)
    let cf = coatFactor(tool: tool, coating: coating)
    let lo = Int((Double(range.lowerBound) * lf * cf).rounded())
    let hi = Int((Double(range.upperBound) * lf * cf).rounded())
    return lo...hi
}
