import XCTest
@testable import MachinistsCore

final class ThreadsTests: XCTestCase {

    // MARK: - Golden tests from brief

    func testUNCQuarter20() {
        let t = Threads.unc.first { $0.name == "1/4-20" }!
        XCTAssertEqual(t.tpi, 20, accuracy: 1e-9)
        XCTAssertEqual(t.major, 0.25, accuracy: 1e-9)
    }

    func testUNCHalf13() {
        let t = Threads.unc.first { $0.name == "1/2-13" }!
        XCTAssertEqual(t.tpi, 13, accuracy: 1e-9)
        XCTAssertEqual(t.major, 0.5, accuracy: 1e-9)
    }

    func testMetricM6() {
        let t = Threads.metric.first { $0.name.hasPrefix("M6") }!
        XCTAssertEqual(t.pitch, 1.0, accuracy: 1e-9)
        XCTAssertEqual(t.major, 6, accuracy: 1e-9)
    }

    // MARK: - Count tests

    func testUNCCount() {
        XCTAssertEqual(Threads.unc.count, 21)
    }

    func testUNFCount() {
        XCTAssertEqual(Threads.unf.count, 21)
    }

    func testMetricCount() {
        XCTAssertEqual(Threads.metric.count, 17)
    }

    // MARK: - UNC boundary values

    func testUNCFirst() {
        let t = Threads.unc.first!
        XCTAssertEqual(t.name, "#1-64")
        XCTAssertEqual(t.tpi, 64, accuracy: 1e-9)
        XCTAssertEqual(t.major, 0.073, accuracy: 1e-9)
    }

    func testUNCLast() {
        let t = Threads.unc.last!
        XCTAssertEqual(t.name, "1-1/2-6")
        XCTAssertEqual(t.tpi, 6, accuracy: 1e-9)
        XCTAssertEqual(t.major, 1.5, accuracy: 1e-9)
    }

    func testUNCOneInch() {
        let t = Threads.unc.first { $0.name == "1\"-8" }!
        XCTAssertEqual(t.tpi, 8, accuracy: 1e-9)
        XCTAssertEqual(t.major, 1.0, accuracy: 1e-9)
    }

    // MARK: - UNF boundary values

    func testUNFFirst() {
        let t = Threads.unf.first!
        XCTAssertEqual(t.name, "#0-80")
        XCTAssertEqual(t.tpi, 80, accuracy: 1e-9)
        XCTAssertEqual(t.major, 0.06, accuracy: 1e-9)
    }

    func testUNFLast() {
        let t = Threads.unf.last!
        XCTAssertEqual(t.name, "1-1/2-12")
        XCTAssertEqual(t.tpi, 12, accuracy: 1e-9)
        XCTAssertEqual(t.major, 1.5, accuracy: 1e-9)
    }

    func testUNFOneInch() {
        let t = Threads.unf.first { $0.name == "1\"-12" }!
        XCTAssertEqual(t.tpi, 12, accuracy: 1e-9)
        XCTAssertEqual(t.major, 1.0, accuracy: 1e-9)
    }

    // MARK: - Metric boundary values and name encoding

    func testMetricFirst() {
        let t = Threads.metric.first!
        XCTAssertEqual(t.name, "M2 \u{D7} 0.4")
        XCTAssertEqual(t.pitch, 0.4, accuracy: 1e-9)
        XCTAssertEqual(t.major, 2.0, accuracy: 1e-9)
    }

    func testMetricLast() {
        let t = Threads.metric.last!
        XCTAssertEqual(t.name, "M36 \u{D7} 4.0")
        XCTAssertEqual(t.pitch, 4.0, accuracy: 1e-9)
        XCTAssertEqual(t.major, 36.0, accuracy: 1e-9)
    }

    func testMetricM14() {
        let t = Threads.metric.first { $0.name.hasPrefix("M14") }!
        XCTAssertEqual(t.pitch, 2.0, accuracy: 1e-9)
        XCTAssertEqual(t.major, 14.0, accuracy: 1e-9)
    }

    // MARK: - Sendable conformance (compile-time check via closure capture)

    func testInchThreadSendable() {
        let t = Threads.unc[0]
        let _: @Sendable () -> String = { t.name }
    }

    func testMetricThreadSendable() {
        let t = Threads.metric[0]
        let _: @Sendable () -> String = { t.name }
    }
}
