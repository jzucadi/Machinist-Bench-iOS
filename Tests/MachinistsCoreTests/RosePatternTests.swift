// RosePatternTests.swift — Rose engine pattern generator tests
// Source: m7-extraction.md §8b golden values (node-verified 2026-07-06).
// TDD: written before implementation.

import XCTest
@testable import MachinistsCore

final class RosePatternTests: XCTestCase {

    // MARK: - Shared fixture

    /// Simple Rose parameter set used for all per-waveform golden tests.
    /// §8b: N=6, amp=10, P=1, step=0, ph="same", spiral=18
    private let simpleRose = RoseParams(
        lobes:        6,
        wave:         .sine,     // overridden per test
        amplitudePct: 10.0,
        passes:       1,
        stepPct:      0.0,
        phase:        .same,
        spiralPct:    18.0
    )

    // MARK: - Per-waveform golden point tests (§8b, pass k=0, j=27, ±1e-9)
    //
    // Derived values (verbatim from extraction):
    //   R0=132, ampPx=13.2, stepPx=0, Rk(k=0)=118.8
    //   th = 27/540 × 2π = π/10; N·th = 6·π/10 = 3π/5

    func testGoldenPointSine() {
        // wave(3π/5) = sin(3π/5) = 0.9510565162951536
        // r = 131.35394601509603; x = 294.9250262987389, y = 210.59060159687408
        var p = simpleRose
        p.wave = .sine
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 1)
        let pt = paths[0][27]
        XCTAssertEqual(Double(pt.x), 294.9250262987389,  accuracy: 1e-9)
        XCTAssertEqual(Double(pt.y), 210.59060159687408, accuracy: 1e-9)
    }

    func testGoldenPointPuffy() {
        // wave(3π/5) = tanh(1.8·sin(3π/5))/tanh(1.8) = 0.9895167977103513
        // r = 131.86162172977663; x = 295.40785459535067, y = 210.74748202034183
        var p = simpleRose
        p.wave = .puffy
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 1)
        let pt = paths[0][27]
        XCTAssertEqual(Double(pt.x), 295.40785459535067, accuracy: 1e-9)
        XCTAssertEqual(Double(pt.y), 210.74748202034183, accuracy: 1e-9)
    }

    func testGoldenPointPointed() {
        // wave(3π/5) = 1 − 2·|sin(3π/10)| = −0.6180339887498949
        // r = 110.64195134850138; x = 275.2267488056036, y = 204.19024325749305
        var p = simpleRose
        p.wave = .pointed
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 1)
        let pt = paths[0][27]
        XCTAssertEqual(Double(pt.x), 275.2267488056036,  accuracy: 1e-9)
        XCTAssertEqual(Double(pt.y), 204.19024325749305, accuracy: 1e-9)
    }

    func testGoldenPointScallop() {
        // wave(3π/5) = 2·|sin(3π/10)| − 1 = 0.6180339887498949
        // r = 126.95804865149861; x = 290.7442794661249, y = 209.23219460599444
        var p = simpleRose
        p.wave = .scallop
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 1)
        let pt = paths[0][27]
        XCTAssertEqual(Double(pt.x), 290.7442794661249,  accuracy: 1e-9)
        XCTAssertEqual(Double(pt.y), 209.23219460599444, accuracy: 1e-9)
    }

    // MARK: - "Phased spikes" readout goldens (§8b)
    //
    // N=12, wf=sine, amp=8, P=2, step=0, ph="half", spiral=18
    // Rk(k=0)=Rk(k=1)=121.44; both pass break check (121.44−10.56=110.88 ≥ 6)
    // halfLobeDeg = 180/12 = 15.0°; patternRepeats = 12; paths.count = 2

    func testPhasedSpikesReadouts() {
        let p = RoseParams(
            lobes:        12,
            wave:         .sine,
            amplitudePct: 8.0,
            passes:       2,
            stepPct:      0.0,
            phase:        .halfLobe,
            spiralPct:    18.0
        )
        XCTAssertEqual(RosePattern.phaseShiftDeg(p), 15.0, accuracy: 1e-9)
        XCTAssertEqual(RosePattern.patternRepeats(p), 12)
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 2, "cuts drawn should equal P=2 (full band)")
    }

    // MARK: - Path and point counts

    func testSimpleRosePathAndPointCounts() {
        // P=1 → 1 path; loop j=0…540 → 541 CGPoints per path
        let paths = RosePattern.paths(simpleRose)
        XCTAssertEqual(paths.count, 1)
        XCTAssertEqual(paths[0].count, 541)
    }

    func testMultipassPointCounts() {
        // 3 passes that all clear the break condition; each still 541 pts
        let p = RoseParams(
            lobes:        6,
            wave:         .sine,
            amplitudePct: 4.0,
            passes:       3,
            stepPct:      0.0,
            phase:        .same,
            spiralPct:    18.0
        )
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 3)
        for path in paths {
            XCTAssertEqual(path.count, 541)
        }
    }

    // MARK: - Skip rule (Rk − ampPx < 6 → break)

    func testSkipRuleBreaks() {
        // ampPct=45 → ampPx=59.4; stepPct=2 → stepPx=2.64
        // k=0: Rk=72.6, Rk-59.4=13.2 ≥ 6 ✓
        // k=1: Rk=69.96, 10.56 ≥ 6 ✓
        // k=2: Rk=67.32, 7.92 ≥ 6 ✓
        // k=3: Rk=64.68, 5.28 < 6 → BREAK → paths.count = 3
        let p = RoseParams(
            lobes:        6,
            wave:         .sine,
            amplitudePct: 45.0,
            passes:       5,
            stepPct:      2.0,
            phase:        .same,
            spiralPct:    18.0
        )
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 3)
    }

    func testPassesClampedTo48() {
        // passes=100 clamped to 48; ampPct=10, stepPct=0 → no collapse
        // ampPx=13.2; Rk=118.8 for all k; Rk-13.2=105.6 ≥ 6 always → all 48 emit
        var p = simpleRose
        p.passes = 100
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 48)
    }

    func testLobesClampedToMinimum() {
        var p = simpleRose
        p.lobes = 0
        XCTAssertEqual(RosePattern.patternRepeats(p), 1)
        XCTAssertEqual(RosePattern.phaseShiftDeg(p), 180.0, accuracy: 1e-9)
    }

    func testLobesClampedToMaximum() {
        var p = simpleRose
        p.lobes = 100
        XCTAssertEqual(RosePattern.patternRepeats(p), 60)
        XCTAssertEqual(RosePattern.phaseShiftDeg(p), 3.0, accuracy: 1e-9)
    }

    // MARK: - Phase mode: halfLobe

    func testHalfLobePhasePass0MatchesSame() {
        // pass k=0 phi=0 with halfLobe → same result as ph=same
        var p = simpleRose
        p.phase = .halfLobe
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 1)
        let pt = paths[0][27]
        XCTAssertEqual(Double(pt.x), 294.9250262987389,  accuracy: 1e-9)
        XCTAssertEqual(Double(pt.y), 210.59060159687408, accuracy: 1e-9)
    }

    func testHalfLobePhasePass1DiffersFromPass0() {
        // pass k=1 phi=π → waveform is phase-shifted, points differ from k=0
        let p = RoseParams(
            lobes:        6,
            wave:         .sine,
            amplitudePct: 10.0,
            passes:       2,
            stepPct:      0.0,
            phase:        .halfLobe,
            spiralPct:    18.0
        )
        let paths = RosePattern.paths(p)
        XCTAssertEqual(paths.count, 2)
        // Same Rk, but phi=π flips the lobe pattern
        XCTAssertNotEqual(Double(paths[1][27].x), Double(paths[0][27].x))
    }

    // MARK: - Coordinate space

    func testCentrePointAtJ0() {
        // At j=0, th=0, wave = sine(N*0 + phi) = sin(0) = 0
        // r = Rk + ampPx * 0 = Rk = 118.8
        // x = 170 + 118.8 * cos(0) = 170 + 118.8 = 288.8, y = 170 + 118.8 * sin(0) = 170
        let paths = RosePattern.paths(simpleRose)
        let pt = paths[0][0]
        XCTAssertEqual(Double(pt.x), 288.8, accuracy: 1e-9)
        XCTAssertEqual(Double(pt.y), 170.0, accuracy: 1e-9)
    }

    // MARK: - Preset params (§8b ROSE_PRESETS verbatim)

    func testPresetCount() {
        XCTAssertEqual(RoseData.presets.count, 4)
    }

    func testSimpleRosePreset() {
        let (name, p) = RoseData.presets[0]
        XCTAssertEqual(name, "Simple rose")
        XCTAssertEqual(p.lobes,        6)
        XCTAssertEqual(p.wave,         .sine)
        XCTAssertEqual(p.amplitudePct, 10.0, accuracy: 1e-9)
        XCTAssertEqual(p.passes,       1)
        XCTAssertEqual(p.stepPct,      0.0,  accuracy: 1e-9)
        XCTAssertEqual(p.phase,        .same)
        XCTAssertEqual(p.spiralPct,    18.0, accuracy: 1e-9)
    }

    func testPhasedSpikesPreset() {
        let (name, p) = RoseData.presets[1]
        XCTAssertEqual(name, "Phased spikes")
        XCTAssertEqual(p.lobes,        12)
        XCTAssertEqual(p.wave,         .sine)
        XCTAssertEqual(p.amplitudePct, 8.0,  accuracy: 1e-9)
        XCTAssertEqual(p.passes,       2)
        XCTAssertEqual(p.stepPct,      0.0,  accuracy: 1e-9)
        XCTAssertEqual(p.phase,        .halfLobe)
        XCTAssertEqual(p.spiralPct,    18.0, accuracy: 1e-9)
    }

    func testBasketweavePreset() {
        let (name, p) = RoseData.presets[2]
        XCTAssertEqual(name, "Basketweave band")
        XCTAssertEqual(p.lobes,        12)
        XCTAssertEqual(p.wave,         .sine)
        XCTAssertEqual(p.amplitudePct, 4.0,  accuracy: 1e-9)
        XCTAssertEqual(p.passes,       28)
        XCTAssertEqual(p.stepPct,      1.2,  accuracy: 1e-9)
        XCTAssertEqual(p.phase,        .halfLobe)
        XCTAssertEqual(p.spiralPct,    18.0, accuracy: 1e-9)
    }

    func testMoireSpiralPreset() {
        let (name, p) = RoseData.presets[3]
        XCTAssertEqual(name, "Moiré spiral")
        XCTAssertEqual(p.lobes,        8)
        XCTAssertEqual(p.wave,         .puffy)
        XCTAssertEqual(p.amplitudePct, 6.0,  accuracy: 1e-9)
        XCTAssertEqual(p.passes,       36)
        XCTAssertEqual(p.stepPct,      0.9,  accuracy: 1e-9)
        XCTAssertEqual(p.phase,        .spiral)
        XCTAssertEqual(p.spiralPct,    18.0, accuracy: 1e-9)
    }

    // MARK: - Readout: phaseShiftDeg

    func testPhaseShiftDeg6Lobes() {
        var p = simpleRose
        p.lobes = 6
        XCTAssertEqual(RosePattern.phaseShiftDeg(p), 30.0, accuracy: 1e-9)
    }

    func testPhaseShiftDeg12Lobes() {
        var p = simpleRose
        p.lobes = 12
        XCTAssertEqual(RosePattern.phaseShiftDeg(p), 15.0, accuracy: 1e-9)
    }

    // MARK: - Glossary

    func testGlossaryRowCount() {
        XCTAssertEqual(RoseData.glossary.count, 9)
    }

    func testGlossaryFirstRow() {
        let row = RoseData.glossary[0]
        XCTAssertEqual(row.term, "Rosette")
        XCTAssertTrue(row.meaning.contains("wavy-edged cam"))
    }

    func testGlossaryLastRow() {
        let row = RoseData.glossary[8]
        XCTAssertEqual(row.term, "Division plate")
        XCTAssertTrue(row.meaning.contains("Holtzapffel"))
    }

    // MARK: - Resources

    func testResourcesCount() {
        XCTAssertEqual(RoseData.resources.count, 7)
    }

    func testResourcesFirstEntry() {
        let r = RoseData.resources[0]
        XCTAssertEqual(r.name, "Plumier Foundation")
        XCTAssertEqual(r.url,  "https://plumier.org/resources/")
    }

    func testResourcesBillooms() {
        // billooms.com is the serious prior art for the pattern lab
        let r = RoseData.resources[5]
        XCTAssertEqual(r.name, "billooms.com")
        XCTAssertEqual(r.url,  "https://www.billooms.com")
    }

    func testResourcesLastEntry() {
        let r = RoseData.resources[6]
        XCTAssertEqual(r.name, "Society of Ornamental Turners")
        XCTAssertEqual(r.url,  "http://www.the-sot.com")
    }

    // MARK: - RoseWave display names (§8b ROSE_WAVES .name fields)

    func testWaveDisplayNames() {
        XCTAssertEqual(RoseWave.sine.displayName,    "Sine")
        XCTAssertEqual(RoseWave.puffy.displayName,   "Puffy")
        XCTAssertEqual(RoseWave.pointed.displayName, "Pointed")
        XCTAssertEqual(RoseWave.scallop.displayName, "Scallop")
    }

    func testWaveCaseIterable() {
        XCTAssertEqual(RoseWave.allCases.count, 4)
        XCTAssertEqual(RoseWave.allCases[0], .sine)
        XCTAssertEqual(RoseWave.allCases[1], .puffy)
        XCTAssertEqual(RoseWave.allCases[2], .pointed)
        XCTAssertEqual(RoseWave.allCases[3], .scallop)
    }

    // MARK: - RosePhase CaseIterable

    func testPhaseCaseIterable() {
        XCTAssertEqual(RosePhase.allCases.count, 3)
    }
}
