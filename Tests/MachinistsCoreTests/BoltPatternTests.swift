import XCTest
@testable import MachinistsCore

final class BoltPatternTests: XCTestCase {
    func testBoltCircle6x3() {
        let h = boltCircle(count: 6, bcdIn: 3, centerX: 0, centerY: 0, startDeg: 0)
        XCTAssertEqual(h.count, 6)
        XCTAssertEqual(h[0].x, 1.5, accuracy: 1e-4)
        XCTAssertEqual(h[0].y, 0, accuracy: 1e-4)
        XCTAssertEqual(h[1].x, 0.75, accuracy: 1e-4)
        XCTAssertEqual(h[1].y, 1.2990, accuracy: 1e-4)
        XCTAssertEqual(h[3].x, -1.5, accuracy: 1e-4)
        XCTAssertEqual(boltCircleChord(count: 6, bcdIn: 3), 1.5, accuracy: 1e-4)
    }

    func testStraightLine4x1() {
        let h = straightLineHoles(count: 4, pitchIn: 1, angleDeg: 0, x0: 0, y0: 0)
        XCTAssertEqual(h.map { $0.x }, [0, 1, 2, 3])
        XCTAssertTrue(h.allSatisfy { abs($0.y) < 1e-9 })
    }
}
