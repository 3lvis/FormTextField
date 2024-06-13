import XCTest
import FormTextField

class CardExpirationDateFormatterTests: XCTestCase {
    func testFormatString() {
        let formatter = CardExpirationDateFormatter()

        // Typing forward (adding characters)
        XCTAssertEqual("1", formatter.formatString("1", reverse: false))
        XCTAssertEqual("12/", formatter.formatString("12", reverse: false))
        XCTAssertEqual("12/1", formatter.formatString("121", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("1212", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("12/12", reverse: false))

        // Deleting characters (removing characters)
        XCTAssertEqual("1", formatter.formatString("1", reverse: true))
        XCTAssertEqual("12", formatter.formatString("12/", reverse: true))
        XCTAssertEqual("121", formatter.formatString("12/1", reverse: true))
        XCTAssertEqual("1212", formatter.formatString("12/12", reverse: true))

        // Edge cases for real-time input scenarios
        XCTAssertEqual("", formatter.formatString("", reverse: false)) // Empty string
        XCTAssertEqual("", formatter.formatString("", reverse: true)) // Empty string reverse
        XCTAssertEqual("12/", formatter.formatString("12", reverse: false)) // Ensuring "12" becomes "12/"
        XCTAssertEqual("12", formatter.formatString("12/", reverse: true)) // Ensuring "12/" becomes "12"
        XCTAssertEqual("12/3", formatter.formatString("123", reverse: false)) // Typing beyond "12"
        XCTAssertEqual("123", formatter.formatString("12/3", reverse: true)) // Deleting back to "123"
        XCTAssertEqual("12/34", formatter.formatString("1234", reverse: false)) // Typing full expiration date
        XCTAssertEqual("1234", formatter.formatString("12/34", reverse: true)) // Deleting full expiration date
    }
}
