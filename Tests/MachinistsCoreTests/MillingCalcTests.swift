import XCTest
@testable import MachinistsCore

final class MillingCalcTests: XCTestCase {
    func testMillingLowCarbon() {  // D=.5 cornerR=0 sfm=340 cl=.003 Z=4 adoc=.5 rdoc=.125 lead=90 eff=.8 kp=1
        let r = milling(diameterIn: 0.5, cornerRIn: 0, sfm: 340, chipLoad: 0.003, flutes: 4,
                        adocIn: 0.5, rdocIn: 0.125, leadDeg: 90, efficiency: 0.8, kp: 1.0)!
        XCTAssertEqual(r.deff, 0.5, accuracy: 1e-9)
        XCTAssertEqual(r.rpm, 2597.41, accuracy: 0.05)
        XCTAssertEqual(r.ctf, 1.1547, accuracy: 1e-3)          // 0.5/(2√(.125*.375))
        XCTAssertEqual(r.fzProg, 0.0034641, accuracy: 1e-5)
        XCTAssertEqual(r.ipm, 35.99, accuracy: 0.1)            // RPM*fzProg*4
        XCTAssertEqual(r.mrr, 2.249, accuracy: 1e-2)
        XCTAssertEqual(r.cutHP, 2.249, accuracy: 1e-2)
    }
    func testChipThinningOffWhenFullSlot() {  // rdoc = D → aeR = Deff → rctf = 1
        let r = milling(diameterIn: 0.5, cornerRIn: 0, sfm: 340, chipLoad: 0.003, flutes: 4,
                        adocIn: 0.5, rdocIn: 0.5, leadDeg: 90, efficiency: 0.8, kp: 1.0)!
        XCTAssertEqual(r.ctf, 1.0, accuracy: 1e-9)
    }
}
