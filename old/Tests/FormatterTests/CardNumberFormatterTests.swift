import XCTest
import FormTextField

class CardNumberFormatterTests: XCTestCase {
    func testFormatString() {
        let formatter = CardNumberFormatter()
        XCTAssertEqual("1234", formatter.formatString("1234", reverse: false))
        XCTAssertEqual("1234 5", formatter.formatString("12345", reverse: false))
        XCTAssertEqual("1234 56", formatter.formatString("1234 56", reverse: false))
        XCTAssertEqual("1234 5678 9", formatter.formatString("1234 56789", reverse: false))
        XCTAssertEqual("1234 5678 9123 4", formatter.formatString("1234 5678 91234", reverse: false))
        XCTAssertEqual("1234 5678 1234 5678", formatter.formatString("1234 5678 1234 5678", reverse: false))
        XCTAssertEqual("1234 5678 1234 5678", formatter.formatString("1234567812345678", reverse: false))

        XCTAssertEqual("1234 5678 1234 567", formatter.formatString("1234 5678 1234 567", reverse: true))
        XCTAssertEqual("1234 5678 9123", formatter.formatString("1234 5678 9123 ", reverse: true))
        XCTAssertEqual("1234 5678 91", formatter.formatString("1234 5678 91", reverse: true))
        XCTAssertEqual("1234 5678", formatter.formatString("1234 5678 ", reverse: true))
        XCTAssertEqual("1234 56", formatter.formatString("1234 56", reverse: true))
        XCTAssertEqual("1234", formatter.formatString("1234 ", reverse: true))
        XCTAssertEqual("123", formatter.formatString("123", reverse: true))
    }
}
