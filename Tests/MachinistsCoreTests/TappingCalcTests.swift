import XCTest
@testable import MachinistsCore
final class TappingCalcTests: XCTestCase {
    func testTap14_20() {
        let major = 0.25, pitch = 1.0/20.0
        let s = tapping(majorIn: major, pitchIn: pitch, sfm: 33)!
        XCTAssertEqual(s.rpm, 504.2, accuracy: 0.1)
        XCTAssertEqual(s.syncFeedIPM, 25.21, accuracy: 1e-2)
        XCTAssertEqual(tapDrillIdeal(majorIn: major, pitchIn: pitch, pct: 75), 0.2013, accuracy: 1e-3)
        let drill = Drills.nearestInch(0.2013)   // #7 ≈ 0.201
        XCTAssertEqual(tapActualPct(majorIn: major, drillDia: drill.dia, pitchIn: pitch), 75.0, accuracy: 3.0)
    }
}
