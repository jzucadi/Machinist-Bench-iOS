import Foundation

/// Hardness scale selector for input to hardnessConvert.
public enum HScale: Sendable {
    case hrc
    case hrb
    case brinell
    case vickers
}

/// Result of a hardness conversion.
/// Any output that cannot be interpolated (out of range or column has no data
/// bracketing the requested HV) is returned as nil.
public struct HardnessResult: Sendable {
    public let hv:    Double?
    public let hb:    Double?
    public let hrc:   Double?
    public let hrb:   Double?
    public let utsKsi: Double?
}

/// Convert a hardness value from one scale to all others via linear interpolation
/// through the HARD table, using Vickers (HV) as the pivot column.
///
/// - Parameters:
///   - scale: The scale of the input value.
///   - value: The input hardness value.
/// - Returns: A `HardnessResult` with all available conversions (nil where out of range).
public func hardnessConvert(scale: HScale, value: Double) -> HardnessResult {
    let rows = HardnessTable.rows

    // Map scale to column index:  hv=0, hb=1, hrc=2, hrb=3
    let inputCol = colIndex(scale)

    // Step 1: convert input value → HV
    guard let hvPivot = hvFrom(colIndex: inputCol, value: value, rows: rows) else {
        // Out of range — return all nils
        return HardnessResult(hv: nil, hb: nil, hrc: nil, hrb: nil, utsKsi: nil)
    }

    // Step 2: interpolate every output column at hvPivot
    // HV output is hvPivot itself (col 0 is exact by construction)
    let hvOut  = hvPivot
    let hbOut  = atHv(hv: hvPivot, colIndex: 1, rows: rows)
    let hrcOut = atHv(hv: hvPivot, colIndex: 2, rows: rows)
    let hrbOut = atHv(hv: hvPivot, colIndex: 3, rows: rows)

    // UTS (ksi) ≈ HB / 2 (classic "500×HB psi" rule)
    let utsOut: Double? = hbOut.map { $0 / 2.0 }

    return HardnessResult(hv: hvOut, hb: hbOut, hrc: hrcOut, hrb: hrbOut, utsKsi: utsOut)
}

// MARK: - Private helpers

private func colIndex(_ scale: HScale) -> Int {
    switch scale {
    case .vickers: return 0
    case .brinell: return 1
    case .hrc:     return 2
    case .hrb:     return 3
    }
}

/// Return the value from a given column at `rowIndex` of the table.
private func colValue(_ colIndex: Int, _ row: (hv: Double, hb: Double?, hrc: Double?, hrb: Double?)) -> Double? {
    switch colIndex {
    case 0: return row.hv
    case 1: return row.hb
    case 2: return row.hrc
    case 3: return row.hrb
    default: return nil
    }
}

/// Convert a value in the given column to a Vickers (HV) equivalent via linear interpolation.
/// The table runs high→low HV, so column values also run high→low (for HRC, HB) or low→high (HRB).
/// We search for adjacent non-nil rows that bracket `value` in the chosen column.
///
/// Returns nil if `value` is out of the range covered by non-nil entries in that column.
private func hvFrom(colIndex: Int, value: Double, rows: [(hv: Double, hb: Double?, hrc: Double?, hrb: Double?)]) -> Double? {
    // For vickers, no interpolation needed — just check in-range and return value directly
    if colIndex == 0 {
        let hvValues = rows.map { $0.hv }
        guard let maxHV = hvValues.max(), let minHV = hvValues.min() else { return nil }
        if value < minHV || value > maxHV { return nil }
        // Interpolate HV→HV (same table, just find bracket)
        return atHv(hv: value, colIndex: 0, rows: rows) ?? value
    }

    // Build list of (colVal, hvVal) pairs where column is non-nil
    var pairs: [(colVal: Double, hv: Double)] = []
    for row in rows {
        if let cv = colValue(colIndex, row) {
            pairs.append((colVal: cv, hv: row.hv))
        }
    }
    guard pairs.count >= 2 else { return nil }

    // Determine sort direction: pairs are in same order as rows (high→low HV).
    // Column values may be monotone increasing or decreasing depending on scale.
    // We need to find the two adjacent pairs that bracket `value`.
    for i in 0..<(pairs.count - 1) {
        let hi = pairs[i]
        let lo = pairs[i + 1]
        // Check if value falls between hi.colVal and lo.colVal (in either direction)
        let minVal = min(hi.colVal, lo.colVal)
        let maxVal = max(hi.colVal, lo.colVal)
        guard value >= minVal && value <= maxVal else { continue }

        // Interpolate: t = (value - hi.colVal) / (lo.colVal - hi.colVal)
        let denom = lo.colVal - hi.colVal
        if denom == 0 {
            return hi.hv
        }
        let t = (value - hi.colVal) / denom
        return hi.hv + t * (lo.hv - hi.hv)
    }

    return nil  // out of range
}

/// Given a HV value, interpolate the output in column `colIndex`.
/// Searches the table for two adjacent rows where HV brackets `hv`,
/// using only rows where the target column is non-nil.
private func atHv(hv: Double, colIndex: Int, rows: [(hv: Double, hb: Double?, hrc: Double?, hrb: Double?)]) -> Double? {
    // Build pairs of (hvRow, colVal) for rows where column is non-nil
    var pairs: [(hvRow: Double, colVal: Double)] = []
    for row in rows {
        if let cv = colValue(colIndex, row) {
            pairs.append((hvRow: row.hv, colVal: cv))
        }
    }
    guard pairs.count >= 2 else { return nil }

    // Table runs high→low HV; pairs are in same order
    // Find bracket: pairs[i].hvRow >= hv >= pairs[i+1].hvRow
    for i in 0..<(pairs.count - 1) {
        let hi = pairs[i]
        let lo = pairs[i + 1]
        let minHV = min(hi.hvRow, lo.hvRow)
        let maxHV = max(hi.hvRow, lo.hvRow)
        guard hv >= minHV && hv <= maxHV else { continue }

        let denom = lo.hvRow - hi.hvRow
        if denom == 0 {
            return hi.colVal
        }
        let t = (hv - hi.hvRow) / denom
        return hi.colVal + t * (lo.colVal - hi.colVal)
    }

    return nil  // out of range for this column
}
