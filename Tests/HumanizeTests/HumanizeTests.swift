import XCTest
@testable import Humanize

final class HumanizeTests: XCTestCase {
    func tests() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        //MARK: - Files Tests
        XCTAssertEqual(Humanize().naturalSize(2747829994), "2.75 GB")
        XCTAssertEqual(Humanize().naturalSize(2747829994, type: .binary), "2.56 GB")
        
        
        //MARK: - Numbers Tests
        
        XCTAssertEqual(Humanize().ordinal(385), "385th")
        XCTAssertEqual(Humanize().comma(2858493.49), "2,858,493.49")
        XCTAssertEqual(Humanize().word(3456782984), "3.46 billion")
        XCTAssertEqual(Humanize().fraction(0.4456), "41/92")
        XCTAssertEqual(Humanize().scientific(0.000000385384), "3.85 × 10⁻⁷")
        XCTAssertEqual(Humanize().clamp(123.456, ceil: 120), ">120.0")
        
        print(Humanize().word(1000))
        
        //MARK: - Time Tests
        XCTAssertEqual(Humanize().naturalDate(date: Date()), "Today")
        XCTAssertEqual(Humanize().naturalDate(date: Date() - Date.DTTimeDelta(day: 1)), "Yesterday")
        XCTAssertEqual(Humanize().naturalDate(date: Date() + Date.DTTimeDelta(month: 6)), "09 Jan, 2022")
        XCTAssertEqual(Humanize().naturalTime(date: Date() - Date.DTTimeDelta(second: 14400)), "4 hours ago")
    }
}
