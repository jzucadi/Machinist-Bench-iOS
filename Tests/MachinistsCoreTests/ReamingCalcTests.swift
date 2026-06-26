import XCTest
@testable import MachinistsCore

final class ReamingCalcTests: XCTestCase {
    func testReamingQuarter() {        // D=0.25, sfm=50, feed=0.008
        let r = reaming(diameterIn: 0.25, sfm: 50, feedIPR: 0.008)!
        XCTAssertEqual(r.rpm, 763.9, accuracy: 0.1)
        XCTAssertEqual(r.ipm, 6.112, accuracy: 1e-3)
        XCTAssertEqual(r.stock, 0.010, accuracy: 1e-9)       // D in [0.25,0.50)
        XCTAssertEqual(r.preDrill, 0.240, accuracy: 1e-9)
        XCTAssertEqual(r.highLimit, 0.2505, accuracy: 1e-9)  // tol 0.0005
    }
}
