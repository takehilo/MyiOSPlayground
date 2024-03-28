import XCTest
@testable import SharedModel

final class SharedModelTests: XCTestCase {
    func testUser() throws {
        XCTAssertEqual(User(name: "alice").name, "alice")
    }
}
