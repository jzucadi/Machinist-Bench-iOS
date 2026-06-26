import XCTest
@testable import MachinistsCore

final class DrillingCalcTests: XCTestCase {
    func testDrillingLowCarbon() {        // D=0.25, sfm=68, feed=0.005, eff=0.8, kp=1
        let r = drilling(diameterIn: 0.25, sfm: 68, feedIPR: 0.005, efficiency: 0.8, kp: 1.0)!
        XCTAssertEqual(r.rpm, 1038.96, accuracy: 0.05)
        XCTAssertEqual(r.ipm, 5.1948, accuracy: 1e-3)
        XCTAssertEqual(r.mrr, 0.2550, accuracy: 1e-3)
        XCTAssertEqual(r.cutHP, 0.2550, accuracy: 1e-3)
        XCTAssertEqual(r.motorHP, 0.31875, accuracy: 1e-4)
    }
    func testDrillingGuard() {
        XCTAssertNil(drilling(diameterIn: 0, sfm: 68, feedIPR: 0.005, efficiency: 0.8, kp: 1))
    }
    func testRecommendedDrillSFM() {       // lowc hss none oil: 60...100 × 0.85 → 51...85
        let lowc = Materials.byID("lowc")!
        XCTAssertEqual(recommendedDrillSFM(material: lowc, tool: .hss, coating: .none, lube: .oil), 51...85)
    }
}
