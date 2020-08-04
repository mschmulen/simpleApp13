import XCTest
@testable import DrawingKit

final class DrawingKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DrawingKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
