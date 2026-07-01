import XCTest
@testable import MachinistsCore

final class DividingHeadTests: XCTestCase {

    // MARK: - Golden Test 1: ratio=40, div=24, ornamental=false
    // turnsExact = 40/24 = 1.66667
    // wholeTurns = 1, frac ≈ 0.66667, exact = false
    // Solutions include: B&S #1, circle 18, holes 12 (1*18+12=30... frac*18=12)
    //                    B&S #2, circle 21, holes 14 (frac*21=14)
    func testGolden40div24Standard() {
        let result = dividingHead(ratio: 40, divisions: 24, ornamental: false)

        XCTAssertEqual(result.wholeTurns, 1)
        XCTAssertEqual(result.frac, 2.0 / 3.0, accuracy: 1e-4)
        XCTAssertFalse(result.exact)

        // Must contain B&S #1, circle 18, holes 12
        let sol18 = result.solutions.first { $0.plate == "Brown & Sharpe #1" && $0.circle == 18 }
        XCTAssertNotNil(sol18, "Expected solution on Brown & Sharpe #1, 18-hole circle")
        XCTAssertEqual(sol18?.holes, 12)
        XCTAssertEqual(sol18?.wholeTurns, 1)

        // Must contain B&S #2, circle 21, holes 14
        let sol21 = result.solutions.first { $0.plate == "Brown & Sharpe #2" && $0.circle == 21 }
        XCTAssertNotNil(sol21, "Expected solution on Brown & Sharpe #2, 21-hole circle")
        XCTAssertEqual(sol21?.holes, 14)
        XCTAssertEqual(sol21?.wholeTurns, 1)
    }

    // MARK: - Golden Test 2: ratio=40, div=8, ornamental=false
    // turnsExact = 40/8 = 5.0
    // wholeTurns = 5, frac = 0, exact = true, solutions = []
    func testGolden40div8Exact() {
        let result = dividingHead(ratio: 40, divisions: 8, ornamental: false)

        XCTAssertEqual(result.wholeTurns, 5)
        XCTAssertEqual(result.frac, 0.0, accuracy: 1e-9)
        XCTAssertTrue(result.exact)
        XCTAssertTrue(result.solutions.isEmpty)
    }

    // MARK: - Data tests: plate data is correctly populated
    func testDHPlatesCount() {
        XCTAssertEqual(ShopMathData.dhPlates.count, 4)
    }

    func testBSPlate1Circles() {
        let plate = ShopMathData.dhPlates.first { $0.name == "Brown & Sharpe #1" }
        XCTAssertNotNil(plate)
        XCTAssertEqual(plate?.circles, [15, 16, 17, 18, 19, 20])
    }

    func testBSPlate2Circles() {
        let plate = ShopMathData.dhPlates.first { $0.name == "Brown & Sharpe #2" }
        XCTAssertNotNil(plate)
        XCTAssertEqual(plate?.circles, [21, 23, 27, 29, 31, 33])
    }

    func testBSPlate3Circles() {
        let plate = ShopMathData.dhPlates.first { $0.name == "Brown & Sharpe #3" }
        XCTAssertNotNil(plate)
        XCTAssertEqual(plate?.circles, [37, 39, 41, 43, 47, 49])
    }

    func testCincinnatiPlateCircles() {
        let plate = ShopMathData.dhPlates.first { $0.name == "Cincinnati (high)" }
        XCTAssertNotNil(plate)
        XCTAssertEqual(plate?.circles, [24, 25, 28, 30, 34, 37, 38, 39, 41, 42, 43])
    }

    func testOTPlateData() {
        XCTAssertEqual(ShopMathData.otPlate, [24, 30, 36, 40, 48, 60, 72, 96])
    }

    func testHoltzapffelData() {
        XCTAssertEqual(ShopMathData.holtzapffel, [96, 112, 120, 144, 180, 192, 360])
    }

    // MARK: - Ornamental mode uses OT_PLATE + Holtzapffel
    func testOrnamentalModeUsesOTPlate() {
        // ratio=40, div=96 -> turnsExact = 40/96 = 0.41667, frac ≈ 0.41667
        // OT_PLATE: h=96 -> frac*96 = 40.0 -> holes=40, 0<40<96 ✓
        let result = dividingHead(ratio: 40, divisions: 96, ornamental: true)
        XCTAssertFalse(result.exact)
        let otSol = result.solutions.first { $0.circle == 96 && $0.holes == 40 }
        XCTAssertNotNil(otSol, "Expected solution on OT plate, 96-hole circle, 40 holes")
    }

    func testOrnamentalModeUsesHoltzapffel() {
        // ratio=40, div=9 -> turnsExact = 40/9 = 4.44444, frac = 4/9 ≈ 0.44444
        // Holtzapffel h=144 -> frac*144 = (4/9)*144 = 64.0 -> holes=64, 0<64<144 ✓
        let result = dividingHead(ratio: 40, divisions: 9, ornamental: true)
        let holtzSol = result.solutions.first { $0.plate == "Holtzapffel" && $0.circle == 144 }
        XCTAssertNotNil(holtzSol, "Expected Holtzapffel solution on 144-hole circle")
        XCTAssertEqual(holtzSol?.holes, 64)
    }

    // MARK: - Standard mode does NOT use OT/Holtzapffel plates
    func testStandardModeExcludesOrnamentalPlates() {
        let result = dividingHead(ratio: 40, divisions: 24, ornamental: false)
        let hasOT = result.solutions.contains { $0.plate == "Holtzapffel" }
        XCTAssertFalse(hasOT, "Standard mode should not include Holtzapffel plate")
    }

    // MARK: - IndexSolution properties are accessible (Sendable struct)
    func testIndexSolutionProperties() {
        let result = dividingHead(ratio: 40, divisions: 24, ornamental: false)
        if let sol = result.solutions.first {
            XCTAssertFalse(sol.plate.isEmpty)
            XCTAssertGreaterThan(sol.circle, 0)
            XCTAssertGreaterThanOrEqual(sol.wholeTurns, 0)
            XCTAssertGreaterThan(sol.holes, 0)
            XCTAssertLessThan(sol.holes, sol.circle)
        }
    }

    // MARK: - frac accuracy check from brief
    func testFracAccuracy() {
        let result = dividingHead(ratio: 40, divisions: 24, ornamental: false)
        XCTAssertEqual(result.frac, 0.66667, accuracy: 1e-4)
    }
}
