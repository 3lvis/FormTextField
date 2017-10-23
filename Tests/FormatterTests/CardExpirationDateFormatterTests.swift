import XCTest
import FormTextField

class CardExpirationDateFormatterTests: XCTestCase {
    func testFormatString() {
        let formatter = CardExpirationDateFormatter()
        XCTAssertEqual("1", formatter.formatString("1", reverse: false))
        XCTAssertEqual("12/", formatter.formatString("12", reverse: false))
        XCTAssertEqual("12/1", formatter.formatString("121", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("1212", reverse: false))
        XCTAssertEqual("12/12", formatter.formatString("12/12", reverse: false))

        XCTAssertEqual("1", formatter.formatString("1", reverse: true))
        XCTAssertEqual("12", formatter.formatString("12/", reverse: true))
        XCTAssertEqual("121", formatter.formatString("12/1", reverse: true))
        XCTAssertEqual("1212", formatter.formatString("12/12", reverse: true))
    }
}
