import XCTest
@testable import MachinistsCore

final class HardnessTests: XCTestCase {

    // Golden test 1: HRC=45 → exact row match
    // Expected: hv≈450, hb≈428, hrb=nil, utsKsi≈214 (accuracy 0.5)
    func testHRC_45_exactRow() {
        let r = hardnessConvert(scale: .hrc, value: 45)

        XCTAssertNotNil(r.hv)
        XCTAssertEqual(r.hv!, 450, accuracy: 0.5)
        XCTAssertNotNil(r.hb)
        XCTAssertEqual(r.hb!, 428, accuracy: 0.5)
        XCTAssertNil(r.hrb, "HRB should be nil for HRC=45 (row has null)")
        XCTAssertNotNil(r.utsKsi)
        XCTAssertEqual(r.utsKsi!, 214, accuracy: 0.5)
    }

    // Golden test 2: Brinell=300 → interpolated
    // Verified against web app (node): HV≈315.79, HB≈300, HRC≈31.58, UTS≈150
    // Note: brief-m3-a10 golden comment had an error (used HB column values as HV output).
    // This test matches the actual JS source at app.html line ~4979 (hvFrom + atHv logic).
    func testBrinell_300_interpolated() {
        let r = hardnessConvert(scale: .brinell, value: 300)

        XCTAssertNotNil(r.hv)
        XCTAssertEqual(r.hv!, 315.79, accuracy: 0.5)
        XCTAssertNotNil(r.hb)
        XCTAssertEqual(r.hb!, 300, accuracy: 0.5)
        XCTAssertNotNil(r.hrc)
        XCTAssertEqual(r.hrc!, 31.58, accuracy: 0.5)
        XCTAssertNotNil(r.utsKsi)
        XCTAssertEqual(r.utsKsi!, 150.0, accuracy: 0.5)
    }

    // Verify vickers input returns itself
    func testVickers_450_roundtrip() {
        let r = hardnessConvert(scale: .vickers, value: 450)

        XCTAssertNotNil(r.hv)
        XCTAssertEqual(r.hv!, 450, accuracy: 0.5)
        XCTAssertNotNil(r.hb)
        XCTAssertEqual(r.hb!, 428, accuracy: 0.5)
    }

    // Verify out-of-range HRC returns nil
    func testHRC_outOfRange_returnsNil() {
        // HRC col only covers rows where hrc is non-nil; value of 200 is way above max HRC=68
        let r = hardnessConvert(scale: .hrc, value: 200)
        XCTAssertNil(r.hv, "Should be nil when out of range")
    }

    // Verify HardnessTable has exactly 22 rows
    func testTableHas22Rows() {
        XCTAssertEqual(HardnessTable.rows.count, 22)
    }

    // Verify first and last table rows
    func testTableFirstRow() {
        let first = HardnessTable.rows[0]
        XCTAssertEqual(first.hv, 940)
        XCTAssertNil(first.hb)
        XCTAssertEqual(first.hrc!, 68)
        XCTAssertNil(first.hrb)
    }

    func testTableLastRow() {
        let last = HardnessTable.rows[21]
        XCTAssertEqual(last.hv, 85)
        XCTAssertEqual(last.hb!, 81)
        XCTAssertNil(last.hrc)
        XCTAssertEqual(last.hrb!, 48)
    }

    // UTS is nil when hb is nil (no brinell available)
    func testUTS_nilWhenHBNil() {
        // HRC=68 is row [940, nil, 68, nil] — no HB
        let r = hardnessConvert(scale: .hrc, value: 68)
        XCTAssertNil(r.hb)
        XCTAssertNil(r.utsKsi)
    }
}
