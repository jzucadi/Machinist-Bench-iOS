import XCTest
@testable import MachinistsCore

final class TaperTests: XCTestCase {
    // Golden test 1: D=1, d=0.75, L=3, lbc=0
    // Expected: tpi ≈ 0.083333, tpf = 1.0, halfAngleDeg ≈ 2.38594,
    //           includedAngleDeg ≈ 4.77189, setover = 0.125, setoverBetweenCenters = nil
    func testTaper1_0_0_75_3_0() {
        let result = taper(largeDiaIn: 1.0, smallDiaIn: 0.75, lengthIn: 3.0, betweenCentersIn: 0)

        XCTAssertNotNil(result)
        guard let result = result else { return }

        XCTAssertEqual(result.tpi, 0.083333, accuracy: 1e-4)
        XCTAssertEqual(result.tpf, 1.0, accuracy: 1e-4)
        XCTAssertEqual(result.halfAngleDeg, 2.385944, accuracy: 1e-4)
        XCTAssertEqual(result.includedAngleDeg, 4.771888, accuracy: 1e-4)
        XCTAssertEqual(result.setover, 0.125, accuracy: 1e-4)
        XCTAssertNil(result.setoverBetweenCenters)
    }

    // Golden test 2: D=1, d=0.5, L=4, lbc=6
    // Expected: tpf = 1.5, setover = 0.25, setoverBetweenCenters = 0.375
    func testTaper1_0_0_5_4_6() {
        let result = taper(largeDiaIn: 1.0, smallDiaIn: 0.5, lengthIn: 4.0, betweenCentersIn: 6.0)

        XCTAssertNotNil(result)
        guard let result = result else { return }

        XCTAssertEqual(result.tpf, 1.5, accuracy: 1e-4)
        XCTAssertEqual(result.setover, 0.25, accuracy: 1e-4)
        if let setoverBC = result.setoverBetweenCenters {
            XCTAssertEqual(setoverBC, 0.375, accuracy: 1e-4)
        } else {
            XCTFail("setoverBetweenCenters should not be nil")
        }
    }

    // Edge case: L = 0 should return nil
    func testTaperZeroLength() {
        let result = taper(largeDiaIn: 1.0, smallDiaIn: 0.75, lengthIn: 0, betweenCentersIn: 0)
        XCTAssertNil(result)
    }

    // Edge case: L < 0 should return nil
    func testTaperNegativeLength() {
        let result = taper(largeDiaIn: 1.0, smallDiaIn: 0.75, lengthIn: -1.0, betweenCentersIn: 0)
        XCTAssertNil(result)
    }

    // Edge case: lbc = 0 should set setoverBetweenCenters to nil
    func testTaperZeroBetweenCenters() {
        let result = taper(largeDiaIn: 1.0, smallDiaIn: 0.75, lengthIn: 3.0, betweenCentersIn: 0)
        XCTAssertNotNil(result)
        XCTAssertNil(result?.setoverBetweenCenters)
    }

    // Edge case: negative lbc should set setoverBetweenCenters to nil
    func testTaperNegativeBetweenCenters() {
        let result = taper(largeDiaIn: 1.0, smallDiaIn: 0.75, lengthIn: 3.0, betweenCentersIn: -1.0)
        XCTAssertNotNil(result)
        XCTAssertNil(result?.setoverBetweenCenters)
    }
}
