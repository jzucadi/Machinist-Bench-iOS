// RefFasteningTests.swift — Row-count and spot-check tests for RefTables
// Verified against app.html via direct source inspection.

import XCTest
@testable import MachinistsCore

final class RefFasteningTests: XCTestCase {

    // MARK: - Loctite

    func testLoctiteRowCount() {
        XCTAssertEqual(RefTables.loctite.count, 6)
    }

    /// Spot-check: grade "242 / 243" is blue / medium strength.
    func testLoctite243IsBlue() {
        let row = RefTables.loctite.first { $0.grade == "242 / 243" }
        XCTAssertNotNil(row, "242 / 243 row must exist")
        XCTAssertEqual(row?.color,    "Blue")
        XCTAssertEqual(row?.strength, "Medium")
    }

    /// Spot-check: grade "271 / 272" is red / high strength.
    func testLoctiteRedIsHigh() {
        let row = RefTables.loctite.first { $0.grade == "271 / 272" }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.color,    "Red")
        XCTAssertEqual(row?.strength, "High")
    }

    // MARK: - BA Threads

    func testBARowCount() {
        XCTAssertEqual(RefTables.baThreads.count, 6)
    }

    /// Spot-check: 6 BA has major Ø 2.8 mm, pitch 0.53 mm, tap drill 2.3 mm.
    func testBA6MajorAndTapDrill() throws {
        let row = try XCTUnwrap(RefTables.baThreads.first { $0.size == "6 BA" })
        XCTAssertEqual(row.majorMM,  2.8,  accuracy: 1e-9)
        XCTAssertEqual(row.pitchMM,  0.53, accuracy: 1e-9)
        XCTAssertEqual(row.tapDrill, "2.3 mm")
    }

    /// Spot-check: 0 BA has approxTPI of 25.4.
    func testBA0TPI() throws {
        let row = try XCTUnwrap(RefTables.baThreads.first { $0.size == "0 BA" })
        XCTAssertEqual(row.approxTPI, 25.4, accuracy: 1e-9)
    }

    // MARK: - ME Threads

    func testMERowCount() {
        XCTAssertEqual(RefTables.meThreads.count, 6)
    }

    /// Spot-check: 1/4″ × 40 ME has 40 TPI and tap drill "5.5 mm".
    func testMEQuarterBy40() {
        let row = RefTables.meThreads.first { $0.size == "1/4″ × 40" }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.tpi,      40)
        XCTAssertEqual(row?.tapDrill, "5.5 mm")
    }

    // MARK: - BSW Threads

    func testBSWRowCount() {
        XCTAssertEqual(RefTables.bswThreads.count, 6)
    }

    /// Spot-check: 1/4″ BSW has 20 TPI and tap drill "5.1 mm".
    func testBSWQuarterInch() {
        let row = RefTables.bswThreads.first { $0.size == "1/4″ BSW" }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.tpi,      20)
        XCTAssertEqual(row?.tapDrill, "5.1 mm")
    }

    // MARK: - Silver Solder

    func testSilverSolderRowCount() {
        XCTAssertEqual(RefTables.silverSolder.count, 6)
    }

    /// Spot-check: "Easy-flo" / 55% flows at ~630 °C and is cadmium-free.
    func testEasyFloFlowTemp() {
        let row = RefTables.silverSolder.first { $0.filler.contains("Easy-flo") }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.flowPoint,  "~630 °C")
        XCTAssertEqual(row?.silverPct,  "55")
    }

    /// Spot-check: soft solder has "—" silver pct and ~190 °C flow point.
    func testSoftSolderRow() {
        let row = RefTables.silverSolder.first { $0.filler.contains("Soft solder") }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.silverPct, "—")
        XCTAssertEqual(row?.flowPoint, "~190 °C")
    }

    // MARK: - Morse Tapers

    func testMorseTaperRowCount() {
        XCTAssertEqual(RefTables.morseTapers.count, 7)
    }

    /// Spot-check: MT2 large-end Ø is 0.7000″ and plug depth is 2-9/16″.
    func testMT2Dimensions() {
        let row = RefTables.morseTapers.first { $0.size == "MT2" }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.largeDia,  "0.7000″")
        XCTAssertEqual(row?.smallDia,  "0.5720″")
        XCTAssertEqual(row?.plugDepth, "2-9/16″")
    }

    /// Spot-check: MT0 taper / ft is 0.62460″.
    func testMT0TaperPerFt() {
        let row = RefTables.morseTapers.first { $0.size == "MT0" }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.taperPerFt, "0.62460″")
    }

    // MARK: - ER Collets

    func testERColletRowCount() {
        XCTAssertEqual(RefTables.erCollets.count, 7)
    }

    /// Spot-check: ER32 capacity is "2–20 mm".
    func testER32Capacity() {
        let row = RefTables.erCollets.first { $0.series == "ER32" }
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.capacity, "2–20 mm")
    }

    /// Spot-check: ER8 is the smallest series with capacity "0.5–5 mm".
    func testER8IsSmallest() {
        XCTAssertEqual(RefTables.erCollets.first?.series, "ER8")
        XCTAssertEqual(RefTables.erCollets.first?.capacity, "0.5–5 mm")
    }

    // MARK: - Workholding Tapers

    func testWorkholdingTaperRowCount() {
        XCTAssertEqual(RefTables.workholdingTapers.count, 4)
    }

    /// Spot-check: R8 (Bridgeport) is the first workholding taper entry.
    func testR8IsFirst() {
        XCTAssertEqual(RefTables.workholdingTapers.first?.system, "R8 (Bridgeport)")
    }

    /// Spot-check: 7:24 entry exists and mentions "self-releasing".
    func testSevenTwentyFourIsPresent() {
        let row = RefTables.workholdingTapers.first { $0.system.contains("7:24") }
        XCTAssertNotNil(row)
        XCTAssertTrue(row?.keyFacts.contains("self-releasing") ?? false)
    }
}
