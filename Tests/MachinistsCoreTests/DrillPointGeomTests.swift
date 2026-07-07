import XCTest
@testable import MachinistsCore

// Golden cases from m7-extraction §3 (node-verified)
final class DrillPointGeomTests: XCTestCase {

    private let acc = 0.02   // tolerance matching node-verified values (round to 2 dp)

    // MARK: outline — verifies bodyL/cx/bodyR against golden at 118°

    func testOutline_118() {
        let pts = DrillPointGeom.outline(includedDeg: 118)
        XCTAssertEqual(pts.count, 3)
        XCTAssertEqual(pts[0].x, 234, accuracy: acc)   // bodyL
        XCTAssertEqual(pts[0].y, 428, accuracy: acc)   // seamY
        XCTAssertEqual(pts[1].x, 255, accuracy: acc)   // cx
        XCTAssertEqual(pts[1].y, 448, accuracy: acc)   // tipY (coneH clamped to 20)
        XCTAssertEqual(pts[2].x, 277, accuracy: acc)   // bodyR
        XCTAssertEqual(pts[2].y, 428, accuracy: acc)   // seamY
    }

    // MARK: liplineY — tipY for all four preset angles

    func testLiplineY_60() {
        // coneH = 21.5 / tan(30°) = 21.5 / 0.5774 ≈ 37.24
        XCTAssertEqual(DrillPointGeom.liplineY(includedDeg: 60), 465.24, accuracy: acc)
    }

    func testLiplineY_90() {
        // coneH = 21.5 / tan(45°) = 21.5 / 1.0 = 21.50
        XCTAssertEqual(DrillPointGeom.liplineY(includedDeg: 90), 449.50, accuracy: acc)
    }

    func testLiplineY_118() {
        // geometric coneH ≈ 12.9 → clamped to 20
        XCTAssertEqual(DrillPointGeom.liplineY(includedDeg: 118), 448.00, accuracy: acc)
    }

    func testLiplineY_135() {
        // geometric coneH ≈ 8.9 → clamped to 20
        XCTAssertEqual(DrillPointGeom.liplineY(includedDeg: 135), 448.00, accuracy: acc)
    }

    // MARK: arcPoints — included-angle arc endpoints (element 9)

    func testArcPoints_60() {
        let arc = DrillPointGeom.arcPoints(includedDeg: 60)
        XCTAssertEqual(arc.left.x,  242.00, accuracy: acc)
        XCTAssertEqual(arc.left.y,  442.72, accuracy: acc)
        XCTAssertEqual(arc.right.x, 268.00, accuracy: acc)
        XCTAssertEqual(arc.right.y, 442.72, accuracy: acc)
    }

    func testArcPoints_90() {
        let arc = DrillPointGeom.arcPoints(includedDeg: 90)
        XCTAssertEqual(arc.left.x,  236.62, accuracy: acc)
        XCTAssertEqual(arc.left.y,  431.12, accuracy: acc)
        XCTAssertEqual(arc.right.x, 273.38, accuracy: acc)
        XCTAssertEqual(arc.right.y, 431.12, accuracy: acc)
    }

    func testArcPoints_118() {
        let arc = DrillPointGeom.arcPoints(includedDeg: 118)
        XCTAssertEqual(arc.left.x,  232.71, accuracy: acc)
        XCTAssertEqual(arc.left.y,  434.61, accuracy: acc)
        XCTAssertEqual(arc.right.x, 277.29, accuracy: acc)
        XCTAssertEqual(arc.right.y, 434.61, accuracy: acc)
    }

    func testArcPoints_135() {
        let arc = DrillPointGeom.arcPoints(includedDeg: 135)
        XCTAssertEqual(arc.left.x,  230.98, accuracy: acc)
        XCTAssertEqual(arc.left.y,  438.05, accuracy: acc)
        XCTAssertEqual(arc.right.x, 279.02, accuracy: acc)
        XCTAssertEqual(arc.right.y, 438.05, accuracy: acc)
    }

    // MARK: monotonicity — sharper angle → deeper cone → larger tipY

    func testLiplineY_monotonicity() {
        let y60  = DrillPointGeom.liplineY(includedDeg: 60)
        let y90  = DrillPointGeom.liplineY(includedDeg: 90)
        let y118 = DrillPointGeom.liplineY(includedDeg: 118)
        let y135 = DrillPointGeom.liplineY(includedDeg: 135)
        XCTAssertGreaterThan(y60, y90,  "60° sharper → deeper tip than 90°")
        XCTAssertGreaterThan(y90, y118, "90° sharper → deeper tip than 118°")
        // 118° and 135° both clamp to coneH=20, so tipY is equal
        XCTAssertEqual(y118, y135, accuracy: 0.01)
    }

    // MARK: arc symmetry — left/right must be symmetric about cx=255

    func testArcPoints_symmetry_118() {
        let arc = DrillPointGeom.arcPoints(includedDeg: 118)
        let cx: Double = 255
        XCTAssertEqual(cx - arc.left.x, arc.right.x - cx, accuracy: acc)
        XCTAssertEqual(arc.left.y, arc.right.y, accuracy: acc)
    }
}
