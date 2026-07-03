import XCTest
@testable import MachinistsCore

final class ModelSteamTests: XCTestCase {

    // MARK: - boilerProps

    /// Golden (node-verified): bore=1.0in, cylinders=2
    ///   pistonArea = π×(0.5)² = 0.7853981633974483 in²
    ///   total = 1.5707963267948966 in²
    ///   grate  = total/8 = 0.19634954084936207 in²
    ///   heating = grate×60 = 11.780972450961723 in²
    func testBoilerProps_1in_2cyl() {
        let result = boilerProps(boreIn: 1.0, cylinders: 2)
        XCTAssertEqual(result.grateSqIn,   0.19634954084936207, accuracy: 1e-3)
        XCTAssertEqual(result.heatingSqIn, 11.780972450961723,  accuracy: 1e-3)
    }

    func testBoilerProps_singleCylinder() {
        // bore=1.0in, cylinders=1 → grate = π×0.25/8
        let result = boilerProps(boreIn: 1.0, cylinders: 1)
        let expected = Double.pi * 0.25 / 8.0
        XCTAssertEqual(result.grateSqIn,   expected,      accuracy: 1e-9)
        XCTAssertEqual(result.heatingSqIn, expected * 60, accuracy: 1e-9)
    }

    func testBoilerProps_scalingWithCylinders() {
        // 4 cylinders should yield exactly 4× the grate of 1 cylinder
        let one  = boilerProps(boreIn: 2.0, cylinders: 1)
        let four = boilerProps(boreIn: 2.0, cylinders: 4)
        XCTAssertEqual(four.grateSqIn,   one.grateSqIn   * 4, accuracy: 1e-9)
        XCTAssertEqual(four.heatingSqIn, one.heatingSqIn * 4, accuracy: 1e-9)
    }

    // MARK: - cylinderPower

    /// Golden (node-verified from app.html JS):
    ///   bore=1.0in, stroke=1.5in, rpm=500, psi=45, cutoff=0.6, cylinders=2
    ///   bore_m  = 0.0254 m
    ///   stroke_m = 0.038099... m
    ///   mep_pa  = 45 × 6894.76 = 310264.2 Pa
    ///   area_m² = π×0.0127² = 5.067074790974977e-4 m²
    ///   strokesPerSec = 2×500/60 = 16.6667
    ///   watts   = 199.66075210797632 W
    ///   hp      = 0.2677494328925524
    ///   Pbar    = 45/14.5 = 3.103448...
    ///   rho     = max(0.6, 3.103448×0.55) = 1.7068965...
    ///   steamKgH = 2.372586132920092 kg/h
    func testCylinderPower_golden_inch() {
        let result = cylinderPower(
            boreIn:    1.0,
            strokeIn:  1.5,
            rpm:       500,
            psi:       45,
            cutoff:    0.6,
            cylinders: 2
        )
        XCTAssertEqual(result.watts,    199.66075210797632, accuracy: 0.5)
        XCTAssertEqual(result.hp,       0.2677494328925524, accuracy: 1e-2)
        XCTAssertEqual(result.steamKgH, 2.372586132920092,  accuracy: 0.05)
    }

    func testCylinderPower_rhoFloor() {
        // Very low pressure (psi=1) → Pbar=1/14.5≈0.069 → Pbar×0.55=0.038 < 0.6 → rho=0.6
        let result = cylinderPower(
            boreIn:    1.0,
            strokeIn:  1.0,
            rpm:       100,
            psi:       1,
            cutoff:    0.5,
            cylinders: 1
        )
        // Just verify it runs and rho floor kept steam positive
        XCTAssertGreaterThan(result.steamKgH, 0)
        // At psi=1, Pbar=0.069, 0.069×0.55=0.038 < 0.6, so rho=0.6 (floor active)
        // Manual: bore_m=0.0254, stroke_m=0.0254, mep_pa=6894.76
        // area=5.067e-4, sPS=2×100/60=3.3333
        // watts=6894.76×0.0254×5.067e-4×3.3333×1=0.2966W
        // steamVol_min=5.067e-4×0.0254×3.3333×60×0.5×1=1.2890e-3 m³/min
        // steamKgH=1.2890e-3×60×0.6=0.046404 kg/h
        XCTAssertEqual(result.steamKgH, 0.046404, accuracy: 1e-3)
    }

    func testCylinderPower_watts_proportional_to_cylinders() {
        // Doubling cylinders should double watts exactly
        let one = cylinderPower(boreIn: 1.0, strokeIn: 1.5, rpm: 500, psi: 45, cutoff: 0.6, cylinders: 1)
        let two = cylinderPower(boreIn: 1.0, strokeIn: 1.5, rpm: 500, psi: 45, cutoff: 0.6, cylinders: 2)
        XCTAssertEqual(two.watts, one.watts * 2, accuracy: 1e-6)
        XCTAssertEqual(two.hp,    one.hp    * 2, accuracy: 1e-6)
    }

    func testCylinderPower_hp_from_watts() {
        // hp must always equal watts/745.7
        let result = cylinderPower(
            boreIn:    1.0,
            strokeIn:  1.5,
            rpm:       500,
            psi:       45,
            cutoff:    0.6,
            cylinders: 2
        )
        XCTAssertEqual(result.hp, result.watts / 745.7, accuracy: 1e-9)
    }
}
