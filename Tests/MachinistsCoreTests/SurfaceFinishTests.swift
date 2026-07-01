import XCTest
@testable import MachinistsCore

final class SurfaceFinishTests: XCTestCase {
    // Golden test 1: surfaceRa with f=0.005 in/rev, r=0.03125 in
    // Expected: rmaxIn≈0.0001 (100 µin), raIn≈0.000025 (25 µin)
    func testSurfaceRa1_0_005_0_03125() {
        let result = surfaceRa(feedIPR: 0.005, noseRadIn: 0.03125)

        XCTAssertEqual(result.rmaxIn, 0.0001, accuracy: 1e-6)
        XCTAssertEqual(result.raIn, 0.000025, accuracy: 1e-7)
    }

    // Golden test 2: feedForRa with raIn=32e-6, r=0.03125 in
    // Expected: feedReq≈0.0056569
    func testFeedForRa1_32e_6_0_03125() {
        let result = feedForRa(raIn: 32e-6, noseRadIn: 0.03125)

        XCTAssertEqual(result, 0.0056569, accuracy: 1e-5)
    }

    // Test that Ra = Rmax / 4
    func testSurfaceRaRatio() {
        let result = surfaceRa(feedIPR: 0.005, noseRadIn: 0.03125)
        let expectedRa = result.rmaxIn / 4
        XCTAssertEqual(result.raIn, expectedRa, accuracy: 1e-12)
    }

    // Test that Rmax = f² / (8 * r)
    func testSurfaceRmaxFormula() {
        let f = 0.005
        let r = 0.03125
        let expectedRmax = (f * f) / (8 * r)
        let result = surfaceRa(feedIPR: f, noseRadIn: r)

        XCTAssertEqual(result.rmaxIn, expectedRmax, accuracy: 1e-12)
    }

    // Test that feedForRa inverse formula works: f = √(Ra × 32 × r)
    func testFeedForRaFormula() {
        let ra = 32e-6
        let r = 0.03125
        let expectedFeed = (ra * 32 * r).squareRoot()
        let result = feedForRa(raIn: ra, noseRadIn: r)

        XCTAssertEqual(result, expectedFeed, accuracy: 1e-12)
    }

    // Test round-trip: surfaceRa then feedForRa should recover original feed
    func testRoundTrip() {
        let originalFeed = 0.005
        let noseRad = 0.03125

        let surface = surfaceRa(feedIPR: originalFeed, noseRadIn: noseRad)
        let recoveredFeed = feedForRa(raIn: surface.raIn, noseRadIn: noseRad)

        XCTAssertEqual(recoveredFeed, originalFeed, accuracy: 1e-8)
    }

    // Edge case: zero feed should give zero roughness
    func testSurfaceRaZeroFeed() {
        let result = surfaceRa(feedIPR: 0.0, noseRadIn: 0.03125)
        XCTAssertEqual(result.rmaxIn, 0.0, accuracy: 1e-12)
        XCTAssertEqual(result.raIn, 0.0, accuracy: 1e-12)
    }

    // Edge case: zero target Ra should give zero feed
    func testFeedForRaZeroTarget() {
        let result = feedForRa(raIn: 0.0, noseRadIn: 0.03125)
        XCTAssertEqual(result, 0.0, accuracy: 1e-12)
    }
}
