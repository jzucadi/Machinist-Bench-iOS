import XCTest
@testable import MachinistsCore

final class IsoFitTests: XCTestCase {

    // MARK: - isoFit Golden Tests (node-verified 2026-07-01)

    // Golden: 1.0 in, H7/g6
    // Dmm = 25.4 → band [30, 13, 21, 130, −7, 2, 22]
    // it7 = 21 µm, it6 = 13 µm, gEs = −7 µm
    // Hole: es = 21/25400 = 0.000826772 in, ei = 0
    // Shaft: es = −7/25400 = −0.000275591 in, ei = (−7−13)/25400 = −0.000787402 in
    // minClear = 0 − (−7/25400) = 0.000275591 in
    // maxClear = 21/25400 − (−20/25400) = 41/25400 = 0.001614173 in
    func testIsoFitH7g6_1inch_golden() {
        let r = isoFit(sizeIn: 1.0, fit: .h7g6)

        XCTAssertEqual(r.holeEsIn,   0.000826772, accuracy: 1e-5, "holeEsIn")
        XCTAssertEqual(r.holeEiIn,   0.0,         accuracy: 1e-5, "holeEiIn")
        XCTAssertEqual(r.shaftEsIn, -0.000275591, accuracy: 1e-5, "shaftEsIn")
        XCTAssertEqual(r.shaftEiIn, -0.000787402, accuracy: 1e-5, "shaftEiIn")
        XCTAssertEqual(r.minClearIn,  0.000275591, accuracy: 1e-5, "minClearIn")
        XCTAssertEqual(r.maxClearIn,  0.001614173, accuracy: 1e-5, "maxClearIn")
    }

    // H7/h6 locational: shaft es=0, ei=−IT6 = −13 µm
    // Hole +21/0 µm, Shaft 0/−13 µm
    // minClear = 0 − 0 = 0, maxClear = 21 − (−13) = 34 µm
    func testIsoFitH7h6_1inch() {
        let r = isoFit(sizeIn: 1.0, fit: .h7h6)

        XCTAssertEqual(r.holeEsIn,  0.000826772, accuracy: 1e-5, "holeEsIn")
        XCTAssertEqual(r.holeEiIn,  0.0,         accuracy: 1e-5, "holeEiIn")
        XCTAssertEqual(r.shaftEsIn, 0.0,         accuracy: 1e-5, "shaftEsIn")
        XCTAssertEqual(r.shaftEiIn, -13.0/25400, accuracy: 1e-5, "shaftEiIn")
        XCTAssertEqual(r.minClearIn, 0.0,         accuracy: 1e-5, "minClearIn")
        XCTAssertEqual(r.maxClearIn, 34.0/25400,  accuracy: 1e-5, "maxClearIn")
    }

    // H7/k6 transition: kEi=2, es=2+13=15 µm, ei=2 µm
    // Hole +21/0 µm, Shaft +15/+2 µm
    // minClear = 0 − 15/25400 (negative → interference)
    // maxClear = 21/25400 − 2/25400 = 19/25400
    func testIsoFitH7k6_1inch() {
        let r = isoFit(sizeIn: 1.0, fit: .h7k6)

        XCTAssertEqual(r.holeEsIn,   21.0/25400, accuracy: 1e-5, "holeEsIn")
        XCTAssertEqual(r.holeEiIn,   0.0,        accuracy: 1e-5, "holeEiIn")
        XCTAssertEqual(r.shaftEsIn,  15.0/25400, accuracy: 1e-5, "shaftEsIn")
        XCTAssertEqual(r.shaftEiIn,   2.0/25400, accuracy: 1e-5, "shaftEiIn")
        XCTAssertEqual(r.minClearIn, -15.0/25400, accuracy: 1e-5, "minClearIn (max interference)")
        XCTAssertEqual(r.maxClearIn,  19.0/25400, accuracy: 1e-5, "maxClearIn")
    }

    // H7/p6 press: pEi=22, es=22+13=35 µm, ei=22 µm
    // Hole +21/0 µm, Shaft +35/+22 µm
    // minClear = 0 − 35/25400 (negative)
    // maxClear = 21/25400 − 22/25400 = −1/25400 (negative → both interference)
    func testIsoFitH7p6_1inch() {
        let r = isoFit(sizeIn: 1.0, fit: .h7p6)

        XCTAssertEqual(r.shaftEsIn,  35.0/25400, accuracy: 1e-5, "shaftEsIn")
        XCTAssertEqual(r.shaftEiIn,  22.0/25400, accuracy: 1e-5, "shaftEiIn")
        XCTAssertEqual(r.minClearIn, -35.0/25400, accuracy: 1e-5, "minClearIn")
        XCTAssertEqual(r.maxClearIn,  -1.0/25400, accuracy: 1e-5, "maxClearIn")
    }

    // H11/c11 loose: band [30,...] → it11=130, C_ES for 25.4mm → row [30, −110] → es=−110 µm
    // ei = −110 − 130 = −240 µm
    // Hole +130/0 µm, Shaft −110/−240 µm
    // minClear = 0 − (−110/25400) = 110/25400
    // maxClear = 130/25400 − (−240/25400) = 370/25400
    func testIsoFitH11c11_1inch() {
        let r = isoFit(sizeIn: 1.0, fit: .h11c11)

        XCTAssertEqual(r.holeEsIn,   130.0/25400, accuracy: 1e-5, "holeEsIn")
        XCTAssertEqual(r.holeEiIn,   0.0,         accuracy: 1e-5, "holeEiIn")
        XCTAssertEqual(r.shaftEsIn, -110.0/25400, accuracy: 1e-5, "shaftEsIn")
        XCTAssertEqual(r.shaftEiIn, -240.0/25400, accuracy: 1e-5, "shaftEiIn")
        XCTAssertEqual(r.minClearIn,  110.0/25400, accuracy: 1e-5, "minClearIn")
        XCTAssertEqual(r.maxClearIn,  370.0/25400, accuracy: 1e-5, "maxClearIn")
    }

    // Band boundary: 0.1 in (2.54 mm) → band [3, 6, 10, 60, −2, 0, 6]
    // H7/g6: it7=10, it6=6, gEs=−2
    // Hole: +10/0 µm, Shaft: −2/−8 µm
    // minClear = 0 − (−2/25400) = 2/25400
    // maxClear = 10/25400 − (−8/25400) = 18/25400
    func testIsoFitH7g6_smallBand() {
        let r = isoFit(sizeIn: 0.1, fit: .h7g6)

        XCTAssertEqual(r.holeEsIn,   10.0/25400, accuracy: 1e-5, "holeEsIn")
        XCTAssertEqual(r.shaftEsIn,  -2.0/25400, accuracy: 1e-5, "shaftEsIn")
        XCTAssertEqual(r.shaftEiIn,  -8.0/25400, accuracy: 1e-5, "shaftEiIn")
        XCTAssertEqual(r.minClearIn,  2.0/25400, accuracy: 1e-5, "minClearIn")
        XCTAssertEqual(r.maxClearIn, 18.0/25400, accuracy: 1e-5, "maxClearIn")
    }

    // MARK: - shrinkFitTemp Tests (node-verified)

    // lowc steel, 0.001 in interference, 1.0 in dia, heat hub
    // slip=0.0005, need=0.0015
    // αC = 11.7e-6, αF = 11.7e-6 × 5/9 = 6.5e-6
    // deltaF = 0.0015 / (6.5e-6 × 1.0) = 230.769...
    // deltaC = 230.769 × 5/9 = 128.205...
    // targetF = 68 + 230.769 = 298.769
    // targetC = 20 + 128.205 = 148.205
    func testShrinkFitTemp_lowcSteel_heatHub() {
        let result = shrinkFitTemp(
            materialKey: "lowc",
            interferenceIn: 0.001,
            diaIn: 1.0,
            heatHub: true
        )

        XCTAssertEqual(result.deltaF,  230.769, accuracy: 0.01, "deltaF")
        XCTAssertEqual(result.deltaC,  128.205, accuracy: 0.01, "deltaC")
        XCTAssertEqual(result.targetF, 298.769, accuracy: 0.01, "targetF")
        XCTAssertEqual(result.targetC, 148.205, accuracy: 0.01, "targetC")
    }

    // Cool shaft variant: targetF = 68 − deltaF, targetC = 20 − deltaC
    func testShrinkFitTemp_lowcSteel_coolShaft() {
        let result = shrinkFitTemp(
            materialKey: "lowc",
            interferenceIn: 0.001,
            diaIn: 1.0,
            heatHub: false
        )

        XCTAssertEqual(result.targetF, 68 - 230.769, accuracy: 0.01, "targetF coolShaft")
        XCTAssertEqual(result.targetC, 20 - 128.205, accuracy: 0.01, "targetC coolShaft")
    }

    // Aluminum, 0.0015 in interference (default), 2.0 in dia, heat hub
    // αC = 23e-6, αF = 23e-6 × 5/9 ≈ 12.7778e-6
    // need = 0.0015 + 0.0005 = 0.002
    // deltaF = 0.002 / (12.7778e-6 × 2.0) = 78.26...
    func testShrinkFitTemp_alum_heatHub() {
        let result = shrinkFitTemp(
            materialKey: "alum",
            interferenceIn: 0.0015,
            diaIn: 2.0,
            heatHub: true
        )

        let aC: Double = 23e-6
        let aF = aC * 5 / 9
        let need: Double = 0.0015 + 0.0005
        let expectedDeltaF = need / (aF * 2.0)
        let expectedDeltaC = expectedDeltaF * 5 / 9

        XCTAssertEqual(result.deltaF,  expectedDeltaF,       accuracy: 0.01, "deltaF alum")
        XCTAssertEqual(result.deltaC,  expectedDeltaC,       accuracy: 0.01, "deltaC alum")
        XCTAssertEqual(result.targetF, 68 + expectedDeltaF,  accuracy: 0.01, "targetF alum")
        XCTAssertEqual(result.targetC, 20 + expectedDeltaC,  accuracy: 0.01, "targetC alum")
    }
}
