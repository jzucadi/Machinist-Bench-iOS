import Foundation

// MARK: - MicParts

/// The three additive components of a micrometer reading, plus the total.
///
/// Invariant: `Double(major) * 0.1 + Double(minor) * 0.025 + thimble == total`
///
/// - `major`   — count of 0.100″ marks visible to the left of the thimble edge (0–9)
/// - `minor`   — count of additional 0.025″ ticks between the last major mark and the thimble edge (0–3)
/// - `thimble` — thousandths contribution from the thimble scale (0.000–0.024 inches)
/// - `total`   — reading rounded to the nearest 0.001″ (= major×0.1 + minor×0.025 + thimble)
public struct MicParts: Sendable {
    public let major:   Int     // 0.100″ marks visible
    public let minor:   Int     // extra 0.025″ ticks (0–3)
    public let thimble: Double  // thousandths contribution in inches (0.000–0.024)
    public let total:   Double  // snapped reading in inches

    public init(major: Int, minor: Int, thimble: Double, total: Double) {
        self.major   = major
        self.minor   = minor
        self.thimble = thimble
        self.total   = total
    }
}

// MARK: - MicReading

/// Reading-decomposition math for an analog inch micrometer.
///
/// Ported verbatim from `app-new.html` §4.1 reading algorithm (node-verified 2026-07-06).
public enum MicReading {

    /// Decompose a micrometer slider value into its sleeve + thimble components.
    ///
    /// Algorithm (direct port from §4.1 JS):
    /// ```
    /// snap     = round(val × 1000) / 1000          // nearest thou
    /// sleeve25 = floor(snap / 0.025 + ε)           // count of 0.025″ ticks
    /// major    = sleeve25 / 4                       // count of 0.100″ marks
    /// minor    = sleeve25 % 4                       // residual 0.025″ ticks
    /// thimble  = round((snap − sleeve25×0.025) × 1000) × 0.001
    /// ```
    public static func decompose(_ value: Double) -> MicParts {
        let snap     = (value * 1e3).rounded() / 1e3
        let sleeve25 = Int(snap / 0.025 + 1e-9)   // epsilon guards against float rounding
        let major    = sleeve25 / 4
        let minor    = sleeve25 % 4
        let thimble  = ((snap - Double(sleeve25) * 0.025) * 1e3).rounded() * 0.001
        return MicParts(major: major, minor: minor, thimble: thimble, total: snap)
    }

    /// Return the vernier ten-thousandths digit (0–9) for a value measured to 0.0001″.
    ///
    /// A vernier micrometer's 10-line sleeve scale reads the fourth decimal place.
    /// For example: `vernierTenths(0.2763)` → `3` (add 0.0003″).
    public static func vernierTenths(_ value: Double) -> Int {
        return Int((value * 10_000).rounded()) % 10
    }
}
