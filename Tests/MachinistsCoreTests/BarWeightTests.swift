import XCTest
@testable import MachinistsCore

final class BarWeightTests: XCTestCase {
    // Golden test 1: round, steel, d1=1 in, len=12 in
    // Expected: area≈0.785398, vol≈9.42478, pounds≈2.6729, kg≈1.2124, perFootLb≈2.6729
    func testRoundSteelGolden() {
        let result = barWeight(
            shape: .round,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        XCTAssertNotNil(result)
        guard let r = result else { return }

        XCTAssertEqual(r.areaSqIn, 0.785398, accuracy: 1e-6)
        XCTAssertEqual(r.volCuIn, 9.42478, accuracy: 1e-5)
        XCTAssertEqual(r.pounds, 2.6729, accuracy: 1e-4)
        XCTAssertEqual(r.kg, 1.2124, accuracy: 1e-4)
        XCTAssertEqual(r.perFootLb, 2.6729, accuracy: 1e-4)
        XCTAssertEqual(r.perMeterKg, r.perFootLb * 1.48816, accuracy: 1e-9) // web v4.46 perMeterKg
        XCTAssertEqual(r.perMeterKg, 3.9777, accuracy: 1e-3)
    }

    // Golden test 2: hex, steel, d1=1 in (AF), len=12 in
    // Expected: area≈0.866025, pounds≈2.9473
    func testHexSteelGolden() {
        let result = barWeight(
            shape: .hex,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        XCTAssertNotNil(result)
        guard let r = result else { return }

        XCTAssertEqual(r.areaSqIn, 0.866025, accuracy: 1e-3)
        XCTAssertEqual(r.pounds, 2.9473, accuracy: 1e-3)
    }

    // Test: square shape
    func testSquareSteel() {
        let result = barWeight(
            shape: .square,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        XCTAssertNotNil(result)
        guard let r = result else { return }

        // area = 1.0² = 1.0
        XCTAssertEqual(r.areaSqIn, 1.0, accuracy: 1e-6)
        // vol = 1.0 * 12 = 12.0
        XCTAssertEqual(r.volCuIn, 12.0, accuracy: 1e-6)
        // lb = 12.0 * 0.2836 = 3.4032
        XCTAssertEqual(r.pounds, 3.4032, accuracy: 1e-4)
    }

    // Test: rect shape (width=1, height=0.5, len=12)
    func testRectSteel() {
        let result = barWeight(
            shape: .rect,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.5,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        XCTAssertNotNil(result)
        guard let r = result else { return }

        // area = 1.0 * 0.5 = 0.5
        XCTAssertEqual(r.areaSqIn, 0.5, accuracy: 1e-6)
        // vol = 0.5 * 12 = 6.0
        XCTAssertEqual(r.volCuIn, 6.0, accuracy: 1e-6)
        // lb = 6.0 * 0.2836 = 1.7016
        XCTAssertEqual(r.pounds, 1.7016, accuracy: 1e-4)
    }

    // Test: tube (OD=1, wall=0.125, len=12)
    // ID = 1.0 - 2*0.125 = 0.75
    // area = (π/4) * (1.0² - 0.75²) = (π/4) * (1.0 - 0.5625) = (π/4) * 0.4375
    func testTubeSteel() {
        let result = barWeight(
            shape: .tube,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.125,
            lengthIn: 12.0
        )

        XCTAssertNotNil(result)
        guard let r = result else { return }

        let expectedArea = (Double.pi / 4.0) * (1.0 * 1.0 - 0.75 * 0.75)
        XCTAssertEqual(r.areaSqIn, expectedArea, accuracy: 1e-6)
    }

    // Test: material not found returns nil
    func testMissingMaterialReturnsNil() {
        let result = barWeight(
            shape: .round,
            materialKey: "unobtainium",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        XCTAssertNil(result)
    }

    // Test: all materials from BAR_DENS
    func testAllMaterials() {
        let materials = ["steel", "stainless", "aluminum", "brass", "bronze", "copper", "castiron", "titanium", "lead", "nylon"]

        for mat in materials {
            let result = barWeight(
                shape: .round,
                materialKey: mat,
                d1In: 1.0,
                d2In: 0.0,
                wallIn: 0.0,
                lengthIn: 12.0
            )
            XCTAssertNotNil(result, "Material '\(mat)' should be found")
        }
    }

    // Test: per-foot conversion
    // perFootLb = area * 12 * density
    func testPerFootLbFormula() {
        let result = barWeight(
            shape: .round,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        guard let r = result else { return }
        let expectedPerFoot = r.areaSqIn * 12.0 * 0.2836
        XCTAssertEqual(r.perFootLb, expectedPerFoot, accuracy: 1e-6)
    }

    // Test: kg conversion
    // kg = lb * 0.453592
    func testKgConversion() {
        let result = barWeight(
            shape: .round,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        guard let r = result else { return }
        let expectedKg = r.pounds * 0.453592
        XCTAssertEqual(r.kg, expectedKg, accuracy: 1e-6)
    }

    // Test: zero length
    func testZeroLength() {
        let result = barWeight(
            shape: .round,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 0.0
        )

        guard let r = result else { return }
        XCTAssertEqual(r.volCuIn, 0.0, accuracy: 1e-12)
        XCTAssertEqual(r.pounds, 0.0, accuracy: 1e-12)
    }

    // Test: aluminum density (should be lighter than steel)
    func testAluminumLighterThanSteel() {
        let roundSteel = barWeight(
            shape: .round,
            materialKey: "steel",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        let roundAluminum = barWeight(
            shape: .round,
            materialKey: "aluminum",
            d1In: 1.0,
            d2In: 0.0,
            wallIn: 0.0,
            lengthIn: 12.0
        )

        XCTAssertNotNil(roundSteel)
        XCTAssertNotNil(roundAluminum)
        XCTAssertLessThan(roundAluminum!.pounds, roundSteel!.pounds)
    }
}
