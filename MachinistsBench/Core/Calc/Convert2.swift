import Foundation

// MARK: - Unit conversion

/// Convert a value between two units in the given category.
/// Returns nil if either key is not found in the category.
/// For factor-based categories: result = value * fromFactor / toFactor.
/// For temperature: normalizes to °C, then converts to target.
public func convert(
    category: ConvCategory,
    fromKey: String,
    toKey: String,
    value: Double
) -> Double? {
    if category.isTemperature {
        return convertTemperature(fromKey: fromKey, toKey: toKey, value: value)
    }
    guard let fromUnit = category.units.first(where: { $0.key == fromKey }),
          let toUnit   = category.units.first(where: { $0.key == toKey }) else {
        return nil
    }
    return value * fromUnit.factor / toUnit.factor
}

// MARK: - Temperature helper

private func convertTemperature(fromKey: String, toKey: String, value: Double) -> Double? {
    // Normalize to °C
    let celsius: Double
    switch fromKey {
    case "C": celsius = value
    case "F": celsius = (value - 32) * 5 / 9
    case "K": celsius = value - 273.15
    default:  return nil
    }
    // Convert from °C to target
    switch toKey {
    case "C": return celsius
    case "F": return celsius * 9 / 5 + 32
    case "K": return celsius + 273.15
    default:  return nil
    }
}

// MARK: - Formatter

/// Format a converted value for display.
/// Special cases: "thou" and "µm" keys always use 2 decimal places.
/// Otherwise:
///   |v| >= 1e7 or (v != 0 and |v| < 1e-4) → scientific notation (4 sig figs after decimal)
///   |v| >= 1000                             → fixed 3 decimal places
///   else                                    → fixed 6 decimal places
/// Trailing zeros (and trailing ".") are stripped in all fixed cases.
public func fmtConv(_ v: Double, unitKey: String) -> String {
    // Special 2dp keys
    if unitKey == "thou" || unitKey == "µm" {
        return String(format: "%.2f", v)
    }

    let a = abs(v)
    if a != 0 && (a >= 1e7 || a < 1e-4) {
        // Scientific notation — Swift uses "e+" format; JS uses lowercase "e+"
        // toExponential(4) in JS means 4 digits after the decimal.
        // Swift's %e uses 6 digits after decimal by default.
        // Match JS: format like "1.6093e+7"
        return formatScientific(v)
    }
    let decimals = a >= 1000 ? 3 : 6
    let formatted = String(format: "%.\(decimals)f", v)
    return stripTrailingZeros(formatted)
}

// MARK: - Private helpers

/// Format a Double in scientific notation matching JS's `.toExponential(4)`.
/// JS toExponential(4) → "1.6093e+7" (mantissa with 4 decimal places, minimal exponent digits).
private func formatScientific(_ v: Double) -> String {
    // Use %e which gives 6 decimal places, then trim mantissa to 4dp
    let raw = String(format: "%.4e", v)   // e.g. "1.6093e+07"
    // Normalise exponent: strip leading zeros after 'e+' or 'e-'
    // "1.6093e+07" → "1.6093e+7"
    return normaliseExponent(raw)
}

private func normaliseExponent(_ s: String) -> String {
    guard let eIdx = s.firstIndex(of: "e") else { return s }
    let mantissa = s[s.startIndex..<eIdx]
    let expPart  = s[eIdx...]                 // "e+07" or "e-07"

    guard expPart.count >= 2 else { return s }
    let signIdx  = expPart.index(after: expPart.startIndex)
    let sign     = expPart[signIdx]          // '+' or '-'
    let digits   = expPart[expPart.index(after: signIdx)...]
    // Strip leading zeros from exponent
    let stripped = String(digits.drop(while: { $0 == "0" }))
    let expNum   = stripped.isEmpty ? "0" : stripped
    return "\(mantissa)e\(sign)\(expNum)"
}

private func stripTrailingZeros(_ s: String) -> String {
    guard s.contains(".") else { return s }
    var result = s
    while result.hasSuffix("0") { result.removeLast() }
    if result.hasSuffix(".") { result.removeLast() }
    return result
}
