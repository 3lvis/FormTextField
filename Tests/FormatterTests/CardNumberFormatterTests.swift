import XCTest

class CardNumberFormatterTests: XCTestCase {
    func testFormatString() {
        let formatter = CardNumberFormatter()
        XCTAssertEqual("1234", formatter.formatString("1234", reverse: false))
        XCTAssertEqual("1234 5", formatter.formatString("12345", reverse: false))
        XCTAssertEqual("1234 5678 1234 5678", formatter.formatString("1234567812345678", reverse: false))
        XCTAssertEqual("1234 5678 1234 5678", formatter.formatString("1234 5678 1234 5678", reverse: false))
    }
}
