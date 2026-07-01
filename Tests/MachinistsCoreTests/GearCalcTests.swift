import XCTest
@testable import MachinistsCore

final class GearCalcTests: XCTestCase {
    // Golden test: driveT=20, drivenT=40, rpmIn=100, dp=20
    // Expected: ratio=2, rpmOut=50, centerDistance=1.5,
    //           pdDriver=1, pdDriven=2, odDriver=1.1, odDriven=2.1
    func testGoldenGearCalc() {
        let result = gearCalc(driveT: 20, drivenT: 40, rpmIn: 100, dp: 20)

        XCTAssertNotNil(result)
        guard let result = result else { return }

        XCTAssertEqual(result.ratio, 2.0, accuracy: 1e-4)
        XCTAssertEqual(result.rpmOut, 50.0, accuracy: 1e-4)
        XCTAssertEqual(result.centerDistance, 1.5, accuracy: 1e-4)
        XCTAssertEqual(result.pdDriver, 1.0, accuracy: 1e-4)
        XCTAssertEqual(result.pdDriven, 2.0, accuracy: 1e-4)
        XCTAssertEqual(result.odDriver, 1.1, accuracy: 1e-4)
        XCTAssertEqual(result.odDriven, 2.1, accuracy: 1e-4)
    }

    // Test nil return for invalid driveT
    func testInvalidDriveT() {
        let result = gearCalc(driveT: 0, drivenT: 40, rpmIn: 100, dp: 20)
        XCTAssertNil(result)
    }

    // Test nil return for invalid drivenT
    func testInvalidDrivenT() {
        let result = gearCalc(driveT: 20, drivenT: 0, rpmIn: 100, dp: 20)
        XCTAssertNil(result)
    }

    // Test nil return for invalid dp
    func testInvalidDp() {
        let result = gearCalc(driveT: 20, drivenT: 40, rpmIn: 100, dp: 0)
        XCTAssertNil(result)
    }

    // Test nil return for negative driveT
    func testNegativeDriveT() {
        let result = gearCalc(driveT: -20, drivenT: 40, rpmIn: 100, dp: 20)
        XCTAssertNil(result)
    }
}
