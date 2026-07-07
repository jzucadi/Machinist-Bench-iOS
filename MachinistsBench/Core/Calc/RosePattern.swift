// RosePattern.swift — Rose engine pattern generator
// Source: m7-extraction.md §8b (paths useMemo, ROSE_WAVES, readout formulas)
// Math ported verbatim from app-new.html lines 6375–6425.
// Core = Foundation only, public, Sendable. CGPoint via Foundation on Apple platforms.

import Foundation

// MARK: - RoseWave

/// Rosette waveform shapes.
/// Enum cases and display names verbatim from §8b ROSE_WAVES:
///   sine, puffy ("point" JS key → pointed), scallop.
/// Raw values match the JS object keys except "pointed" (JS: "point") — adjustment
/// required because `point` is an ambiguous identifier in Swift contexts; the brief
/// mandates the case be named `.pointed`.
public enum RoseWave: String, CaseIterable, Sendable {
    case sine
    case puffy
    case pointed
    case scallop

    /// Display name for the segmented control (verbatim from §8b ROSE_WAVES .name fields).
    public var displayName: String {
        switch self {
        case .sine:    return "Sine"
        case .puffy:   return "Puffy"
        case .pointed: return "Pointed"
        case .scallop: return "Scallop"
        }
    }

    /// Waveform function — exact JS function bodies from §8b ROSE_WAVES.
    /// Accepts angle in radians; returns value in the range [−1, 1].
    func f(_ x: Double) -> Double {
        switch self {
        case .sine:
            // f: (x) => Math.sin(x)
            return sin(x)

        case .puffy:
            // f: (x) => Math.tanh(1.8 * Math.sin(x)) / Math.tanh(1.8)
            // "flattened crests"
            return tanh(1.8 * sin(x)) / tanh(1.8)

        case .pointed:
            // JS key "point": f: (x) => 1 - 2 * Math.abs(Math.sin(x / 2))
            // "cusped crests"
            return 1.0 - 2.0 * abs(sin(x / 2.0))

        case .scallop:
            // f: (x) => 2 * Math.abs(Math.sin(x / 2)) - 1
            // "cusped valleys"
            return 2.0 * abs(sin(x / 2.0)) - 1.0
        }
    }
}

// MARK: - RosePhase

/// Phase mode between successive passes.
/// Raw values match the JS `ph` state values ("same", "half" → halfLobe, "spiral").
public enum RosePhase: String, CaseIterable, Sendable {
    case same
    case halfLobe
    case spiral
}

// MARK: - RoseParams

/// All parameters for the rose engine pattern generator.
public struct RoseParams: Sendable {
    /// Number of rosette lobes; clamped to 1–60 by `RosePattern.paths`.
    public var lobes: Int
    /// Waveform shape applied to each pass.
    public var wave: RoseWave
    /// Amplitude as a percentage of R0 (132 px). Range 1–25 in the UI.
    public var amplitudePct: Double
    /// Number of passes in the band; clamped to 1–48 by `RosePattern.paths`.
    public var passes: Int
    /// Radial step between consecutive passes, as a percentage of R0. Range 0–4 in the UI.
    public var stepPct: Double
    /// Phase mode applied between passes.
    public var phase: RosePhase
    /// When `phase == .spiral`: phase fraction of a full 2π per pass, expressed as
    /// a percentage. Range 2–50 in the UI; default 18.
    public var spiralPct: Double

    public init(
        lobes: Int,
        wave: RoseWave,
        amplitudePct: Double,
        passes: Int,
        stepPct: Double,
        phase: RosePhase,
        spiralPct: Double
    ) {
        self.lobes        = lobes
        self.wave         = wave
        self.amplitudePct = amplitudePct
        self.passes       = passes
        self.stepPct      = stepPct
        self.phase        = phase
        self.spiralPct    = spiralPct
    }
}

// MARK: - RosePattern

/// Rose engine pattern generator — exact port of the `paths` useMemo and readout
/// formulas from app-new.html §8b.
public enum RosePattern {

    // MARK: paths

    /// Generate pattern path points for all passes.
    ///
    /// Exact port of §8b useMemo (app-new.html lines 6409–6425):
    ///
    /// ```js
    /// const R0 = 132, ampPx = R0 * amp / 100, stepPx = R0 * step / 100;
    /// const PTS = 540;
    /// for k in 0..<P {
    ///   Rk = R0 - k*stepPx - ampPx          // base radius for this pass
    ///   if Rk - ampPx < 6: break             // band reached centre
    ///   phi = ...per phase mode...
    ///   for j in 0...PTS {                   // 541 points
    ///     th = j/PTS * 2π
    ///     r  = Rk + ampPx * wave(N*th + phi)
    ///     pt = (170 + r*cos(th), 170 + r*sin(th))
    ///   }
    /// }
    /// ```
    ///
    /// - Parameter p: Rose engine parameters.
    /// - Returns: Array of paths (one per emitted pass). Each path contains **541** `CGPoint`s
    ///   (loop index j = 0 … 540 inclusive, matching the JS `j <= PTS` condition) in the
    ///   web's 340 × 340 coordinate space (centre = 170, 170).
    ///   Passes for which `Rk − ampPx < 6` are dropped (the web's band-collapsed break).
    public static func paths(_ p: RoseParams) -> [[CGPoint]] {
        // Clamp lobes and passes exactly as the JS state initialisation does:
        // const N = Math.max(1, Math.min(60, parseInt(lobes) || 0));
        // const P = Math.max(1, Math.min(48, parseInt(passes) || 0));
        let N: Int = max(1, min(60, p.lobes))
        let P: Int = max(1, min(48, p.passes))

        let R0:    Double = 132.0
        let ampPx: Double = R0 * p.amplitudePct / 100.0
        let stepPx: Double = R0 * p.stepPct / 100.0
        let PTS:   Int    = 540
        let wave          = p.wave
        let Nd = Double(N)

        var out: [[CGPoint]] = []

        for k in 0..<P {
            // Base radius for pass k
            // const Rk = R0 - k * stepPx - ampPx;
            let Rk: Double = R0 - Double(k) * stepPx - ampPx

            // Skip rule: if (Rk - ampPx < 6) break;
            if Rk - ampPx < 6.0 { break }

            // Phase for pass k (exact JS operator precedence: k % 2 * Math.PI = (k%2)*π)
            let phi: Double
            switch p.phase {
            case .same:
                phi = 0.0
            case .halfLobe:
                // k % 2 * Math.PI
                phi = Double(k % 2) * Double.pi
            case .spiral:
                // k * (spiral / 100) * 2 * Math.PI
                phi = Double(k) * (p.spiralPct / 100.0) * 2.0 * Double.pi
            }

            // Build 541 points (j = 0 … PTS, matching JS `j <= PTS`)
            var pts: [CGPoint] = []
            pts.reserveCapacity(PTS + 1)

            for j in 0...PTS {
                // const th = j / PTS * 2 * Math.PI;
                let th: Double = Double(j) / Double(PTS) * 2.0 * Double.pi
                // const r = Rk + ampPx * wave(N * th + phi);
                let r: Double  = Rk + ampPx * wave.f(Nd * th + phi)
                // x = 170 + r * cos(th), y = 170 + r * sin(th)
                let x: Double  = 170.0 + r * cos(th)
                let y: Double  = 170.0 + r * sin(th)
                pts.append(CGPoint(x: x, y: y))
            }

            out.append(pts)
        }

        return out
    }

    // MARK: Readouts

    /// Half-lobe phase shift in degrees.
    ///
    /// Verbatim from §8b: `const halfLobeDeg = 180 / N`
    /// where N is the clamped lobe count.
    public static func phaseShiftDeg(_ p: RoseParams) -> Double {
        let N = Double(max(1, min(60, p.lobes)))
        return 180.0 / N
    }

    /// Pattern repeats (number of times the lobe pattern repeats around the work).
    ///
    /// Verbatim from §8b readout: value = N (clamped lobe count).
    public static func patternRepeats(_ p: RoseParams) -> Int {
        return max(1, min(60, p.lobes))
    }
}
