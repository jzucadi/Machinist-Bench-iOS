import XCTest
@testable import MachinistsCore

final class ConverterTests: XCTestCase {

    // MARK: - Category structure

    func testCategoryCount() {
        XCTAssertEqual(Converter.categories.count, 12)
    }

    func testCategoryOrder() {
        let keys = Converter.categories.map(\.key)
        XCTAssertEqual(keys, ["len", "area", "vol", "wt", "force", "pr", "tq", "spd", "flow", "en", "pw", "tmp"])
    }

    func testLengthUnitsCount() {
        XCTAssertEqual(Converter.category("len")?.units.count, 12)
    }

    func testAreaUnitsCount() {
        XCTAssertEqual(Converter.category("area")?.units.count, 10)
    }

    func testVolumeUnitsCount() {
        XCTAssertEqual(Converter.category("vol")?.units.count, 13)
    }

    func testTemperatureCategory() {
        let tmp = Converter.category("tmp")
        XCTAssertNotNil(tmp)
        XCTAssertEqual(tmp?.units.count, 3)
        XCTAssertTrue(tmp?.isTemperature ?? false)
    }

    func testCategoryLookupMiss() {
        XCTAssertNil(Converter.category("bogus"))
    }

    // MARK: - Unit key presence

    func testThouKeyExists() {
        let len = Converter.category("len")!
        XCTAssertNotNil(len.units.first(where: { $0.key == "thou" }))
    }

    func testMicronKeyExists() {
        let len = Converter.category("len")!
        // real key from app.html is the µ character + m
        XCTAssertNotNil(len.units.first(where: { $0.key == "µm" }))
    }

    func testTemperatureKeysAreUppercase() {
        let tmp = Converter.category("tmp")!
        let keys = tmp.units.map(\.key)
        XCTAssertTrue(keys.contains("C"))
        XCTAssertTrue(keys.contains("F"))
        XCTAssertTrue(keys.contains("K"))
    }

    // MARK: - Factor-based conversions

    func testInchToMM() {
        let len = Converter.category("len")!
        XCTAssertEqual(convert(category: len, fromKey: "in", toKey: "mm", value: 1)!, 25.4, accuracy: 1e-9)
    }

    func testMMToInch() {
        let len = Converter.category("len")!
        let result = convert(category: len, fromKey: "mm", toKey: "in", value: 25.4)!
        XCTAssertEqual(result, 1.0, accuracy: 1e-9)
    }

    func testGalUSToLitre() {
        let vol = Converter.category("vol")!
        XCTAssertEqual(convert(category: vol, fromKey: "galUS", toKey: "l", value: 1)!, 3.785411784, accuracy: 1e-9)
    }

    func testLbfToNewton() {
        let force = Converter.category("force")!
        XCTAssertEqual(convert(category: force, fromKey: "lbf", toKey: "N", value: 1)!, 4.44822162, accuracy: 1e-9)
    }

    func testPsiToBar() {
        let pr = Converter.category("pr")!
        XCTAssertEqual(convert(category: pr, fromKey: "psi", toKey: "bar", value: 1)!, 0.0689476, accuracy: 1e-9)
    }

    func testHpToKW() {
        let pw = Converter.category("pw")!
        XCTAssertEqual(convert(category: pw, fromKey: "hp", toKey: "kW", value: 1)!, 0.745699872, accuracy: 1e-9)
    }

    func testMileToMM() {
        let len = Converter.category("len")!
        XCTAssertEqual(convert(category: len, fromKey: "mile", toKey: "mm", value: 1)!, 1_609_344, accuracy: 1e-9)
    }

    func testMicronToMM() {
        let len = Converter.category("len")!
        XCTAssertEqual(convert(category: len, fromKey: "µm", toKey: "mm", value: 1)!, 0.001, accuracy: 1e-12)
    }

    func testUnknownKeyReturnsNil() {
        let len = Converter.category("len")!
        XCTAssertNil(convert(category: len, fromKey: "bogus", toKey: "mm", value: 1))
    }

    // MARK: - Temperature conversions

    func testTempCtoF() {
        let t = Converter.category("tmp")!
        XCTAssertEqual(convert(category: t, fromKey: "C", toKey: "F", value: 100)!, 212, accuracy: 1e-9)
    }

    func testTempFtoC() {
        let t = Converter.category("tmp")!
        XCTAssertEqual(convert(category: t, fromKey: "F", toKey: "C", value: 32)!, 0, accuracy: 1e-9)
    }

    func testTempCtoK() {
        let t = Converter.category("tmp")!
        XCTAssertEqual(convert(category: t, fromKey: "C", toKey: "K", value: 100)!, 373.15, accuracy: 1e-9)
    }

    func testTempFtoK() {
        let t = Converter.category("tmp")!
        XCTAssertEqual(convert(category: t, fromKey: "F", toKey: "K", value: 32)!, 273.15, accuracy: 1e-9)
    }

    func testTempKtoC() {
        let t = Converter.category("tmp")!
        XCTAssertEqual(convert(category: t, fromKey: "K", toKey: "C", value: 273.15)!, 0.0, accuracy: 1e-9)
    }

    func testTempCtoCSameValue() {
        let t = Converter.category("tmp")!
        XCTAssertEqual(convert(category: t, fromKey: "C", toKey: "C", value: 25)!, 25.0, accuracy: 1e-9)
    }

    // MARK: - fmtConv formatting

    func testFmtNormal() {
        // 25.4 → toFixed(6) → "25.400000" → strip → "25.4"
        XCTAssertEqual(fmtConv(25.4, unitKey: "mm"), "25.4")
    }

    func testFmtThousandsFixed3() {
        // 1609344 >= 1000 → toFixed(3) → "1609344.000" → strip → "1609344"
        XCTAssertEqual(fmtConv(1_609_344, unitKey: "mm"), "1609344")
    }

    func testFmtScientific() {
        // 16093440 >= 1e7 → exponential(4) → "1.6093e+7"
        XCTAssertEqual(fmtConv(16_093_440, unitKey: "mm"), "1.6093e+7")
    }

    func testFmtSmallNumberScientific() {
        // 0.00001 != 0 and < 1e-4 → exponential
        let result = fmtConv(0.00001, unitKey: "Pa")
        XCTAssertTrue(result.contains("e"), "Expected scientific notation, got: \(result)")
    }

    func testFmtZero() {
        // 0 → toFixed(6) → "0.000000" → strip → "0"
        XCTAssertEqual(fmtConv(0, unitKey: "mm"), "0")
    }

    func testFmtThouSpecial() {
        // thou always 2dp regardless of magnitude
        XCTAssertEqual(fmtConv(1.0, unitKey: "thou"), "1.00")
        XCTAssertEqual(fmtConv(0.001, unitKey: "thou"), "0.00")
    }

    func testFmtMicronSpecial() {
        // µm always 2dp
        XCTAssertEqual(fmtConv(0.001, unitKey: "µm"), "0.00")
        XCTAssertEqual(fmtConv(25.4, unitKey: "µm"), "25.40")
    }

    func testFmtStripsTrailingDot() {
        // e.g. 1.0 → "1.000000" → strip → "1"  (no trailing ".")
        let result = fmtConv(1.0, unitKey: "mm")
        XCTAssertFalse(result.hasSuffix("."), "Should not end with '.', got: \(result)")
        XCTAssertEqual(result, "1")
    }

    func testFmtGalUSDisplayed() {
        // 3.785411784 → toFixed(6) → 3.785412 (due to rounding) → strip → "3.785412"
        XCTAssertEqual(fmtConv(3.785411784, unitKey: "l"), "3.785412")
    }
}
