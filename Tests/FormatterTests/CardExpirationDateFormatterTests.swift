import XCTest
import FormTextField

class CardExpirationDateFormatterTests: XCTestCase {
    func testFormatString() {
        let formatter = CardExpirationDateFormatter()

        // Typing forward (adding characters)
        XCTAssertEqual("1", formatter.formatString("1", reverse: false))
        XCTAssertEqual("12/", formatter.formatString("12", reverse: false))
        XCTAssertEqual("12/1", formatter.formatString("12/1", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("12/12", reverse: false))

        XCTAssertEqual("1", formatter.formatString("1", reverse: false))
        XCTAssertEqual("12/", formatter.formatString("12", reverse: false))
        XCTAssertEqual("12/1", formatter.formatString("12/1", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("12/12", reverse: false))

        // Deleting characters (removing characters)
        XCTAssertEqual("1", formatter.formatString("1", reverse: true))
        XCTAssertEqual("11", formatter.formatString("11", reverse: true))
        XCTAssertEqual("12", formatter.formatString("12/", reverse: true))
        XCTAssertEqual("12/1", formatter.formatString("12/1", reverse: true))
        XCTAssertEqual("12/12", formatter.formatString("12/12", reverse: true))

        // Edge cases for real-time input scenarios
        XCTAssertEqual("", formatter.formatString("", reverse: false))
        XCTAssertEqual("", formatter.formatString("", reverse: true))
        XCTAssertEqual("12/", formatter.formatString("12", reverse: false))
        XCTAssertEqual("12", formatter.formatString("12/", reverse: true))
        XCTAssertEqual("12/3", formatter.formatString("12/3", reverse: false))
        XCTAssertEqual("12/3", formatter.formatString("12/3", reverse: true))
        XCTAssertEqual("12/34", formatter.formatString("12/34", reverse: false))
        XCTAssertEqual("12/34", formatter.formatString("12/34", reverse: true))

        XCTAssertEqual("11/1", formatter.formatString("111", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("1212", reverse: false))

        XCTAssertEqual("11/1", formatter.formatString("111", reverse: true))
        XCTAssertEqual("12/12", formatter.formatString("1212", reverse: true))
    }
}
