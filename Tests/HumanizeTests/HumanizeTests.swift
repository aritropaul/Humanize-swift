import XCTest
@testable import Humanize

final class HumanizeTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print(Humanize().naturalSize(2747829994))
        print(Humanize().ordinal(385))
        print(Humanize().comma(2858493.49))
        print(Humanize().word(3456782984))
        print(Humanize().fraction(0.4456))
    }
}
