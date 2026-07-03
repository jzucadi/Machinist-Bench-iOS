import XCTest
@testable import MachinistsCore

final class SineBarTests: XCTestCase {
    func testSineBar5in30deg() {
        let (stackIn, decimalDeg) = sineBarStack(barLengthIn: 5, degrees: 30, minutes: 0, seconds: 0)
        XCTAssertEqual(stackIn, 2.5, accuracy: 1e-9)
        XCTAssertEqual(decimalDeg, 30.0, accuracy: 1e-9)
    }

    func testSineBar100mm45deg30min15sec() {
        let barLengthMm = 100.0
        let barLengthIn = barLengthMm / 25.4
        let (stackIn, decimalDeg) = sineBarStack(barLengthIn: barLengthIn, degrees: 45, minutes: 30, seconds: 15)

        // Expected: stack ≈ 71.330 mm
        let stackMm = stackIn * 25.4

        XCTAssertEqual(decimalDeg, 45.50416666666667, accuracy: 1e-9)
        XCTAssertEqual(stackMm, 71.330, accuracy: 1e-3)
    }
}
