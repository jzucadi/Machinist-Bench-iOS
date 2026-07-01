import XCTest
@testable import MachinistsCore

final class RightTriangleTests: XCTestCase {

    // Golden test 1: a=3, b=4 → h=5, angleX≈36.8699°, area=6, perimeter=12
    func testTwoSides_a3_b4() {
        guard let r = solveRightTriangle(a: 3, b: 4) else {
            XCTFail("Expected non-nil result for a=3, b=4")
            return
        }
        XCTAssertEqual(r.a, 3.0, accuracy: 1e-10)
        XCTAssertEqual(r.b, 4.0, accuracy: 1e-10)
        XCTAssertEqual(r.h, 5.0, accuracy: 1e-4)
        XCTAssertEqual(r.angleX, 36.8699, accuracy: 1e-3)
        XCTAssertEqual(r.angleY, 53.1301, accuracy: 1e-3)
        XCTAssertEqual(r.area, 6.0, accuracy: 1e-4)
        XCTAssertEqual(r.perimeter, 12.0, accuracy: 1e-4)
    }

    // Golden test 2: a=1.5, angleXDeg=30 → h=3, b≈2.59808, angleY=60, area≈1.94856
    func testSideAngle_a1_5_X30() {
        guard let r = solveRightTriangle(a: 1.5, angleXDeg: 30) else {
            XCTFail("Expected non-nil result for a=1.5, angleX=30°")
            return
        }
        XCTAssertEqual(r.a, 1.5, accuracy: 1e-10)
        XCTAssertEqual(r.h, 3.0, accuracy: 1e-3)
        XCTAssertEqual(r.b, 2.59808, accuracy: 1e-3)
        XCTAssertEqual(r.angleX, 30.0, accuracy: 1e-10)
        XCTAssertEqual(r.angleY, 60.0, accuracy: 1e-10)
        XCTAssertEqual(r.area, 1.94856, accuracy: 1e-3)
    }

    // Underdetermined: only a given → nil
    func testUnderdetermined_onlyA() {
        let r = solveRightTriangle(a: 5)
        XCTAssertNil(r, "Expected nil when only one side (a) is provided")
    }

    // Additional coverage: a & h branch
    func testTwoSides_a3_h5() {
        guard let r = solveRightTriangle(a: 3, h: 5) else {
            XCTFail("Expected non-nil result for a=3, h=5")
            return
        }
        XCTAssertEqual(r.a, 3.0, accuracy: 1e-10)
        XCTAssertEqual(r.b, 4.0, accuracy: 1e-4)
        XCTAssertEqual(r.h, 5.0, accuracy: 1e-10)
        XCTAssertEqual(r.area, 6.0, accuracy: 1e-4)
        XCTAssertEqual(r.perimeter, 12.0, accuracy: 1e-4)
    }

    // Additional coverage: b & h branch
    func testTwoSides_b4_h5() {
        guard let r = solveRightTriangle(b: 4, h: 5) else {
            XCTFail("Expected non-nil result for b=4, h=5")
            return
        }
        XCTAssertEqual(r.a, 3.0, accuracy: 1e-4)
        XCTAssertEqual(r.b, 4.0, accuracy: 1e-10)
        XCTAssertEqual(r.h, 5.0, accuracy: 1e-10)
        XCTAssertEqual(r.area, 6.0, accuracy: 1e-4)
        XCTAssertEqual(r.perimeter, 12.0, accuracy: 1e-4)
    }

    // One side + angle via Y (angleYDeg=60 → X=30)
    func testSideAngle_a1_5_Y60() {
        guard let r = solveRightTriangle(a: 1.5, angleYDeg: 60) else {
            XCTFail("Expected non-nil result for a=1.5, angleY=60°")
            return
        }
        XCTAssertEqual(r.h, 3.0, accuracy: 1e-3)
        XCTAssertEqual(r.b, 2.59808, accuracy: 1e-3)
        XCTAssertEqual(r.angleX, 30.0, accuracy: 1e-10)
        XCTAssertEqual(r.angleY, 60.0, accuracy: 1e-10)
    }

    // b known + angle: b=4, X=36.8699° → a≈3, h≈5
    func testSideAngle_b4_X36_87() {
        guard let r = solveRightTriangle(b: 4, angleXDeg: 36.8699) else {
            XCTFail("Expected non-nil result for b=4, angleX=36.8699°")
            return
        }
        XCTAssertEqual(r.a, 3.0, accuracy: 1e-3)
        XCTAssertEqual(r.b, 4.0, accuracy: 1e-10)
        XCTAssertEqual(r.h, 5.0, accuracy: 1e-3)
    }

    // h known + angle: h=5, X=36.8699° → a≈3, b≈4
    func testSideAngle_h5_X36_87() {
        guard let r = solveRightTriangle(h: 5, angleXDeg: 36.8699) else {
            XCTFail("Expected non-nil result for h=5, angleX=36.8699°")
            return
        }
        XCTAssertEqual(r.a, 3.0, accuracy: 1e-3)
        XCTAssertEqual(r.b, 4.0, accuracy: 1e-3)
        XCTAssertEqual(r.h, 5.0, accuracy: 1e-10)
    }

    // Underdetermined: only angle given → nil
    func testUnderdetermined_onlyAngle() {
        let r = solveRightTriangle(angleXDeg: 45)
        XCTAssertNil(r, "Expected nil when only an angle is provided")
    }

    // Underdetermined: no inputs → nil
    func testUnderdetermined_noInputs() {
        let r = solveRightTriangle()
        XCTAssertNil(r, "Expected nil when no inputs provided")
    }
}
