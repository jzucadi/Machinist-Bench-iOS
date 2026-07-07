import XCTest
@testable import MachinistsCore

// Golden cases from m7-extraction §4.1 (node-verified)
final class MicReadingTests: XCTestCase {

    // MARK: decompose — golden cases

    func testDecompose_0_276() {
        let p = MicReading.decompose(0.276)
        // sleeve25=11 → major=11/4=2, minor=11%4=3, thimble=0.001
        XCTAssertEqual(p.major, 2)
        XCTAssertEqual(p.minor, 3)
        XCTAssertEqual(p.thimble, 0.001, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.276, accuracy: 1e-9)
        // Sum invariant: major*0.1 + minor*0.025 + thimble == total
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    func testDecompose_0_100() {
        let p = MicReading.decompose(0.100)
        // sleeve25=4 → major=1, minor=0, thimble=0.000
        XCTAssertEqual(p.major, 1)
        XCTAssertEqual(p.minor, 0)
        XCTAssertEqual(p.thimble, 0.000, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.100, accuracy: 1e-9)
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    func testDecompose_0_413() {
        let p = MicReading.decompose(0.413)
        // sleeve25=16 → major=4, minor=0, thimble=0.013
        XCTAssertEqual(p.major, 4)
        XCTAssertEqual(p.minor, 0)
        XCTAssertEqual(p.thimble, 0.013, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.413, accuracy: 1e-9)
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    func testDecompose_0_999() {
        let p = MicReading.decompose(0.999)
        // sleeve25=39 → major=9, minor=3, thimble=0.024
        XCTAssertEqual(p.major, 9)
        XCTAssertEqual(p.minor, 3)
        XCTAssertEqual(p.thimble, 0.024, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.999, accuracy: 1e-9)
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    // Additional slider sanity cases
    func testDecompose_0_025() {
        // One quarter-tick, zero thimble
        let p = MicReading.decompose(0.025)
        XCTAssertEqual(p.major, 0)
        XCTAssertEqual(p.minor, 1)
        XCTAssertEqual(p.thimble, 0.000, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.025, accuracy: 1e-9)
    }

    func testDecompose_0_500() {
        let p = MicReading.decompose(0.500)
        XCTAssertEqual(p.major, 5)
        XCTAssertEqual(p.minor, 0)
        XCTAssertEqual(p.thimble, 0.000, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.500, accuracy: 1e-9)
    }

    func testDecompose_0_2837() {
        let p = MicReading.decompose(0.2837)
        // sleeve25=11 → major=2, minor=3, thimble=0.009
        XCTAssertEqual(p.major, 2)
        XCTAssertEqual(p.minor, 3)
        XCTAssertEqual(p.thimble, 0.009, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.284, accuracy: 1e-9)
        // Sum invariant: major*0.1 + minor*0.025 + thimble == total
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    func testDecompose_zero() {
        let p = MicReading.decompose(0.0)
        XCTAssertEqual(p.major, 0)
        XCTAssertEqual(p.minor, 0)
        XCTAssertEqual(p.thimble, 0.0, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.0, accuracy: 1e-9)
        // Sum invariant: major*0.1 + minor*0.025 + thimble == total
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    func testDecompose_0_09999() {
        let p = MicReading.decompose(0.09999)
        // Near-boundary epsilon case: snaps to 0.1
        // sleeve25=4 → major=1, minor=0, thimble=0.0
        XCTAssertEqual(p.major, 1)
        XCTAssertEqual(p.minor, 0)
        XCTAssertEqual(p.thimble, 0.0, accuracy: 1e-9)
        XCTAssertEqual(p.total,   0.1, accuracy: 1e-9)
        // Sum invariant: major*0.1 + minor*0.025 + thimble == total
        XCTAssertEqual(Double(p.major) * 0.1 + Double(p.minor) * 0.025 + p.thimble,
                       p.total, accuracy: 1e-9)
    }

    // MARK: vernierTenths

    func testVernierTenths() {
        XCTAssertEqual(MicReading.vernierTenths(0.2763), 3)
        XCTAssertEqual(MicReading.vernierTenths(0.2760), 0)
        XCTAssertEqual(MicReading.vernierTenths(0.2769), 9)
        XCTAssertEqual(MicReading.vernierTenths(0.1000), 0)
        XCTAssertEqual(MicReading.vernierTenths(0.4131), 1)
    }
}
