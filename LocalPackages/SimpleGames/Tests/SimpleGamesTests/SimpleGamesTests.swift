import XCTest
@testable import SimpleGames

final class SimpleGamesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SimpleGames().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
