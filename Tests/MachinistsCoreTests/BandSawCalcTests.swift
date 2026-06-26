import XCTest
@testable import MachinistsCore

final class BandSawCalcTests: XCTestCase {

    // MARK: - bladeSpeedFPM golden tests

    /// Brief golden test: mild/bi-metal/1" → 280 FPM (band index 1, sfm[1]=280, bi factor=1)
    func testBladeSpeedMildBiMetal1in() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "bi", sectionIn: 1.0), 280)
    }

    /// Carbon blade factor: round(base × 0.5)
    func testBladeSpeedMildCarbon1in() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        // band=1, base=280, carbon=round(280*0.5)=140
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "carbon", sectionIn: 1.0), 140)
    }

    /// Carbide blade: same as base (bi-metal rate)
    func testBladeSpeedMildCarbide1in() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        // band=1, base=280, carbide=280
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "carbide", sectionIn: 1.0), 280)
    }

    /// Band index <1": uses sfm[0]
    func testBladeSpeedBandLessThan1() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        // sectionIn < 1 → band=0, sfm[0]=300
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "bi", sectionIn: 0.5), 300)
    }

    /// Band index 1-3": uses sfm[1]
    func testBladeSpeedBand1to3() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        // sectionIn=2.0 → band=1, sfm[1]=280
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "bi", sectionIn: 2.0), 280)
    }

    /// Band index 3-6": uses sfm[2]
    func testBladeSpeedBand3to6() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        // sectionIn=4.0 → band=2, sfm[2]=260
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "bi", sectionIn: 4.0), 260)
    }

    /// Band index >6": uses sfm[3]
    func testBladeSpeedBandOver6() {
        let mild = SawData.materials.first { $0.key == "mild" }!
        // sectionIn=8.0 → band=3, sfm[3]=250
        XCTAssertEqual(bladeSpeedFPM(material: mild, blade: "bi", sectionIn: 8.0), 250)
    }

    // MARK: - sawPitch golden tests

    /// Brief golden test: steel/solid/1" → label "8-12", avg=10, teeth=10, minTPI=3, maxTPI=24, tone="good"
    func testSawPitchSteel1in() {
        let p = sawPitch(sizeIn: 1.0, materialClass: "steel", userTPI: nil)
        XCTAssertEqual(p.label, "8\u{2013}12")
        XCTAssertEqual(p.teeth, 10, accuracy: 1e-9)
        XCTAssertEqual(p.tone, "good")
        XCTAssertEqual(p.minTPI, 3, accuracy: 1e-9)
        XCTAssertEqual(p.maxTPI, 24, accuracy: 1e-9)
        XCTAssertEqual(p.avg, 10.0, accuracy: 1e-9)
    }

    /// For wood material class, offset is +2 (finer)
    func testSawPitchWoodOffset() {
        // dim=1: raw idx=3, wood off=+2 → idx=5, [3,"5-8",6.5]
        let p = sawPitch(sizeIn: 1.0, materialClass: "wood", userTPI: nil)
        XCTAssertEqual(p.label, "5\u{2013}8")
        XCTAssertEqual(p.avg, 6.5, accuracy: 1e-9)
    }

    /// For plastic/nonfer material class, offset is +1 (finer)
    func testSawPitchPlasticOffset() {
        // dim=1: raw idx=3, plastic off=+1 → idx=4, [2,"6-10",8]
        let p = sawPitch(sizeIn: 1.0, materialClass: "plastic", userTPI: nil)
        XCTAssertEqual(p.label, "6\u{2013}10")
        XCTAssertEqual(p.avg, 8.0, accuracy: 1e-9)
    }

    /// User TPI override: teeth = userTPI × dim
    func testSawPitchUserTPIOverride() {
        let p = sawPitch(sizeIn: 1.0, materialClass: "steel", userTPI: 14.0)
        XCTAssertEqual(p.teeth, 14.0, accuracy: 1e-9)
        XCTAssertEqual(p.tone, "good")  // 14 is in [3..24]
    }

    /// Tone "bad" when teeth < 3
    func testSawPitchToneBad() {
        // dim=2, steel: idx=4, avg=8, teeth=16 → fine
        // Use userTPI=1 so teeth=1×2=2 < 3 → bad
        let p = sawPitch(sizeIn: 2.0, materialClass: "steel", userTPI: 1.0)
        XCTAssertEqual(p.teeth, 2.0, accuracy: 1e-9)
        XCTAssertEqual(p.tone, "bad")
    }

    /// Tone "warn" when teeth > 24
    func testSawPitchToneWarn() {
        // dim=1, userTPI=30 → teeth=30 > 24 → warn
        let p = sawPitch(sizeIn: 1.0, materialClass: "steel", userTPI: 30.0)
        XCTAssertEqual(p.teeth, 30.0, accuracy: 1e-9)
        XCTAssertEqual(p.tone, "warn")
    }

    /// 3-to-24 teeth enforcement: tiny section should go coarser to keep teeth >= 3
    func testSawPitchTeethRuleCoarser() {
        // dim=0.05", steel: raw idx=0 (maxIn=0.125), avg=21, teeth=21*0.05=1.05 < 3
        // Should go coarser (idx--) until teeth >= 3 or idx=0
        // At idx=0 (coarsest), stay there
        let p = sawPitch(sizeIn: 0.05, materialClass: "steel", userTPI: nil)
        XCTAssertGreaterThanOrEqual(p.teeth, 1.0) // Can't go coarser from idx=0
    }

    /// minTPI and maxTPI computed correctly for 2" section
    func testSawPitchMinMaxTPI2in() {
        let p = sawPitch(sizeIn: 2.0, materialClass: "steel", userTPI: nil)
        XCTAssertEqual(p.minTPI, 1.5, accuracy: 1e-9)   // 3/2
        XCTAssertEqual(p.maxTPI, 12.0, accuracy: 1e-9)  // 24/2
    }
}
