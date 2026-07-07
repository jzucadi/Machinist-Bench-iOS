// InsertCodeTests.swift — TDD golden cases + table counts for InsertCode / ToolChooser / ToolingRef
// Golden values node-verified in m7-extraction.md §1b–d, §2.

import XCTest
@testable import MachinistsCore

final class InsertCodeTests: XCTestCase {

    // MARK: - InsertCode.decode — golden cases

    /// CNMG 432 — ANSI, negative, 80° diamond (the workhorse negative insert)
    func testDecodeCNMG432() {
        let fields = InsertCode.decode("CNMG 432")
        XCTAssertFalse(fields.isEmpty, "CNMG 432 must parse")

        let summary = fields.first { $0.label == "Summary" }
        XCTAssertEqual(summary?.meaning, "80° diamond, negative · ANSI 432")

        let ic = fields.first { $0.label == "IC" }
        XCTAssertEqual(ic?.meaning, "1/2\u{2033} (12.7 mm)")

        let thk = fields.first { $0.label == "Thickness" }
        XCTAssertEqual(thk?.meaning, "3/16\u{2033} (4.76 mm)")

        let nr = fields.first { $0.label == "Corner R" }
        XCTAssertEqual(nr?.meaning, "1/32\u{2033} (0.8 mm)")
    }

    /// TNMG 160408 — ISO, negative, triangle
    func testDecodeTNMG160408() {
        let fields = InsertCode.decode("TNMG 160408")
        XCTAssertFalse(fields.isEmpty)

        XCTAssertEqual(fields.first { $0.label == "Summary" }?.meaning,
                       "triangle 60°, negative · ISO 160408")
        XCTAssertEqual(fields.first { $0.label == "IC" }?.meaning,
                       "3/8\u{2033} (9.525 mm)")
        XCTAssertEqual(fields.first { $0.label == "Thickness" }?.meaning,
                       "3/16\u{2033} (4.76 mm)")
        XCTAssertEqual(fields.first { $0.label == "Corner R" }?.meaning,
                       "1/32\u{2033} (0.8 mm)")
    }

    /// CCGT 21.51 — ANSI, positive 7°, screw-lock
    func testDecodeCCGT2151() {
        let fields = InsertCode.decode("CCGT 21.51")
        XCTAssertFalse(fields.isEmpty)

        XCTAssertEqual(fields.first { $0.label == "Summary" }?.meaning,
                       "80° diamond, positive 7° · ANSI 21.51")
        XCTAssertEqual(fields.first { $0.label == "IC" }?.meaning,
                       "1/4\u{2033} (6.35 mm)")
        XCTAssertEqual(fields.first { $0.label == "Thickness" }?.meaning,
                       "3/32\u{2033} (2.38 mm)")
        XCTAssertEqual(fields.first { $0.label == "Corner R" }?.meaning,
                       "1/64\u{2033} (0.4 mm)")
    }

    /// VBMT 331 — ANSI, positive 5°, 35° diamond
    func testDecodeVBMT331() {
        let fields = InsertCode.decode("VBMT 331")
        XCTAssertFalse(fields.isEmpty)

        XCTAssertEqual(fields.first { $0.label == "Summary" }?.meaning,
                       "35° diamond, positive 5° · ANSI 331")
        XCTAssertEqual(fields.first { $0.label == "IC" }?.meaning,
                       "3/8\u{2033} (9.525 mm)")
        XCTAssertEqual(fields.first { $0.label == "Thickness" }?.meaning,
                       "3/16\u{2033} (4.76 mm)")
        XCTAssertEqual(fields.first { $0.label == "Corner R" }?.meaning,
                       "1/64\u{2033} (0.4 mm)")
    }

    /// Seat logic — CNMG (type G, clear N) → negative seats
    func testSeatCNMG() {
        let fields = InsertCode.decode("CNMG 432")
        let seat = fields.first { $0.label == "Seat" }
        XCTAssertEqual(seat?.meaning, "negative seats — pin / top clamp (MCLNR style)")
    }

    /// Seat logic — CCGT (type T) → screw-lock seats
    func testSeatCCGT() {
        let fields = InsertCode.decode("CCGT 21.51")
        let seat = fields.first { $0.label == "Seat" }
        XCTAssertEqual(seat?.meaning, "screw-lock seats (SCLCR style)")
    }

    /// Garbage input returns empty
    func testDecodeGarbageReturnsEmpty() {
        XCTAssertTrue(InsertCode.decode("").isEmpty)
        XCTAssertTrue(InsertCode.decode("XYZ").isEmpty)
        XCTAssertTrue(InsertCode.decode("????").isEmpty)
    }

    /// Shape codes are stored verbatim in InsertCodeField.code
    func testDecodeShapeCode() {
        let fields = InsertCode.decode("CNMG 432")
        let shape = fields.first { $0.label == "Shape" }
        XCTAssertEqual(shape?.code, "C")
        XCTAssertEqual(shape?.meaning, "80° diamond")
    }

    // MARK: - ToolChooser static arrays

    func testOpsCount() {
        XCTAssertEqual(ToolChooser.ops.count, 5)
        XCTAssertTrue(ToolChooser.ops.contains("turn"))
        XCTAssertTrue(ToolChooser.ops.contains("thread"))
    }

    func testMaterialsCount() {
        XCTAssertEqual(ToolChooser.materials.count, 6)
        XCTAssertTrue(ToolChooser.materials.contains("steel"))
        XCTAssertTrue(ToolChooser.materials.contains("hard"))
    }

    func testRigiditiesCount() {
        XCTAssertEqual(ToolChooser.rigidities.count, 3)
        XCTAssertEqual(ToolChooser.rigidities, ["light", "mid", "rigid"])
    }

    // MARK: - ToolChooser segment-option arrays (§1c, Phase B view support)

    func testFeatOptionsCount() {
        XCTAssertEqual(ToolChooser.featOptions.count, 2)
        XCTAssertTrue(ToolChooser.featOptions.map(\.key).contains("plain"))
        XCTAssertTrue(ToolChooser.featOptions.map(\.key).contains("sq"))
    }

    func testBfeatOptionsCount() {
        XCTAssertEqual(ToolChooser.bfeatOptions.count, 3)
        XCTAssertTrue(ToolChooser.bfeatOptions.map(\.key).contains("thru"))
        XCTAssertTrue(ToolChooser.bfeatOptions.map(\.key).contains("blind"))
        XCTAssertTrue(ToolChooser.bfeatOptions.map(\.key).contains("prof"))
    }

    func testCutOptionsCount() {
        XCTAssertEqual(ToolChooser.cutOptions.count, 3)
        XCTAssertTrue(ToolChooser.cutOptions.map(\.key).contains("rough"))
        XCTAssertTrue(ToolChooser.cutOptions.map(\.key).contains("gen"))
        XCTAssertTrue(ToolChooser.cutOptions.map(\.key).contains("fin"))
    }

    func testMatOptionsCount() {
        XCTAssertEqual(ToolChooser.matOptions.count, 6)
        XCTAssertTrue(ToolChooser.matOptions.map(\.key).contains("alu"))
        XCTAssertTrue(ToolChooser.matOptions.map(\.key).contains("hard"))
    }

    func testMachOptionsCount() {
        XCTAssertEqual(ToolChooser.machOptions.count, 3)
        XCTAssertEqual(ToolChooser.machOptions.map(\.key), ["light", "mid", "rigid"])
    }

    // MARK: - ToolChooser.recommend paths

    /// turn + steel + rigid → negative CNMG in MCLNR holder
    func testTurnSteelRigid() {
        let rec = ToolChooser.recommend(op: "turn", mat: "steel", mach: "rigid")
        XCTAssertEqual(rec.holder, "MCLNR")
        XCTAssertTrue(rec.insert.contains("CNMG"), "insert must reference CNMG; got '\(rec.insert)'")
        XCTAssertTrue(rec.insert.contains("negative"), "wantNeg path must say negative")
    }

    /// turn + steel + light → positive CCMT in SCLCR holder
    func testTurnSteelLight() {
        let rec = ToolChooser.recommend(op: "turn", mat: "steel", mach: "light")
        XCTAssertEqual(rec.holder, "SCLCR")
        XCTAssertTrue(rec.insert.contains("CCMT"))
        XCTAssertTrue(rec.insert.contains("positive"))
    }

    /// face + alu + light → polished GT TCGT
    func testFaceAluLight() {
        let rec = ToolChooser.recommend(op: "face", mat: "alu", mach: "light")
        XCTAssertEqual(rec.holder, "STFCR")
        XCTAssertTrue(rec.insert.contains("TCGT"))
        XCTAssertTrue(rec.insert.contains("GT"))
    }

    /// thread → CER / CIR holders, 16ER / 16IR inserts
    func testThreadRecommendation() {
        let rec = ToolChooser.recommend(op: "thread", mat: "steel", mach: "rigid")
        XCTAssertTrue(rec.holder.contains("CER"), "holder must mention CER; got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("16ER"))
        XCTAssertTrue(rec.note.contains("pitch"))
    }

    /// prof + steel + rigid → VNMG in MVJNR
    func testProfSteelRigid() {
        let rec = ToolChooser.recommend(op: "prof", mat: "steel", mach: "rigid")
        XCTAssertEqual(rec.holder, "MVJNR")
        XCTAssertTrue(rec.insert.contains("VNMG"))
    }

    // MARK: - ToolChooser §1c table coverage (new paths)

    /// turn + feat=sq + steel + mid → SDJCR holder, DCMT positive insert
    /// Source: §1c "turn + feat=sq → D 55° / SDJCR / MDJNR / DCMT / DCGT / DNMG"
    func testTurnSqCornerPositive() {
        let rec = ToolChooser.recommend(op: "turn", feat: "sq", mat: "steel", mach: "mid")
        XCTAssertEqual(rec.holder, "SDJCR",
                       "sq-corner left-hand holder must be SDJCR; got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("DCMT"),
                      "sq-corner positive insert must be DCMT; got '\(rec.insert)'")
        XCTAssertTrue(rec.insert.contains("positive"))
    }

    /// turn + feat=sq + steel + rigid → MDJNR holder, DNMG negative insert
    func testTurnSqCornerNegative() {
        let rec = ToolChooser.recommend(op: "turn", feat: "sq", mat: "steel", mach: "rigid")
        XCTAssertEqual(rec.holder, "MDJNR",
                       "sq-corner RH holder must be MDJNR; got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("DNMG"),
                      "sq-corner negative insert must be DNMG; got '\(rec.insert)'")
        XCTAssertTrue(rec.insert.contains("negative"))
    }

    /// turn + rough + rigid + steel → S 90° path (MSSNR, SNMG)
    /// Source: §1c "turn + rough + rigid + !soft → S 90° / SSDCN / MSSNR / SCMT / SCGT / SNMG"
    func testTurnRoughRigidStrong() {
        let rec = ToolChooser.recommend(op: "turn", cut: "rough", mat: "steel", mach: "rigid")
        XCTAssertEqual(rec.holder, "MSSNR",
                       "S 90° rigid-rough holder must be MSSNR; got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("SNMG"),
                      "S 90° negative insert must be SNMG; got '\(rec.insert)'")
        XCTAssertTrue(rec.insert.contains("negative"))
    }

    /// bore + blind + steel + mid → SDUCR bar holder, DCMT positive insert
    /// Source: §1c "bore + blind → D 55° / SDUCR bar / SDUCR bar / DCMT / DCGT / DCMT"
    func testBoreBlind() {
        let rec = ToolChooser.recommend(op: "bore", bfeat: "blind", mat: "steel", mach: "mid")
        XCTAssertTrue(rec.holder.contains("SDUCR"),
                      "blind-bore holder must contain SDUCR; got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("DCMT"),
                      "blind-bore positive insert must be DCMT; got '\(rec.insert)'")
    }

    // MARK: - wantNeg boundary (mid+rough vs mid+gen)

    /// mid + rough → wantNeg=true: CNMG negative in MCLNR
    func testWantNegMidRough() {
        let rec = ToolChooser.recommend(op: "turn", cut: "rough", mat: "steel", mach: "mid")
        XCTAssertEqual(rec.holder, "MCLNR",
                       "mid+rough must use MCLNR (wantNeg=true); got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("CNMG"),
                      "mid+rough insert must be CNMG; got '\(rec.insert)'")
        XCTAssertTrue(rec.insert.contains("negative"))
    }

    /// mid + gen → wantNeg=false: CCMT positive in SCLCR
    func testWantNegMidGen() {
        let rec = ToolChooser.recommend(op: "turn", cut: "gen", mat: "steel", mach: "mid")
        XCTAssertEqual(rec.holder, "SCLCR",
                       "mid+gen must use SCLCR (wantNeg=false); got '\(rec.holder)'")
        XCTAssertTrue(rec.insert.contains("CCMT"),
                      "mid+gen insert must be CCMT; got '\(rec.insert)'")
        XCTAssertTrue(rec.insert.contains("positive"))
    }

    // MARK: - ToolingRef table counts

    func testInsertGradesCount() {
        XCTAssertEqual(ToolingRef.insertGrades.count, 6)
    }

    func testInsertNoseRadiiCount() {
        XCTAssertEqual(ToolingRef.insertNoseRadii.count, 4)
    }

    func testInsertCardsCount() {
        XCTAssertEqual(ToolingRef.insertCards.count, 7)
    }

    func testHolderCodesCount() {
        XCTAssertEqual(ToolingRef.holderCodes.count, 9)
    }

    func testToolStylesCount() {
        XCTAssertEqual(ToolingRef.toolStyles.count, 5)
    }

    // MARK: - Ra finish table (§1d, 5 × 4 values)

    /// Ra finish table must have exactly 5 rows
    func testRaFinishTableCount() {
        XCTAssertEqual(ToolingRef.raFinishTable.count, 5)
    }

    /// Spot check: feed 0.003″ → Ra 18 µin at 0.4 mm, 9 µin at 0.8 mm
    func testRaFinishSpotCheck() throws {
        let row = try XCTUnwrap(ToolingRef.raFinishTable.first { $0.feed == "0.003\u{2033}" },
                                "no row with feed 0.003\u{2033}")
        XCTAssertEqual(row.ra04, 18, "0.003\u{2033} × 0.4 mm → 18 µin")
        XCTAssertEqual(row.ra08, 9,  "0.003\u{2033} × 0.8 mm → 9 µin")
    }

    // MARK: - ToolingRef spot checks

    /// ISO grade P → Steel, blue token
    func testInsertGradePSpot() throws {
        let row = try XCTUnwrap(ToolingRef.insertGrades.first { $0.letter == "P" })
        XCTAssertEqual(row.material, "Steel")
        XCTAssertEqual(row.colorToken, "S.blue")
    }

    /// 0.8 mm nose radius row → General cut type
    func testInsertNoseRadius08Spot() throws {
        let row = try XCTUnwrap(ToolingRef.insertNoseRadii.first { $0.radiusMM == 0.8 })
        XCTAssertEqual(row.cutType, "General")
    }

    /// CNMG insert card — 80°, diamond, 4 edges, amber highlight
    func testInsertCardCNMGSpot() throws {
        let row = try XCTUnwrap(ToolingRef.insertCards.first { $0.code == "CNMG" })
        XCTAssertEqual(row.ang, 80)
        XCTAssertEqual(row.edges, 4)
        XCTAssertEqual(row.highlight, "S.amber")
    }

    /// Holder code position 1 covers clamp styles
    func testHolderCodePosition1Spot() throws {
        let row = try XCTUnwrap(ToolingRef.holderCodes.first { $0.position.contains("1") })
        XCTAssertTrue(row.codes.contains("top clamp"), "position 1 codes must mention top clamp")
    }

    /// Right-hand turning tool style
    func testToolStyleRHSpot() throws {
        let row = try XCTUnwrap(ToolingRef.toolStyles.first { $0.typeKey == "rh" })
        XCTAssertEqual(row.name, "Right-Hand Turning")
    }

    /// Insert cards "yours" field: WNMG and TNMG are true, rest are false (per m7-extraction.md §1d)
    func testInsertCardsYours() {
        let yoursCards = ToolingRef.insertCards.filter(\.yours).map(\.code)
        XCTAssertEqual(yoursCards, ["WNMG", "TNMG"],
                       "Only WNMG and TNMG should have yours=true; got \(yoursCards)")

        let notYoursCards = ToolingRef.insertCards.filter { !$0.yours }.map(\.code)
        XCTAssertEqual(notYoursCards, ["CNMG", "DNMG", "VNMG", "CCMT", "TCMT"],
                       "CNMG, DNMG, VNMG, CCMT, TCMT should have yours=false; got \(notYoursCards)")
    }
}
