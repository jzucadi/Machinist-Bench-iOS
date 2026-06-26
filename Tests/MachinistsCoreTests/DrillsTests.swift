import XCTest
@testable import MachinistsCore

final class DrillsTests: XCTestCase {
    func testWireCount() { XCTAssertEqual(Drills.wire.count, 80) }            // #80…#1
    func testLetterEndpoints() throws {
        let first = try XCTUnwrap(Drills.letter.first)
        let last  = try XCTUnwrap(Drills.letter.last)
        XCTAssertEqual(first.name, "A")
        XCTAssertEqual(first.dia, 0.234, accuracy: 1e-9)
        XCTAssertEqual(last.name, "Z")
    }
    func testNearestInchForTapDrill() {        // 1/4-20 @75% ideal ≈ 0.2013" → #7 (0.201")
        let d = Drills.nearestInch(0.2013)
        XCTAssertEqual(d.dia, 0.201, accuracy: 1e-3)
    }
    func testNearestMetricStep() {             // rounds to 0.05 below 3mm, else 0.1
        XCTAssertEqual(Drills.nearestMetricMM(5.03), 5.0, accuracy: 1e-9)
    }
}
