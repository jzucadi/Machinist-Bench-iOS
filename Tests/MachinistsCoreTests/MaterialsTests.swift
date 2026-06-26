import XCTest
@testable import MachinistsCore

final class MaterialsTests: XCTestCase {
    func testCount() { XCTAssertEqual(Materials.all.count, 19) }

    func testOrderFirstAndLast() {
        XCTAssertEqual(Materials.all.first?.id, "alum")
        XCTAssertEqual(Materials.all.last?.id, "plastic")
    }

    func testLowCarbon() {
        let m = Materials.byID("lowc")!
        XCTAssertEqual(m.name, "Low-Carbon Steel (1018)")
        XCTAssertEqual(m.carbideSFM, 350...550)
        XCTAssertEqual(m.feedIPR, 0.012, accuracy: 1e-9)
        XCTAssertEqual(m.kp, 1.0, accuracy: 1e-9)
    }

    func testTitanium() {
        let m = Materials.byID("ti")!
        XCTAssertEqual(m.hssSFM, 30...50)
        XCTAssertEqual(m.kp, 1.2, accuracy: 1e-9)
    }

    func testInconel() {
        XCTAssertEqual(Materials.byID("inconel")!.kp, 2.2, accuracy: 1e-9)
    }

    func testLowCarbonOperationFields() {
        let m = Materials.byID("lowc")!
        XCTAssertEqual(m.drillSFM, 60...100)
        XCTAssertEqual(m.drillCarbideSFM, 200...350)
        XCTAssertEqual(m.millSFM, 60...110)
        XCTAssertEqual(m.millCarbideSFM, 300...500)
        XCTAssertEqual(m.tapSFM, 25...40)
        XCTAssertEqual(m.boreCarbideSFM, 300...500)
        XCTAssertEqual(m.reamSFM, 40...60)
        XCTAssertEqual(m.drillFeed, 0.005, accuracy: 1e-9)
        XCTAssertEqual(m.chipLoad, 0.003, accuracy: 1e-9)
        XCTAssertEqual(m.reamFeed, 0.008, accuracy: 1e-9)
    }

    func testAluminumOperationFields() {
        let m = Materials.byID("alum")!
        XCTAssertEqual(m.drillSFM, 200...300)
        XCTAssertEqual(m.millCarbideSFM, 500...1000)
        XCTAssertEqual(m.chipLoad, 0.004, accuracy: 1e-9)
    }
}
