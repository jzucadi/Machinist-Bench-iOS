import Foundation

/// Finds the minimum combination of standard gauge blocks to build a target dimension.
///
/// Ports the digit-elimination greedy algorithm from app.html (`gbStack` / `gbStackMM`).
///
/// - Parameters:
///   - targetIn: The target dimension. When `metric` is `false`, this is in inches.
///               When `metric` is `true`, this is in **millimetres** (mirrors the JS
///               `GaugeStack` component where `val` is already in mm and passed
///               directly to `gbStackMM(t)`).
///   - metric: `false` → use the 81-piece inch set; `true` → use the 88-piece metric set.
/// - Returns: The list of block values (in the same unit as the target), sorted
///   smallest-to-largest, or `nil` if the target cannot be built from the set.
public func gaugeStack(targetIn: Double, metric: Bool) -> [Double]? {
    if metric {
        return gbStackMM(target: targetIn)
    } else {
        return gbStack(target: targetIn)
    }
}

// MARK: - Inch algorithm (ports gbStack from app.html)

private func gbStack(target: Double) -> [Double]? {
    let T = Int(exactly: (target * 1e4).rounded()) ?? Int((target * 1e4).rounded())
    guard T > 0 else { return nil }

    let setI = GaugeBlocks.inchSet.map { Int(($0 * 1e4).rounded()) }

    // Exact match
    if setI.contains(T) {
        return [Double(T) / 1e4]
    }

    // Below minimum (0.050" = 500 ten-thousandths)
    guard T >= 500 else { return nil }

    var used: [Int] = []
    var rem = T

    // Step 1: clear last decimal place (ten-thousandths wear block)
    let d4 = rem % 10
    if d4 != 0 {
        let b = 1000 + d4
        guard b <= rem else { return nil }
        used.append(b)
        rem -= b
    }

    // Step 2: clear thousandths digit
    let k = (rem / 10) % 50
    if k != 0 {
        let b = 1000 + 10 * k
        guard b <= rem else { return nil }
        used.append(b)
        rem -= b
    }

    // Step 3: fill inch blocks (4", 3", 2", 1" in descending order)
    for inch in [40000, 30000, 20000, 10000] {
        if rem >= inch {
            used.append(inch)
            rem -= inch
        }
    }

    // Step 4: remainder from fifty-step blocks (0.050–0.950")
    guard rem <= 9500 else { return nil }
    if rem > 0 {
        used.append(rem)
    }

    used.sort()
    return used.map { Double($0) / 1e4 }
}

// MARK: - Metric algorithm (ports gbStackMM from app.html)

private func gbStackMM(target: Double) -> [Double]? {
    let T = Int(exactly: (target * 1e4).rounded()) ?? Int((target * 1e4).rounded())
    guard T > 0 else { return nil }

    let setI = GaugeBlocks.metricSet.map { Int(($0 * 1e4).rounded()) }

    // Exact match
    if setI.contains(T) {
        return [Double(T) / 1e4]
    }

    // Must be on a 0.0005 mm (5 μm) increment
    guard T % 5 == 0 else { return nil }
    // Below minimum 0.5 mm = 5000 ten-thousandths
    guard T >= 5000 else { return nil }

    var used: [Int] = []
    var rem = T

    // Step 1: half-micron block (1.0005 mm) if needed
    if rem % 10 == 5 {
        let b = 10005
        guard b <= rem else { return nil }
        used.append(b)
        rem -= b
    }

    // Step 2: clear 0.001 mm digit
    let d = (rem / 10) % 10
    if d != 0 {
        let b = 10000 + 10 * d
        guard b <= rem else { return nil }
        used.append(b)
        rem -= b
    }

    // Step 3: clear 0.01 mm digit
    let k = (rem / 100) % 50
    if k != 0 {
        let b = 10000 + 100 * k
        guard b <= rem else { return nil }
        used.append(b)
        rem -= b
    }

    // Step 4: fill 10 mm blocks (100, 90, 80, … 10 mm) in descending order
    for ten in [1000000, 900000, 800000, 700000, 600000, 500000, 400000, 300000, 200000, 100000] {
        if rem >= ten {
            used.append(ten)
            rem -= ten
        }
    }

    // Step 5: remainder from 0.5 mm step blocks (0.5–9.5 mm)
    guard rem <= 95000 else { return nil }
    if rem > 0 {
        used.append(rem)
    }

    used.sort()
    return used.map { Double($0) / 1e4 }
}
