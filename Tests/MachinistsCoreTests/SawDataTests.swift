import XCTest
@testable import MachinistsCore

final class SawDataTests: XCTestCase {

    // MARK: - SawData.materials

    func testMaterialCount() {
        XCTAssertEqual(SawData.materials.count, 37)
    }

    func testMaterialsFirstIsMild() {
        XCTAssertEqual(SawData.materials.first?.key, "mild")
    }

    func testMaterialsLastIsWoodResaw() {
        XCTAssertEqual(SawData.materials.last?.key, "wdresaw")
    }

    func testMildSteelFields() {
        let m = SawData.materials.first { $0.key == "mild" }!
        XCTAssertEqual(m.name, "Steel \u{2014} mild / low-carbon (1018, A36)")
        XCTAssertEqual(m.kind, "metal")
        XCTAssertEqual(m.sfm, [300, 280, 260, 250])
        XCTAssertNil(m.range)
    }

    func testAluminumSFM() {
        let m = SawData.materials.first { $0.key == "alum" }!
        XCTAssertEqual(m.sfm, [800, 700, 600, 500])
        XCTAssertEqual(m.kind, "metal")
    }

    func testTitaniumSFM() {
        let m = SawData.materials.first { $0.key == "ti" }!
        XCTAssertEqual(m.sfm, [65, 50, 50, 40])
    }

    func testPlasticHardRangeNoSFM() {
        let m = SawData.materials.first { $0.key == "plhard" }!
        XCTAssertEqual(m.kind, "plastic")
        XCTAssertEqual(m.sfm, [])
        XCTAssertEqual(m.range, 500...1000)
    }

    func testWoodSoftRangeNoSFM() {
        let m = SawData.materials.first { $0.key == "wdsoft" }!
        XCTAssertEqual(m.kind, "wood")
        XCTAssertEqual(m.sfm, [])
        XCTAssertEqual(m.range, 2000...4000)
    }

    func testNoteNotEmpty() {
        let m = SawData.materials.first { $0.key == "mild" }!
        XCTAssertFalse(m.note.isEmpty)
    }

    // MARK: - SawData.diaPitch

    func testDiaPitchCount() {
        XCTAssertEqual(SawData.diaPitch.count, 10)
    }

    func testDiaPitchFirstRow() {
        let row = SawData.diaPitch[0]
        XCTAssertEqual(row.maxIn, 0.125, accuracy: 1e-9)
        XCTAssertEqual(row.label, "18\u{2013}24")
        XCTAssertEqual(row.avg, 21.0, accuracy: 1e-9)
    }

    func testDiaPitchRow3() {
        // [1, "8-12", 10]
        let row = SawData.diaPitch[3]
        XCTAssertEqual(row.maxIn, 1.0, accuracy: 1e-9)
        XCTAssertEqual(row.label, "8\u{2013}12")
        XCTAssertEqual(row.avg, 10.0, accuracy: 1e-9)
    }

    func testDiaPitchLastRow() {
        let row = SawData.diaPitch[9]
        XCTAssertEqual(row.maxIn, 1e9, accuracy: 1e-3)
        XCTAssertEqual(row.label, "1.4\u{2013}2")
        XCTAssertEqual(row.avg, 1.7, accuracy: 1e-9)
    }
}
