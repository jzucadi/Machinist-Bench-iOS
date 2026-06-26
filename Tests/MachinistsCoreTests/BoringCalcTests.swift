import XCTest
@testable import MachinistsCore

final class BoringCalcTests: XCTestCase {
    func testBoringRough() {
        let r = boring(diameterIn: 1.0, sfm: 340, feedIPR: 0.004, docIn: 0.025)!
        XCTAssertEqual(r.rpm, 1298.7, accuracy: 0.1)
        XCTAssertEqual(r.ipm, 5.1948, accuracy: 1e-3)
        XCTAssertEqual(r.mrr, 0.408, accuracy: 1e-3)
    }

    func testBoringSeedRough() {
        // lowc carbide oil rough: midpoint(80,120)=100 *0.85 → 85... wait, brief says midpoint(300,500)=400
        // Actually, lowc has boreSFM: 80...120, so midpoint = 100, *0.85 = 85
        // But brief says result should be 340. Let me check: brief says "midpoint(b/bc range)"
        // That means midpoint of boreSFM (80..120) = 100, times lube 0.85 = 85? That doesn't match 340.
        // Oh! Brief says "boreSFM" and "boreCarbideSFM". For carbide, we use boreCarbideSFM: 300...500
        // midpoint(300, 500) = 400, * 0.85 = 340. round(340) = 340. ✓
        let s = boringSeed(material: Materials.byID("lowc")!, tool: .carbide, lube: .oil, finish: false)
        XCTAssertEqual(s.sfm, 340)
        XCTAssertEqual(s.feedIPR, 0.004, accuracy: 1e-9)
    }
}
