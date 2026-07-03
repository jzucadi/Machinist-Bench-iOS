import XCTest
@testable import MachinistsCore

final class GaugeStackTests: XCTestCase {

    // MARK: - Block set sizes

    func testInchSetCount() {
        XCTAssertEqual(GaugeBlocks.inchSet.count, 81, "Standard 81-piece inch set")
    }

    func testMetricSetCount() {
        XCTAssertEqual(GaugeBlocks.metricSet.count, 88, "Standard 88-piece metric set")
    }

    // MARK: - Inch golden: 1.0321" → [0.1001, 0.132, 0.8]

    func testInch_1_0321() {
        guard let blocks = gaugeStack(targetIn: 1.0321, metric: false) else {
            XCTFail("gaugeStack(1.0321, metric:false) returned nil")
            return
        }
        let expected: Set<Double> = [0.1001, 0.132, 0.8]
        XCTAssertEqual(Set(blocks), expected, "Expected blocks [0.1001, 0.132, 0.8]")
        let sum = blocks.reduce(0.0, +)
        XCTAssertEqual(sum, 1.0321, accuracy: 1e-9, "Blocks must sum to target within 1e-9")
    }

    // MARK: - Metric golden: 28.5125 mm → [1.0005, 1.002, 1.01, 5.5, 20]
    // gaugeStack(targetIn:, metric:true) — when metric:true, targetIn is interpreted as mm

    func testMetric_28_5125() {
        guard let blocks = gaugeStack(targetIn: 28.5125, metric: true) else {
            XCTFail("gaugeStack(28.5125, metric:true) returned nil")
            return
        }
        let expected: Set<Double> = [1.0005, 1.002, 1.01, 5.5, 20]
        XCTAssertEqual(Set(blocks), expected, "Expected blocks [1.0005, 1.002, 1.01, 5.5, 20]")
        let sum = blocks.reduce(0.0, +)
        XCTAssertEqual(sum, 28.5125, accuracy: 1e-9, "Blocks must sum to target within 1e-9")
    }

    // MARK: - Additional inch goldens (from app.html docs)

    func testInch_2_5682() {
        guard let blocks = gaugeStack(targetIn: 2.5682, metric: false) else {
            XCTFail("gaugeStack(2.5682, metric:false) returned nil")
            return
        }
        let expected: Set<Double> = [0.1002, 0.118, 0.35, 2]
        XCTAssertEqual(Set(blocks), expected)
        XCTAssertEqual(blocks.reduce(0.0, +), 2.5682, accuracy: 1e-9)
    }

    func testInch_1_2345() {
        guard let blocks = gaugeStack(targetIn: 1.2345, metric: false) else {
            XCTFail("gaugeStack(1.2345, metric:false) returned nil")
            return
        }
        let expected: Set<Double> = [0.1005, 0.134, 1]
        XCTAssertEqual(Set(blocks), expected)
        XCTAssertEqual(blocks.reduce(0.0, +), 1.2345, accuracy: 1e-9)
    }

    func testInch_3_1416() {
        guard let blocks = gaugeStack(targetIn: 3.1416, metric: false) else {
            XCTFail("gaugeStack(3.1416, metric:false) returned nil")
            return
        }
        let expected: Set<Double> = [0.1006, 0.141, 0.9, 2]
        XCTAssertEqual(Set(blocks), expected)
        XCTAssertEqual(blocks.reduce(0.0, +), 3.1416, accuracy: 1e-9)
    }

    // MARK: - Additional metric goldens (from app.html docs)

    func testMetric_71_330() {
        guard let blocks = gaugeStack(targetIn: 71.330, metric: true) else {
            XCTFail("gaugeStack(71.330, metric:true) returned nil")
            return
        }
        let expected: Set<Double> = [1.33, 70]
        XCTAssertEqual(Set(blocks), expected)
        XCTAssertEqual(blocks.reduce(0.0, +), 71.330, accuracy: 1e-9)
    }

    func testMetric_15_0065() {
        guard let blocks = gaugeStack(targetIn: 15.0065, metric: true) else {
            XCTFail("gaugeStack(15.0065, metric:true) returned nil")
            return
        }
        let expected: Set<Double> = [1.0005, 1.006, 3, 10]
        XCTAssertEqual(Set(blocks), expected)
        XCTAssertEqual(blocks.reduce(0.0, +), 15.0065, accuracy: 1e-9)
    }

    // MARK: - Single-block exact-match

    func testInch_exactBlockMatch() {
        // 0.8 is in the set directly
        guard let blocks = gaugeStack(targetIn: 0.8, metric: false) else {
            XCTFail("gaugeStack(0.8, metric:false) returned nil")
            return
        }
        XCTAssertEqual(blocks, [0.8])
        XCTAssertEqual(blocks.reduce(0.0, +), 0.8, accuracy: 1e-9)
    }

    func testMetric_exactBlockMatch() {
        // 20 mm is in the set directly
        guard let blocks = gaugeStack(targetIn: 20.0, metric: true) else {
            XCTFail("gaugeStack(20.0, metric:true) returned nil")
            return
        }
        XCTAssertEqual(blocks, [20.0])
        XCTAssertEqual(blocks.reduce(0.0, +), 20.0, accuracy: 1e-9)
    }

    // MARK: - Invalid inputs return nil

    func testInch_tooSmall_returnsNil() {
        // Below 0.050" minimum
        let blocks = gaugeStack(targetIn: 0.01, metric: false)
        XCTAssertNil(blocks, "Target below 0.050\" should return nil")
    }

    func testMetric_tooSmall_returnsNil() {
        // Below 0.5 mm minimum
        let blocks = gaugeStack(targetIn: 0.1, metric: true)
        XCTAssertNil(blocks, "Target below 0.5 mm should return nil")
    }

    func testInch_zero_returnsNil() {
        let blocks = gaugeStack(targetIn: 0, metric: false)
        XCTAssertNil(blocks)
    }

    func testMetric_zero_returnsNil() {
        let blocks = gaugeStack(targetIn: 0, metric: true)
        XCTAssertNil(blocks)
    }
}
