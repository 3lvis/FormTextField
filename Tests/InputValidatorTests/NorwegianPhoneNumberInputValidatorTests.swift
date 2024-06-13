import XCTest
import FormTextField
import Foundation

class NorwegianPhoneNumberInputValidatorTests: XCTestCase {
    func testNorwegianPhoneNumberValidator() {
        let validator = NorwegianPhoneNumberInputValidator()

        // Test valid numbers
        XCTAssertTrue(validator.validateReplacementString("23456789", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("91234567", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("48123456", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("98765432", fullString: "", inRange: NSRange(location: 0, length: 0))) // Valid number starting with 9

        // Test invalid numbers
        XCTAssertFalse(validator.validateReplacementString("12345678", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("56789012", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("00000000", fullString: "", inRange: NSRange(location: 0, length: 0)))

        // Test length
        XCTAssertFalse(validator.validateReplacementString("1234567", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too short
        XCTAssertFalse(validator.validateReplacementString("123456789", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too long

        // Test partial valid sequences
        XCTAssertTrue(validator.validateReplacementString("4", fullString: "", inRange: NSRange(location: 0, length: 0))) // Starts with 4
        XCTAssertTrue(validator.validateReplacementString("2", fullString: "", inRange: NSRange(location: 0, length: 0))) // Starts with 2
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "", inRange: NSRange(location: 0, length: 0))) // Starts with 9

        // Test partial valid sequences (2 characters)
        XCTAssertTrue(validator.validateReplacementString("8", fullString: "4", inRange: NSRange(location: 1, length: 0))) // Starts with 4, then 8
        XCTAssertTrue(validator.validateReplacementString("1", fullString: "9", inRange: NSRange(location: 1, length: 0))) // Starts with 4, then 8

        // Test partial invalid sequences (1 character)
        XCTAssertFalse(validator.validateReplacementString("1", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("5", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("0", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start

        // Test partial valid sequences (2 characters)
        XCTAssertTrue(validator.validateReplacementString("8", fullString: "49", inRange: NSRange(location: 1, length: 0))) // "49" becomes "489", which is valid

        // Test other invalid patterns
        XCTAssertFalse(validator.validateReplacementString("12345678", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
    }
}
