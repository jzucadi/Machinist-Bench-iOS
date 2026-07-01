import XCTest
@testable import MachinistsCore

final class PolygonTests: XCTestCase {
    // Golden test: Hexagon (N=6), Across Flats = 1.5
    // Expected: acrossCorners 1.732051, side 0.866025, apothem 0.75,
    //           area 1.948557, perimeter 5.196152
    func testHexagonAcrossFlats1_5() {
        let result = polygon(sides: 6, mode: .af, value: 1.5)

        XCTAssertEqual(result.acrossFlats, 1.5, accuracy: 1e-4)
        XCTAssertEqual(result.acrossCorners, 1.732051, accuracy: 1e-4)
        XCTAssertEqual(result.side, 0.866025, accuracy: 1e-4)
        XCTAssertEqual(result.apothem, 0.75, accuracy: 1e-4)
        XCTAssertEqual(result.area, 1.948557, accuracy: 1e-4)
        XCTAssertEqual(result.perimeter, 5.196152, accuracy: 1e-4)
    }

    // Golden test: Square (N=4), Across Corners = 2.0
    // Expected: side 1.41421, area 2.0
    func testSquareAcrossCorners2_0() {
        let result = polygon(sides: 4, mode: .ac, value: 2.0)

        XCTAssertEqual(result.acrossCorners, 2.0, accuracy: 1e-4)
        XCTAssertEqual(result.side, 1.41421, accuracy: 1e-4)
        XCTAssertEqual(result.area, 2.0, accuracy: 1e-4)
    }
}
