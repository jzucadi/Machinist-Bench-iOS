import XCTest
@testable import MachinistsCore

// MARK: - TDD: RED — all tests written before any implementation exists.
// These tests verify the ThreadFinder data + calc against the JS source of truth
// in app.html (FamBlock formula, THREAD_RAW data, TORQUE_DATA, CameraBayonets).

final class ThreadFinderTests: XCTestCase {

    // MARK: - ThreadFamilies.all — count and spot checks

    func testThreadFamiliesAllCountAtLeast85() {
        // app.html THREAD_RAW has 22(un)+15(metric)+9(bsw)+6(bsf)+10(bsb)+6(bsc)+6(bsp)+
        //   6(npt)+11(ba)+11(thury)+8(me)+16(photo) = 126 entries total
        XCTAssertGreaterThanOrEqual(ThreadFamilies.all.count, 85)
    }

    func testThreadFamiliesAllContains12Families() {
        let families = Set(ThreadFamilies.all.map { $0.family })
        XCTAssertEqual(families.count, 12)
    }

    func testUnifiedFamilyMember_Quarter20UNC() {
        let t = ThreadFamilies.all.first { $0.name == "1/4-20 UNC" }
        XCTAssertNotNil(t, "Expected '1/4-20 UNC' in ThreadFamilies.all")
        XCTAssertEqual(t!.family, "un")
        // major dia in inches = 6.35 / 25.4 = 0.25 exactly
        XCTAssertEqual(t!.majorIn, 0.25, accuracy: 1e-6)
        // pitchIn for 20 TPI = 1/20 = 0.05"
        XCTAssertEqual(t!.pitchIn, 0.05, accuracy: 1e-6)
    }

    func testMetricFamilyMember_M6x1() {
        let t = ThreadFamilies.all.first { $0.name == "M6 \u{D7} 1.0" }
        XCTAssertNotNil(t, "Expected 'M6 × 1.0' in ThreadFamilies.all")
        XCTAssertEqual(t!.family, "metric")
        // major = 6 mm → 6/25.4 inches
        XCTAssertEqual(t!.majorIn, 6.0 / 25.4, accuracy: 1e-9)
        // pitch = 1 mm → 1/25.4 inches
        XCTAssertEqual(t!.pitchIn, 1.0 / 25.4, accuracy: 1e-9)
    }

    func testPhotoFamilyPresent() {
        let photoThreads = ThreadFamilies.all.filter { $0.family == "photo" }
        XCTAssertGreaterThanOrEqual(photoThreads.count, 14, "Photographic family should have 14+ entries")
    }

    func testBSCFamilyPresent() {
        let bsc = ThreadFamilies.all.filter { $0.family == "bsc" }
        XCTAssertEqual(bsc.count, 6)
    }

    func testThuryFamilyCount() {
        let thury = ThreadFamilies.all.filter { $0.family == "thury" }
        XCTAssertEqual(thury.count, 11)
    }

    // MARK: - tapDrillIn formula (node-verified against JS)
    // JS: tapMm = t.d - 0.75 * K * t.p   (K=1.299 for 60° UN threads)
    // => tapIn = majorIn - (engagementPct/100) * K * pitchIn
    // where K defaults to 1.299 (60° form, the dominant / UN family)
    //
    // 1/4-20 UNC: major=6.35mm=0.25", pitch=1.27mm=0.05"
    // tapMm = 6.35 - 0.75 * 1.299 * 1.27 = 6.35 - 1.23528225 = 5.11471775 mm
    // tapIn = 5.11471775 / 25.4 = 0.20137 "
    // Swift: tapDrillIn(majorIn:0.25, pitchIn:0.05, engagementPct:75) ≈ 0.20137

    func testTapDrillIn_Quarter20UNC_75pct() {
        let result = tapDrillIn(majorIn: 0.25, pitchIn: 0.05, engagementPct: 75.0)
        // JS golden: 0.25 - 0.75 * 1.299 * 0.05 = 0.25 - 0.048713 = 0.201288"
        XCTAssertEqual(result, 0.25 - 0.75 * 1.299 * 0.05, accuracy: 1e-9)
    }

    func testTapDrillIn_ScalesWithEngagement() {
        let r75 = tapDrillIn(majorIn: 0.25, pitchIn: 0.05, engagementPct: 75.0)
        let r100 = tapDrillIn(majorIn: 0.25, pitchIn: 0.05, engagementPct: 100.0)
        XCTAssertLessThan(r100, r75, "Higher engagement = smaller tap drill")
    }

    func testTapDrillIn_Quarter28UNF_75pct() {
        // 1/4-28 UNF: major=6.35mm=0.25", pitch=0.907mm=0.907/25.4"
        let pitchIn = 0.907 / 25.4
        let result = tapDrillIn(majorIn: 0.25, pitchIn: pitchIn, engagementPct: 75.0)
        let expected = 0.25 - 0.75 * 1.299 * pitchIn
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    // MARK: - threadClearanceIn (clearanceDrillIn)
    // JS: allow = d_mm <= 5 ? 0.2 : d_mm <= 12 ? 0.4 : 0.6
    //     clrMm = d_mm + allow
    // In inches: clrIn = (d_mm + allow) / 25.4
    //
    // 1/4-20 UNC: d_mm=6.35 → allow=0.4 → clrMm=6.75 → clrIn=6.75/25.4=0.2657"
    // M2×0.4:     d_mm=2.0  → allow=0.2 → clrMm=2.2  → clrIn=2.2/25.4=0.0866"
    // 1/2-13 UNC: d_mm=12.7 → allow=0.6 → clrMm=13.3 → clrIn=13.3/25.4=0.5236"

    func testClearanceDrill_Quarter20UNC() {
        // majorIn = 6.35/25.4 = 0.25", d_mm = 6.35 → allow = 0.4 mm
        let result = threadClearanceIn(majorIn: 0.25)
        let expected = (6.35 + 0.4) / 25.4
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testClearanceDrill_SmallThread_M2() {
        // M2: majorIn = 2.0/25.4, d_mm = 2.0 → allow = 0.2 mm (<=5)
        let result = threadClearanceIn(majorIn: 2.0 / 25.4)
        let expected = (2.0 + 0.2) / 25.4
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testClearanceDrill_LargeThread_Half13() {
        // 1/2-13: majorIn = 12.7/25.4 = 0.5", d_mm = 12.7 → allow = 0.6 mm (>12)
        let result = threadClearanceIn(majorIn: 0.5)
        let expected = (12.7 + 0.6) / 25.4
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    // MARK: - nearestThreads

    func testNearestThreads_Quarter_IncludesQuarter20UNC() {
        let results = nearestThreads(toDiaIn: 0.25)
        let names = results.map { $0.name }
        XCTAssertTrue(names.contains("1/4-20 UNC"), "nearestThreads(0.25) must include 1/4-20 UNC; got: \(names)")
    }

    func testNearestThreads_Quarter_Returns6ByDefault() {
        let results = nearestThreads(toDiaIn: 0.25)
        XCTAssertEqual(results.count, 6)
    }

    func testNearestThreads_Quarter_AllAtDeltaZero() {
        // Multiple threads share 6.35mm (0.25") major: 1/4-20, 1/4-28, 1/4 BSW, 1/4×26 BSB, 1/4×26 BSC, 1/4×40 ME, 1/4×32 ME, 1/4-20 (camera)
        let results = nearestThreads(toDiaIn: 0.25)
        let allAtZero = results.allSatisfy { abs($0.majorIn - 0.25) < 1e-6 }
        XCTAssertTrue(allAtZero, "All 6 nearest threads to 0.25\" should be at delta=0")
    }

    func testNearestThreads_CustomCount() {
        let results = nearestThreads(toDiaIn: 0.25, count: 3)
        XCTAssertEqual(results.count, 3)
    }

    func testNearestThreads_SortedByDelta() {
        let results = nearestThreads(toDiaIn: 0.20)
        // Results should be sorted by |majorIn - 0.20|
        let deltas = results.map { abs($0.majorIn - 0.20) }
        for i in 1..<deltas.count {
            XCTAssertLessThanOrEqual(deltas[i-1], deltas[i], "Results should be sorted by ascending delta")
        }
    }

    // MARK: - TorqueCharts spot values

    func testInchTorqueChart_Quarter20_Steel() {
        let row = TorqueCharts.inch.first { $0.thread == "1/4-20" }
        XCTAssertNotNil(row, "1/4-20 should be in inch torque chart")
        XCTAssertEqual(row!.steelValue, 8.0, accuracy: 1e-9)
        XCTAssertEqual(row!.unit, "ft")
    }

    func testInchTorqueChart_Pound4_40_Steel() {
        let row = TorqueCharts.inch.first { $0.thread == "#4-40" }
        XCTAssertNotNil(row, "#4-40 should be in inch torque chart")
        XCTAssertEqual(row!.steelValue, 9.0, accuracy: 1e-9)
        XCTAssertEqual(row!.unit, "in")
    }

    func testInchTorqueChart_Count() {
        XCTAssertEqual(TorqueCharts.inch.count, 18)
    }

    func testMetricTorqueChart_M6_Steel() {
        let row = TorqueCharts.metric.first { $0.thread == "M6" }
        XCTAssertNotNil(row, "M6 should be in metric torque chart")
        XCTAssertEqual(row!.steelValue, 7.7, accuracy: 1e-9)
        XCTAssertEqual(row!.unit, "ft")
    }

    func testMetricTorqueChart_Count() {
        XCTAssertEqual(TorqueCharts.metric.count, 7)
    }

    // MARK: - CameraMounts spot values

    func testCameraMounts_Count() {
        XCTAssertEqual(CameraMounts.all.count, 10)
    }

    func testCameraMounts_NikonF_Bayonet() {
        let m = CameraMounts.all.first { $0.mount == "Nikon F" }
        XCTAssertNotNil(m)
        XCTAssertEqual(m!.mountType, "Bayonet")
        XCTAssertEqual(m!.flangeDistMm, "46.5 mm")
    }

    func testCameraMounts_CMount_Thread() {
        let m = CameraMounts.all.first { $0.mount == "C-mount" }
        XCTAssertNotNil(m)
        XCTAssertEqual(m!.mountType, "Screw")
        XCTAssertEqual(m!.threadOrThroat, "1\"-32")
    }

    func testCameraMounts_M42PentaxScrew() {
        let m = CameraMounts.all.first { $0.mount == "M42 (Pentax screw)" }
        XCTAssertNotNil(m)
        XCTAssertEqual(m!.mountType, "Screw")
    }
}
