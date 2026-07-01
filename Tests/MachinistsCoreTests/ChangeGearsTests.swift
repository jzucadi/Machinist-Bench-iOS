import XCTest
@testable import MachinistsCore

final class ChangeGearsTests: XCTestCase {

    // Imperial set from ShopMathData
    let imperialSet: [Int] = [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75]
    // Metric set (includes 127T)
    let metricSet: [Int]   = [20, 25, 30, 35, 40, 45, 50, 55, 60, 63, 65, 70, 75, 80, 127]

    // Golden test 1: leadscrew 8 TPI, cut 11 TPI, imperial set, compound=true
    //   requiredRatio = 25.4/11 / (25.4/8) = 8/11 ≈ 0.72727
    //   best train: [40, 55] → 40/55 = 0.72727 (exact)
    func testImperialTPI() {
        let result = changeGears(
            leadscrew: .tpi(8),
            target:    .tpi(11),
            available: imperialSet,
            compound:  true
        )

        // Required ratio check
        XCTAssertEqual(result.requiredRatio, 8.0 / 11.0, accuracy: 1e-4)

        // Trains non-empty
        XCTAssertFalse(result.trains.isEmpty, "Expected at least one gear train")

        // Best train is [40, 55] and error is effectively zero
        guard let best = result.trains.first else { return }
        XCTAssertEqual(best.gears, [40, 55], "Best train should be 40/55")
        XCTAssertLessThan(best.errorPct, 1e-3, "Best train error should be < 1e-3 %")
    }

    // Golden test 2: leadscrew 8 TPI, cut metric M1.0 pitch, metric set, compound=true
    //   requiredRatio = 1.0 / (25.4/8) = 8/25.4 ≈ 0.314961
    //   exact train: [40, 127] → 40/127 ≈ 0.314961
    func testMetricM1WithOneHundredTwentySeven() {
        let result = changeGears(
            leadscrew: .tpi(8),
            target:    .mmPitch(1.0),
            available: metricSet,
            compound:  true
        )

        // A train with gears [40, 127] must be present
        let train40_127 = result.trains.first { $0.gears == [40, 127] }
        XCTAssertNotNil(train40_127, "Expected a train [40, 127] in results")

        if let t = train40_127 {
            XCTAssertEqual(t.ratio, 40.0 / 127.0, accuracy: 1e-6)
            XCTAssertLessThan(t.errorPct, 1e-3, "Train [40,127] error should be < 1e-3 %")
        }
    }

    // Verify gearSets data is loaded correctly in ShopMathData
    func testGearSetsData() {
        XCTAssertEqual(ShopMathData.gearSets["imp"],  [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75])
        XCTAssertEqual(ShopMathData.gearSets["met"],  [20, 25, 30, 35, 40, 45, 50, 55, 60, 63, 65, 70, 75, 80, 127])
        XCTAssertEqual(ShopMathData.gearSets["mini"], [20, 20, 30, 35, 40, 45, 50, 55, 57, 60, 65, 80, 127])
    }

    // Verify PitchSpec mm conversion
    func testPitchSpecMM() {
        XCTAssertEqual(PitchSpec.tpi(8).mm, 25.4 / 8, accuracy: 1e-9)
        XCTAssertEqual(PitchSpec.tpi(11).mm, 25.4 / 11, accuracy: 1e-9)
        XCTAssertEqual(PitchSpec.mmPitch(1.0).mm, 1.0, accuracy: 1e-9)
        XCTAssertEqual(PitchSpec.mmPitch(2.5).mm, 2.5, accuracy: 1e-9)
    }

    // Sanity: empty input returns empty trains
    func testEmptyAvailable() {
        let result = changeGears(
            leadscrew: .tpi(8),
            target:    .tpi(11),
            available: [],
            compound:  true
        )
        XCTAssertTrue(result.trains.isEmpty)
    }

    // At most 8 results returned
    func testAtMostEightTrains() {
        let result = changeGears(
            leadscrew: .tpi(8),
            target:    .tpi(11),
            available: imperialSet,
            compound:  true
        )
        XCTAssertLessThanOrEqual(result.trains.count, 8)
    }

    // Without compound, no 4-gear trains returned
    func testNoCompoundTrains() {
        let result = changeGears(
            leadscrew: .tpi(8),
            target:    .tpi(11),
            available: imperialSet,
            compound:  false
        )
        for train in result.trains {
            XCTAssertEqual(train.gears.count, 2, "Without compound=true, all trains must be 2-gear")
        }
    }
}
