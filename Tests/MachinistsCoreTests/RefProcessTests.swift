// RefProcessTests.swift — Row-count and spot-check tests for process reference tables
// Verified against app.html Reference component (lines ~4167–4244) via direct inspection.

import XCTest
@testable import MachinistsCore

final class RefProcessTests: XCTestCase {

    // MARK: - Harden / Quench / Temper (6 steels)

    func testHardenTemperRowCount() {
        XCTAssertEqual(RefTables.hardenTemper.count, 6)
    }

    /// Spot-check: O1 hardens at 790–815 °C and quenches in Oil.
    func testO1HardenTemp() throws {
        let row = try XCTUnwrap(RefTables.hardenTemper.first { $0.steel == "O1 (oil-hard.)" })
        XCTAssertEqual(row.hardenC, "790–815")
        XCTAssertEqual(row.quench,  "Oil")
    }

    /// Spot-check: W1 quench medium is Water/brine.
    func testW1QuenchMedium() throws {
        let row = try XCTUnwrap(RefTables.hardenTemper.first { $0.steel == "W1 (water-hard.)" })
        XCTAssertEqual(row.quench, "Water/brine")
    }

    /// Spot-check: D2 hardens at 1000–1025 °C.
    func testD2HardenRange() throws {
        let row = try XCTUnwrap(RefTables.hardenTemper.first { $0.steel == "D2 (air-hard.)" })
        XCTAssertEqual(row.hardenC, "1000–1025")
    }

    // MARK: - Tempering Colors (7 rows)

    func testTemperingColorsRowCount() {
        XCTAssertEqual(RefTables.temperingColors.count, 7)
    }

    /// Spot-check: "Blue" appears at 295 °C (springs, screwdrivers).
    func testTemperingBlueAt295() throws {
        let row = try XCTUnwrap(RefTables.temperingColors.first { $0.color == "Blue" })
        XCTAssertEqual(row.tempC, 295)
        XCTAssertTrue(row.typicalUse.contains("Springs"))
    }

    /// Spot-check: "Pale straw" is 220 °C and is the hardest temper.
    func testTemperingPaleStrawIsHardest() throws {
        let row = try XCTUnwrap(RefTables.temperingColors.first { $0.color == "Pale straw" })
        XCTAssertEqual(row.tempC, 220)
        XCTAssertTrue(row.typicalUse.contains("hardest"))
    }

    /// Spot-check: "Pale blue" is 310 °C (saws and spanners).
    func testTemperingPaleBlueAt310() throws {
        let row = try XCTUnwrap(RefTables.temperingColors.first { $0.color == "Pale blue" })
        XCTAssertEqual(row.tempC, 310)
        XCTAssertTrue(row.typicalUse.lowercased().contains("saw"))
    }

    // MARK: - Non-Ferrous Annealing (9 rows)

    func testNonFerrousAnnealRowCount() {
        XCTAssertEqual(RefTables.nonFerrousAnneal.count, 9)
    }

    /// Spot-check: Copper anneals at 370–650 °C, cools in Water or air.
    func testCopperAnnealTemp() throws {
        let row = try XCTUnwrap(RefTables.nonFerrousAnneal.first { $0.metal == "Copper" })
        XCTAssertEqual(row.annealC, "370–650")
        XCTAssertEqual(row.cool,    "Water or air")
    }

    /// Spot-check: Aluminum 6061 anneals at 415 °C and slow furnace cool.
    func testAluminum6061Anneal() throws {
        let row = try XCTUnwrap(RefTables.nonFerrousAnneal.first { $0.metal == "Aluminum 6061" })
        XCTAssertEqual(row.annealC, "415")
        XCTAssertTrue(row.cool.lowercased().contains("slow"))
    }

    /// Spot-check: Sterling silver note mentions firestain.
    func testSterlingSilverNote() throws {
        let row = try XCTUnwrap(RefTables.nonFerrousAnneal.first { $0.metal == "Sterling silver" })
        XCTAssertTrue(row.notes.contains("firestain"))
    }

    // MARK: - HSS Angles by Material (13 rows)

    func testHSSAnglesRowCount() {
        XCTAssertEqual(RefTables.hssAngles.count, 13)
    }

    /// Spot-check: Aluminum → approach relief 12°, top rake 35°.
    func testAluminumHSSAngles() throws {
        let row = try XCTUnwrap(RefTables.hssAngles.first { $0.material == "Aluminum" })
        XCTAssertEqual(row.apprRelief,  "12°")
        XCTAssertEqual(row.topRake,     "35°")
    }

    /// Spot-check: Brass / Bronze → top rake 0° (no grab).
    func testBrassBronzeZeroRake() throws {
        let row = try XCTUnwrap(RefTables.hssAngles.first { $0.material == "Brass / Bronze" })
        XCTAssertEqual(row.topRake, "0°")
    }

    /// Spot-check: Thermoplastics → approach relief 20°, top rake 20°.
    func testThermoplasticsAngles() throws {
        let row = try XCTUnwrap(RefTables.hssAngles.first { $0.material == "Thermoplastics" })
        XCTAssertEqual(row.apprRelief, "20°")
        XCTAssertEqual(row.topRake,    "20°")
    }

    /// Spot-check: Mild Steel → front relief 8°, top relief 14°.
    func testMildSteelAngles() throws {
        let row = try XCTUnwrap(RefTables.hssAngles.first { $0.material == "Mild Steel" })
        XCTAssertEqual(row.frontRelief, "8°")
        XCTAssertEqual(row.topRelief,   "14°")
    }

    // MARK: - Grinding Wheel Selection (5 rows)

    func testGrindingWheelsRowCount() {
        XCTAssertEqual(RefTables.grindingWheels.count, 5)
    }

    /// Spot-check: Rough HSS tools use aluminum oxide A, grit 36–46, medium K–M.
    func testRoughHSSWheelSelection() throws {
        let row = try XCTUnwrap(RefTables.grindingWheels.first { $0.job == "Rough HSS tools" })
        XCTAssertEqual(row.abrasive, "Aluminum oxide (A)")
        XCTAssertEqual(row.grit,     "36–46")
        XCTAssertTrue(row.grade.contains("K–M"))
    }

    /// Spot-check: Carbide (offhand) uses silicon carbide GC, soft H–J.
    func testCarbideOffhandWheel() throws {
        let row = try XCTUnwrap(RefTables.grindingWheels.first { $0.job == "Carbide (offhand)" })
        XCTAssertEqual(row.abrasive, "Silicon carbide (GC)")
        XCTAssertTrue(row.grade.contains("H–J"))
    }

    // MARK: - Steam Table (8 rows)

    func testSteamTableRowCount() {
        XCTAssertEqual(RefTables.steamTable.count, 8)
    }

    /// Spot-check: 0 gauge psi → 100 °C / 212 °F (atmospheric boiling point).
    func testSteamAtAtmospheric() throws {
        let row = try XCTUnwrap(RefTables.steamTable.first { $0.gaugePSI == 0 })
        XCTAssertEqual(row.tempC,   100)
        XCTAssertEqual(row.tempF,   212)
        XCTAssertEqual(row.absPSIA, "14.7")
    }

    /// Spot-check: 100 gauge psi → 170 °C / 338 °F.
    func testSteamAt100PSI() throws {
        let row = try XCTUnwrap(RefTables.steamTable.first { $0.gaugePSI == 100 })
        XCTAssertEqual(row.tempC,   170)
        XCTAssertEqual(row.tempF,   338)
        XCTAssertEqual(row.absPSIA, "114.7")
    }

    /// Spot-check: 60 gauge psi → 153 °C / 307 °F (common model loco range).
    func testSteamAt60PSI() throws {
        let row = try XCTUnwrap(RefTables.steamTable.first { $0.gaugePSI == 60 })
        XCTAssertEqual(row.tempC, 153)
        XCTAssertEqual(row.tempF, 307)
    }
}
