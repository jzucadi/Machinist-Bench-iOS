import XCTest
@testable import MachinistsCore

final class ScaleCalcTests: XCTestCase {

    // MARK: - scaleModel

    func testScaleModel_1to32() {
        let result = scaleModel(full: 100, n: 32)
        // model = 100/32 = 3.125
        XCTAssertEqual(result.model, 3.125, accuracy: 1e-9)
        // area = 100/(32*32) = 100/1024
        XCTAssertEqual(result.area, 100.0 / 1024.0, accuracy: 1e-9)
        // vol = 100/(32*32*32) = 100/32768
        XCTAssertEqual(result.vol, 100.0 / 32768.0, accuracy: 1e-9)
    }

    func testScaleModel_1to87_golden() {
        // From extraction doc: 1:87.1, full 432" → model 4.960"
        let result = scaleModel(full: 432, n: 87.1)
        XCTAssertEqual(result.model, 432.0 / 87.1, accuracy: 1e-3)
        XCTAssertEqual(result.area,  432.0 / (87.1 * 87.1), accuracy: 1e-4)
        XCTAssertEqual(result.vol,   432.0 / (87.1 * 87.1 * 87.1), accuracy: 1e-6)
    }

    // MARK: - scaleSpeed

    /// Golden: 1:32, 60 mph, 48" wheel
    /// node verified: scaleMph = 10.606601717798211, rpm = 2376.83507465476 → 2377
    func testScaleSpeed_1to32_60mph_48in() {
        let result = scaleSpeed(prototypeMph: 60, n: 32, wheelDiaIn: 48)
        XCTAssertEqual(result.scaleMph, 10.606601717798211, accuracy: 1e-2)
        // Tolerance 2 rpm per task spec
        XCTAssertEqual(result.wheelRPM, 2376.83507465476, accuracy: 2)
    }

    // MARK: - fastenerNaive

    func testFastenerNaive_halfIn_1to8() {
        XCTAssertEqual(fastenerNaive(diaIn: 0.5, n: 8), 0.0625, accuracy: 1e-9)
    }

    func testFastenerNaive_1in_1to32() {
        // From extraction: 1:32, 1.0" → 0.0313"
        XCTAssertEqual(fastenerNaive(diaIn: 1.0, n: 32), 1.0 / 32.0, accuracy: 1e-9)
    }

    // MARK: - ScalePresets sanity

    func testPresets_railCount() {
        XCTAssertEqual(ScalePresets.rail.count, 17)
    }

    func testPresets_gardenCount() {
        XCTAssertEqual(ScalePresets.garden.count, 6)
    }

    func testPresets_liveSteamCount() {
        XCTAssertEqual(ScalePresets.liveSteam.count, 8)
    }

    func testPresets_carCount() {
        XCTAssertEqual(ScalePresets.car.count, 7)
    }

    func testPresets_aircraftCount() {
        XCTAssertEqual(ScalePresets.aircraft.count, 7)
    }

    func testPresets_boatCount() {
        XCTAssertEqual(ScalePresets.boat.count, 10)
    }

    /// Spot-check: HO is 1:87.1 (not exactly 87)
    func testPresets_HO_ratio() {
        let ho = ScalePresets.rail.first { $0.name.hasPrefix("HO") }
        XCTAssertNotNil(ho)
        XCTAssertEqual(ho!.n, 87.1, accuracy: 1e-9)
    }

    /// Spot-check: O (UK) is 1:43.5
    func testPresets_O_UK_ratio() {
        let oUK = ScalePresets.rail.first { $0.name.contains("UK") && $0.name.contains("43") }
        XCTAssertNotNil(oUK)
        XCTAssertEqual(oUK!.n, 43.5, accuracy: 1e-9)
    }

    /// Spot-check: 1 gauge is 1:32
    func testPresets_1gauge_ratio() {
        let oneGauge = ScalePresets.rail.first { $0.name.contains("1 gauge") }
        XCTAssertNotNil(oneGauge)
        XCTAssertEqual(oneGauge!.n, 32, accuracy: 1e-9)
    }
}
