import XCTest
import FormTextField

class DecimalInputValidatorTests: XCTestCase {
    func testDecimal() {
        let validator = DecimalInputValidator()
        XCTAssertTrue(validator.validateString("3123"))
        XCTAssertTrue(validator.validateString("3,123"))
        XCTAssertTrue(validator.validateString("3.123"))
        XCTAssertFalse(validator.validateString("3,"))
        XCTAssertFalse(validator.validateString("3."))
        XCTAssertFalse(validator.validateString("3,1,23"))
        XCTAssertFalse(validator.validateString("3.1.23"))
        XCTAssertFalse(validator.validateString("321/222"))

        // 1st character
        var fullString = ""
        var fullStringLength = fullString.count
        XCTAssertTrue(validator.validateReplacementString("0", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString(",", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString(".", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("/", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))

        // 2nd character:
        fullString = "1"
        fullStringLength = fullString.count
        XCTAssertTrue(validator.validateReplacementString("1", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString(",", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString(".", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("/", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))

        // 3rd character:
        fullString = "1,"
        fullStringLength = fullString.count
        XCTAssertTrue(validator.validateReplacementString("1", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString(",", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString(".", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("/", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))

        // 3rd character alternative:
        fullString = "1."
        fullStringLength = fullString.count
        XCTAssertTrue(validator.validateReplacementString("1", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString(",", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString(".", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("/", fullString: fullString, inRange: NSRange(location: fullStringLength, length: 0)))
    }
}
