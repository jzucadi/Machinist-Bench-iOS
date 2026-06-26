import XCTest
@testable import MachinistsCore

final class ThreadingCalcTests: XCTestCase {
    func testThreading12_13() {
        let major = 0.5, pitch = 1.0/13.0
        XCTAssertEqual(threadingRPM(sfm: 293, workpieceODIn: 0.5)!, 2238.4, accuracy: 0.2)
        let g = threadGeometry(majorIn: major, pitchIn: pitch)
        XCTAssertEqual(g.heightExt, 0.04718, accuracy: 1e-4)
        XCTAssertEqual(g.pitchDia, 0.45004, accuracy: 1e-4)
        XCTAssertEqual(g.minorExt, 0.40564, accuracy: 1e-4)
        XCTAssertEqual(g.compound, 0.05421, accuracy: 1e-4)
        let infeeds = threadingInfeeds(heightExt: g.heightExt, passes: 6)
        XCTAssertEqual(infeeds.count, 6)
        XCTAssertEqual(infeeds[0], 0.01926, accuracy: 1e-4)   // first pass largest
        XCTAssertEqual(infeeds.reduce(0,+), g.heightExt, accuracy: 1e-6)  // sums to full height
    }
    func testRecommendedThreadSFM() {  // lowc carbide: midpoint(350,550)=450 *0.65 → 293
        XCTAssertEqual(recommendedThreadSFM(material: Materials.byID("lowc")!, tool: .carbide), 293)
    }
}
