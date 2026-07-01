import XCTest
@testable import MachinistsCore

final class KnurlTests: XCTestCase {
    // Golden test 1: D=0.5 in, pitch=1/96 in
    // Expected: teeth=151, idealDiaIn≈0.50066, adjustIn≈-0.00066
    func testKnurl1_0_5_96TPI() {
        let pitch = 1.0 / 96.0
        let result = knurl(diaIn: 0.5, pitchIn: pitch)

        XCTAssertEqual(result.teeth, 151)
        XCTAssertEqual(result.idealDiaIn, 0.50066, accuracy: 1e-4)
        XCTAssertEqual(result.adjustIn, -0.00066, accuracy: 1e-4)
    }

    // Golden test 2: D=1.0 in, pitch=1/64 in
    // Expected: teeth=201, adjustIn≈+0.00027
    func testKnurl2_1_0_64TPI() {
        let pitch = 1.0 / 64.0
        let result = knurl(diaIn: 1.0, pitchIn: pitch)

        XCTAssertEqual(result.teeth, 201)
        XCTAssertEqual(result.adjustIn, 0.00027, accuracy: 1e-4)
    }

    // Test that adjust is D - idealDia
    func testKnurlAdjustCalculation() {
        let pitch = 1.0 / 96.0
        let result = knurl(diaIn: 0.5, pitchIn: pitch)

        let expectedAdjust = 0.5 - result.idealDiaIn
        XCTAssertEqual(result.adjustIn, expectedAdjust, accuracy: 1e-10)
    }

    // Test that teeth is properly calculated from pitch and diameter
    func testKnurlTeethCalculation() {
        let pitch = 1.0 / 96.0
        let dia = 0.5
        let expectedTeeth = max(1, Int((Double.pi * dia / pitch).rounded()))
        let result = knurl(diaIn: dia, pitchIn: pitch)

        XCTAssertEqual(result.teeth, expectedTeeth)
    }

    // Test that idealDia is N*pitch/π
    func testKnurlIdealDiaFormula() {
        let pitch = 1.0 / 96.0
        let result = knurl(diaIn: 0.5, pitchIn: pitch)

        let expectedIdealDia = Double(result.teeth) * pitch / Double.pi
        XCTAssertEqual(result.idealDiaIn, expectedIdealDia, accuracy: 1e-10)
    }

    // Edge case: very small diameter should have at least 1 tooth
    func testKnurlMinimumTeeth() {
        let result = knurl(diaIn: 0.001, pitchIn: 1.0)
        XCTAssertGreaterThanOrEqual(result.teeth, 1)
    }
}
