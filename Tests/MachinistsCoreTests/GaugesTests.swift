import XCTest
@testable import MachinistsCore

final class GaugesTests: XCTestCase {

    // MARK: - Count tests

    func testSWGCount() {
        XCTAssertEqual(Gauges.swg.count, 47)
    }

    func testUSSCount() {
        XCTAssertEqual(Gauges.uss.count, 28)
    }

    func testAWGCount() {
        XCTAssertEqual(Gauges.awg.count, 44)
    }

    // MARK: - Exact row spot-checks

    func testSWGGauge18() {
        // SWG "18" = 0.048 in
        let g = Gauges.swg.first { $0.label == "18" }!
        XCTAssertEqual(g.dia, 0.048, accuracy: 1e-9)
    }

    func testAWGGauge0000() {
        // AWG "0000" = 0.005 * 92^((36-(-3))/39) = 0.46 in exactly
        let g = Gauges.awg.first { $0.label == "0000" }!
        XCTAssertEqual(g.dia, 0.46, accuracy: 1e-9)
    }

    // MARK: - Nearest gauge lookups

    func testNearestSWG_0125() {
        // 0.125 in → SWG 10 (0.128 in) is closer than SWG 9 (0.144 in)
        let result = Gauges.nearest(Gauges.swg, toIn: 0.125)
        XCTAssertEqual(result.label, "10")
    }

    func testNearestAWG_0125() {
        // 0.125 in → AWG 8 (≈ 0.12849 in)
        let result = Gauges.nearest(Gauges.awg, toIn: 0.125)
        XCTAssertEqual(result.label, "8")
    }

    func testNearestUSS_0125() {
        // 0.125 in → USS 11 (0.1196 in) is closer than USS 10 (0.1345 in)
        let result = Gauges.nearest(Gauges.uss, toIn: 0.125)
        XCTAssertEqual(result.label, "11")
    }
}
