// ToolingRefTests.swift — TDD tests for Task A2: drill, file, GD&T tables + MarkFinder
// Golden values from m7-extraction.md §3, §5, §6 (node-verified 2026-07-06).
// Fix pass A2 (2026-07-07): MarkFinder meanings + search rule updated to web-verbatim.

import XCTest
@testable import MachinistsCore

final class ToolingRefTests: XCTestCase {

    // MARK: - Table count assertions

    func testDrillPointAnglesCount() {
        XCTAssertEqual(ToolingRef.drillPointAngles.count, 6,
                       "§3 Point Angle by Material: 6 rows")
    }

    func testDrillWebThicknessCount() {
        XCTAssertEqual(ToolingRef.drillWebThickness.count, 5,
                       "§3 Web Thickness by Drill Size: 5 rows")
    }

    func testFileShapesCount() {
        XCTAssertEqual(ToolingRef.fileShapes.count, 11,
                       "§5 FileXSection: 11 shape cards")
    }

    func testFileGradesCount() {
        XCTAssertEqual(ToolingRef.fileGrades.count, 5,
                       "§5 Cut / Coarseness Table: 5 rows")
    }

    func testGdtNotationCount() {
        XCTAssertEqual(ToolingRef.gdtNotation.count, 7,
                       "§6.5 Drawing notation table: 7 rows")
    }

    func testGdtCharacteristicsCount() {
        XCTAssertEqual(ToolingRef.gdtCharacteristics.count, 14,
                       "§6.5 GD&T 14 characteristics")
    }

    func testGdtModifiersCount() {
        XCTAssertEqual(ToolingRef.gdtModifiers.count, 7,
                       "§6.5 Material modifiers: 7 rows")
    }

    func testMarkFinderAllCount() {
        XCTAssertEqual(MarkFinder.all.count, 119,
                       "§6.4 MarkFinder: 119 entries (node-verified)")
    }

    // MARK: - MarkFinder category counts

    func testMarkFinderAbbrCount() {
        let abbrs = MarkFinder.all.filter { $0.context == "abbr" }
        XCTAssertEqual(abbrs.count, 67, "67 abbreviations")
    }

    func testMarkFinderSymCount() {
        let syms = MarkFinder.all.filter { $0.context == "sym" }
        XCTAssertEqual(syms.count, 35, "35 symbols (9 drawing + 26 math)")
    }

    func testMarkFinderStdCount() {
        let stds = MarkFinder.all.filter { $0.context == "std" }
        XCTAssertEqual(stds.count, 17, "17 standards bodies")
    }

    // MARK: - GD&T characteristics structural tests

    /// Flatness must be one of the 14 GD&T characteristics (key = "flat")
    func testFlatnessInCharacteristics() {
        let flat = ToolingRef.gdtCharacteristics.first { $0.key == "flat" }
        XCTAssertNotNil(flat, "key 'flat' must be present in gdtCharacteristics")
        XCTAssertEqual(flat?.name, "Flatness")
        XCTAssertEqual(flat?.family, "FORM \u{2014} no datum")
    }

    /// All 14 keys from §6.2 / §6.5 must be present
    func testGdtCharacteristicKeys() {
        let keys = Set(ToolingRef.gdtCharacteristics.map(\.key))
        let expected = Set(["straight", "flat", "circ", "cyl",
                            "par", "perp", "ang",
                            "profL", "profS",
                            "pos", "conc", "symm",
                            "runC", "runT"])
        XCTAssertEqual(keys, expected, "all 14 GD&T characteristic keys must be present")
    }

    /// 5 distinct families in the characteristics table
    func testGdtCharacteristicsHas5Families() {
        let families = Set(ToolingRef.gdtCharacteristics.map(\.family))
        XCTAssertEqual(families.count, 5, "FORM / ORIENTATION / PROFILE / LOCATION / RUNOUT")
    }

    // MARK: - MarkFinder search
    // Golden cases computed via node against verbatim app-new.html DATA (fix pass A2 2026-07-07).

    /// Empty query returns [] — web rule: if (!s) return []
    func testSearchEmptyReturnsEmpty() {
        let result = MarkFinder.search("")
        XCTAssertTrue(result.isEmpty, "web rule: empty query returns [], not all rows")
    }

    /// Whitespace-only query returns [] (web trims before the empty check)
    func testSearchWhitespaceReturnsEmpty() {
        let result = MarkFinder.search("   ")
        XCTAssertTrue(result.isEmpty, "whitespace-only query trims to empty → []")
    }

    /// Non-matching query returns empty
    func testSearchNoMatch() {
        let result = MarkFinder.search("xyzxyzxyz999qqq")
        XCTAssertTrue(result.isEmpty, "non-matching query must return empty")
    }

    /// search("cbore") returns [] — web node golden: no raw substring match for "cbore" in "c'bore"
    func testSearchCbore() {
        let result = MarkFinder.search("cbore")
        XCTAssertTrue(result.isEmpty,
            "web golden (node-verified): search('cbore') = [] — 'cbore' ∉ \"c'bore\" (apostrophe breaks it)")
    }

    /// search("counterbore") finds C'BORE (meaning match) — alternative to "cbore"
    func testSearchCounterbore() throws {
        let result = MarkFinder.search("counterbore")
        let bore = try XCTUnwrap(result.first { $0.mark == "C'BORE" },
                                  "search('counterbore') must include C'BORE via meaning match")
        XCTAssertEqual(bore.meaning, "Counterbore")
        XCTAssertEqual(bore.context, "abbr")
    }

    /// search("flat") golden: 1 result, A/F row (node-verified against web DATA)
    func testSearchFlat() throws {
        let result = MarkFinder.search("flat")
        XCTAssertEqual(result.count, 1, "web golden: search('flat') → exactly 1 result")
        let af = try XCTUnwrap(result.first { $0.mark == "A/F" },
                                "web golden: search('flat') must return A/F row")
        XCTAssertEqual(af.meaning, "Across flats")
        XCTAssertEqual(af.context, "abbr")
    }

    /// Case-insensitive: "iso" and "ISO" return the same rows
    func testSearchCaseInsensitive() {
        let upper = MarkFinder.search("ISO")
        let lower = MarkFinder.search("iso")
        XCTAssertEqual(upper.map(\.mark), lower.map(\.mark),
                       "search must be case-insensitive")
    }

    /// search("DIA") finds the DIA abbreviation
    func testSearchDIA() throws {
        let result = MarkFinder.search("DIA")
        let dia = try XCTUnwrap(result.first { $0.mark == "DIA" },
                                 "search('DIA') must include DIA row")
        XCTAssertEqual(dia.context, "abbr")
    }

    /// search("ISO") finds the ISO standards body
    func testSearchISO() throws {
        let result = MarkFinder.search("ISO")
        let iso = try XCTUnwrap(result.first { $0.mark == "ISO" },
                                 "search('ISO') must include ISO row")
        XCTAssertEqual(iso.context, "std")
    }

    /// Search result capped at 40 (broad query like "e" hits many rows)
    func testSearchLimit() {
        // "e" appears in many abbreviation meanings — result must be ≤ 40
        let result = MarkFinder.search("e")
        XCTAssertLessThanOrEqual(result.count, 40, "search is capped at 40 results")
    }

    // MARK: - MarkFinder row ordering / integrity spot-checks
    // Meanings are verbatim from app-new.html DATA (fix pass A2, node-verified 2026-07-07).

    /// First row: A/F, "Across flats", abbr (node: DATA[0])
    func testMarkFinderFirstRow() throws {
        let first = try XCTUnwrap(MarkFinder.all.first, "MarkFinder.all must not be empty")
        XCTAssertEqual(first.mark, "A/F")
        XCTAssertEqual(first.meaning, "Across flats")
        XCTAssertEqual(first.context, "abbr")
    }

    /// Last row: AMS, "Aerospace Material Specifications", std (node: DATA[118])
    func testMarkFinderLastRow() throws {
        let last = try XCTUnwrap(MarkFinder.all.last, "MarkFinder.all must not be empty")
        XCTAssertEqual(last.mark, "AMS")
        XCTAssertEqual(last.meaning, "Aerospace Material Specifications")
        XCTAssertEqual(last.context, "std")
    }

    /// Middle spot: index 20 = GAL, "Gallon", abbr (node: DATA[20])
    func testMarkFinderRow20() throws {
        let row = MarkFinder.all[20]
        XCTAssertEqual(row.mark, "GAL")
        XCTAssertEqual(row.meaning, "Gallon")
        XCTAssertEqual(row.context, "abbr")
    }

    /// Middle spot: index 40 = MATL, "Material", abbr (node: DATA[40])
    func testMarkFinderRow40() throws {
        let row = MarkFinder.all[40]
        XCTAssertEqual(row.mark, "MATL")
        XCTAssertEqual(row.meaning, "Material")
        XCTAssertEqual(row.context, "abbr")
    }

    /// Middle spot: index 60 = STD, "Standard", abbr (node: DATA[60])
    func testMarkFinderRow60() throws {
        let row = MarkFinder.all[60]
        XCTAssertEqual(row.mark, "STD")
        XCTAssertEqual(row.meaning, "Standard")
        XCTAssertEqual(row.context, "abbr")
    }

    /// Middle spot: index 80 = ÷, "Divided by", sym (node: DATA[80])
    func testMarkFinderRow80() throws {
        let row = MarkFinder.all[80]
        XCTAssertEqual(row.mark, "\u{00F7}")
        XCTAssertEqual(row.meaning, "Divided by")
        XCTAssertEqual(row.context, "sym")
    }

    /// Middle spot: index 100 = ⊥, "Perpendicular to", sym (node: DATA[100])
    func testMarkFinderRow100() throws {
        let row = MarkFinder.all[100]
        XCTAssertEqual(row.mark, "\u{22A5}")
        XCTAssertEqual(row.meaning, "Perpendicular to")
        XCTAssertEqual(row.context, "sym")
    }

    /// The ISO row is present and verbatim (node: DATA[102])
    func testMarkFinderISOEntry() throws {
        let iso = try XCTUnwrap(MarkFinder.all.first { $0.mark == "ISO" })
        XCTAssertEqual(iso.context, "std")
        XCTAssertEqual(iso.meaning, "International Organization for Standardization")
    }

    /// The ⌴ drawing symbol row: meaning is "Counterbore / spotface" (node: DATA[70])
    func testMarkFinderCounterboreSymbol() throws {
        let cbore = try XCTUnwrap(MarkFinder.all.first { $0.mark == "\u{2334}" },
                                   "⌴ (counterbore symbol) must be in MarkFinder.all")
        XCTAssertEqual(cbore.context, "sym")
        XCTAssertEqual(cbore.meaning, "Counterbore / spotface")
    }

    /// REF meaning is the full web string including the parenthetical (node: DATA[51])
    func testMarkFinderREFMeaning() throws {
        let ref = try XCTUnwrap(MarkFinder.all.first { $0.mark == "REF" })
        XCTAssertEqual(ref.meaning, "Reference dimension \u{2014} info only, not inspected")
    }

    /// ASME meaning includes the full parenthetical (node: DATA[115])
    func testMarkFinderASMEMeaning() throws {
        let asme = try XCTUnwrap(MarkFinder.all.first { $0.mark == "ASME" })
        XCTAssertEqual(asme.meaning, "American Society of Mechanical Engineers (Y14.5 GD\u{0026}T, B-series)")
    }

    // MARK: - Drill point angles spot-checks

    /// General-purpose steel: 118° included, notes = standard catch-all
    func testDrillPointAnglesGeneralSteel() throws {
        let row = try XCTUnwrap(
            ToolingRef.drillPointAngles.first { $0.material == "General-purpose steel" },
            "General-purpose steel must be in drillPointAngles"
        )
        XCTAssertEqual(row.pointAngle, "118\u{00B0}")
        XCTAssertEqual(row.notes, "The standard catch-all grind")
    }

    /// Cast iron row present
    func testDrillPointAnglesCastIron() {
        XCTAssertNotNil(
            ToolingRef.drillPointAngles.first { $0.material.contains("Cast iron") },
            "Cast iron row must be present"
        )
    }

    // MARK: - Drill web thickness spot-checks

    /// 1/4″ → 17%
    func testDrillWebThicknessQuarterInch() throws {
        let row = try XCTUnwrap(
            ToolingRef.drillWebThickness.first { $0.drillDiam == "1/4\u{2033}" },
            "1/4\u{2033} drill must be in drillWebThickness"
        )
        XCTAssertEqual(row.webPct, "17%")
    }

    // MARK: - File shapes spot-checks

    /// "flat" shape present with expected name
    func testFileShapesFlat() throws {
        let row = try XCTUnwrap(
            ToolingRef.fileShapes.first { $0.shapeKey == "flat" },
            "'flat' shape must be in fileShapes"
        )
        XCTAssertEqual(row.name, "Flat")
    }

    /// "round" shape present
    func testFileShapesRound() {
        XCTAssertNotNil(
            ToolingRef.fileShapes.first { $0.shapeKey == "round" },
            "'round' shape must be in fileShapes"
        )
    }

    // MARK: - File grades spot-checks

    /// Dead-smooth is "Finest" coarseness
    func testFileGradesDeadSmooth() throws {
        let row = try XCTUnwrap(
            ToolingRef.fileGrades.first { $0.cut == "Dead-smooth" },
            "Dead-smooth must be in fileGrades"
        )
        XCTAssertEqual(row.coarseness, "Finest")
    }

    /// Grades ordered: Bastard before Second-cut before Smooth
    func testFileGradesOrder() {
        let keys = ToolingRef.fileGrades.map(\.cut)
        let bastard   = keys.firstIndex(of: "Bastard")
        let secondCut = keys.firstIndex(of: "Second-cut")
        let smooth    = keys.firstIndex(of: "Smooth")
        XCTAssertNotNil(bastard)
        XCTAssertNotNil(secondCut)
        XCTAssertNotNil(smooth)
        if let b = bastard, let s = secondCut, let sm = smooth {
            XCTAssertLessThan(b, s, "Bastard before Second-cut")
            XCTAssertLessThan(s, sm, "Second-cut before Smooth")
        }
    }

    // MARK: - GD&T notation spot-checks

    /// THRU notation present
    func testGdtNotationThru() throws {
        let row = try XCTUnwrap(
            ToolingRef.gdtNotation.first { $0.notation == "THRU" },
            "THRU must be in gdtNotation"
        )
        XCTAssertFalse(row.meaning.isEmpty)
    }

    /// Notation table contains a row with ⌴ (counterbore symbol)
    func testGdtNotationCounterbore() {
        XCTAssertNotNil(
            ToolingRef.gdtNotation.first { $0.notation.contains("\u{2334}") },
            "A notation row must reference the counterbore symbol ⌴"
        )
    }

    // MARK: - GD&T characteristics spot-checks

    /// Position (pos) is in LOCATION family
    func testGdtCharacteristicPosition() throws {
        let row = try XCTUnwrap(
            ToolingRef.gdtCharacteristics.first { $0.key == "pos" },
            "'pos' must be in gdtCharacteristics"
        )
        XCTAssertEqual(row.name, "Position")
        XCTAssertTrue(row.family.contains("LOCATION"),
                      "Position must be in LOCATION family; got '\(row.family)'")
    }

    /// Cylindricity (cyl) is in FORM family
    func testGdtCharacteristicCylindricity() throws {
        let row = try XCTUnwrap(ToolingRef.gdtCharacteristics.first { $0.key == "cyl" })
        XCTAssertEqual(row.name, "Cylindricity")
        XCTAssertTrue(row.family.contains("FORM"))
    }

    // MARK: - GD&T modifiers spot-checks

    /// MMC modifier present with Ⓜ symbol
    func testGdtModifiersMMC() throws {
        let row = try XCTUnwrap(
            ToolingRef.gdtModifiers.first { $0.symbol.contains("MMC") },
            "MMC modifier must be in gdtModifiers"
        )
        XCTAssertEqual(row.name, "Maximum Material Condition")
        XCTAssertFalse(row.meaning.isEmpty)
    }

    /// All 7 modifier symbols are distinct
    func testGdtModifiersDistinctSymbols() {
        let symbols = ToolingRef.gdtModifiers.map(\.symbol)
        XCTAssertEqual(symbols.count, Set(symbols).count, "modifier symbols must be distinct")
    }
}
