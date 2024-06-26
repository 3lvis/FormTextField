import XCTest
import Foundation
import FormTextField

class MixedPhoneNumberInputValidatorTests: XCTestCase {
    func testNorwegianPhoneNumbers() {
        let validator = MixedPhoneNumberInputValidator()

        XCTAssertTrue(validator.validateString("91234567"))
        XCTAssertTrue(validator.validateString("48123456"))
        XCTAssertTrue(validator.validateString("98765432"))

        XCTAssertFalse(validator.validateString("11234567"))
        XCTAssertFalse(validator.validateString("28123456"))
        XCTAssertFalse(validator.validateString("9876543"))

        // Test valid numbers
        XCTAssertTrue(validator.validateReplacementString("91234567", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("48123456", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("98765432", fullString: "", inRange: NSRange(location: 0, length: 0))) // Valid number starting with 9

        // Test invalid numbers
        XCTAssertFalse(validator.validateReplacementString("23456789", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("12345678", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("56789012", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("00000000", fullString: "", inRange: NSRange(location: 0, length: 0)))

        // Test length
        XCTAssertFalse(validator.validateReplacementString("1234567", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too short
        XCTAssertFalse(validator.validateReplacementString("123456789", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too long

        // Test partial valid sequences
        XCTAssertTrue(validator.validateReplacementString("4", fullString: "", inRange: NSRange(location: 0, length: 0))) // Starts with 4
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "", inRange: NSRange(location: 0, length: 0))) // Starts with 9

        // Test partial valid sequences (2 characters)
        XCTAssertTrue(validator.validateReplacementString("8", fullString: "4", inRange: NSRange(location: 1, length: 0))) // Starts with 4, then 8
        XCTAssertTrue(validator.validateReplacementString("1", fullString: "9", inRange: NSRange(location: 1, length: 0))) // Starts with 9, then 1
        XCTAssertTrue(validator.validateReplacementString("8", fullString: "49", inRange: NSRange(location: 1, length: 0))) // "49" becomes "489", which is valid
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "49", inRange: NSRange(location: 2, length: 0))) // "49" becomes "499"
        XCTAssertTrue(validator.validateReplacementString("8", fullString: "49", inRange: NSRange(location: 2, length: 0))) // "49" becomes "498"

        // Test partial invalid sequences (1 character)
        XCTAssertFalse(validator.validateReplacementString("1", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("5", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("0", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("2", fullString: "", inRange: NSRange(location: 0, length: 0))) // Starts with 2

        // Test partial invalid sequences (2 characters)
        XCTAssertFalse(validator.validateReplacementString("3", fullString: "2", inRange: NSRange(location: 1, length: 0))) // Starts with 2, then 3

        // Test valid sequences extended (3 characters)
        XCTAssertTrue(validator.validateReplacementString("1", fullString: "481", inRange: NSRange(location: 3, length: 0))) // "481" is a valid sequence
        XCTAssertFalse(validator.validateReplacementString("5", fullString: "235", inRange: NSRange(location: 3, length: 0))) // "235" is an invalid sequence

        // Test other invalid patterns
        XCTAssertFalse(validator.validateReplacementString("12345678", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
    }

    func testEuropeanPhoneNumbers() {
        let validator = MixedPhoneNumberInputValidator()

        XCTAssertTrue(validator.validateString("+447911123456"))
        XCTAssertTrue(validator.validateString("+33612345678"))
        XCTAssertTrue(validator.validateString("+491711234567"))

        XCTAssertFalse(validator.validateString("+336123456789012345"))
        XCTAssertFalse(validator.validateString("+0044711123456"))
        XCTAssertFalse(validator.validateString("+4479111234567890123456"))
        XCTAssertFalse(validator.validateString("+4479"))

        // Test valid European numbers
        XCTAssertTrue(validator.validateReplacementString("+447911123456", fullString: "", inRange: NSRange(location: 0, length: 0))) // UK
        XCTAssertTrue(validator.validateReplacementString("+33612345678", fullString: "", inRange: NSRange(location: 0, length: 0))) // France
        XCTAssertTrue(validator.validateReplacementString("+491711234567", fullString: "", inRange: NSRange(location: 0, length: 0))) // Germany
        XCTAssertTrue(validator.validateReplacementString("+390212345678", fullString: "", inRange: NSRange(location: 0, length: 0))) // Italy
        XCTAssertTrue(validator.validateReplacementString("+46701234567", fullString: "", inRange: NSRange(location: 0, length: 0))) // Sweden
        XCTAssertTrue(validator.validateReplacementString("+358401234567", fullString: "", inRange: NSRange(location: 0, length: 0))) // Finland
        XCTAssertTrue(validator.validateReplacementString("+4746171500", fullString: "", inRange: NSRange(location: 0, length: 0))) // Finland

        // Test invalid European numbers
        XCTAssertFalse(validator.validateReplacementString("+336123456789012345", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too long
        XCTAssertFalse(validator.validateReplacementString("+0044711123456", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid country code
        XCTAssertFalse(validator.validateReplacementString("+4479111234567890123456", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too long

        // Test partial valid sequences
        XCTAssertTrue(validator.validateReplacementString("", fullString: "+", inRange: NSRange(location: 0, length: 1))) // Was + to become empty
        XCTAssertTrue(validator.validateReplacementString("+", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("4", fullString: "+", inRange: NSRange(location: 1, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("4", fullString: "+4", inRange: NSRange(location: 2, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("7", fullString: "+44", inRange: NSRange(location: 3, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "+447", inRange: NSRange(location: 4, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "+4479", inRange: NSRange(location: 5, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "+44791", inRange: NSRange(location: 6, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "+447915", inRange: NSRange(location: 7, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "+4479151", inRange: NSRange(location: 8, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("9", fullString: "+44791514", inRange: NSRange(location: 9, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("+492234567", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("+492234567", fullString: "", inRange: NSRange(location: 0, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("+441234", fullString: "", inRange: NSRange(location: 0, length: 0)))

        // Test partial invalid sequences
        XCTAssertFalse(validator.validateReplacementString("+0", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("+01", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("+004", fullString: "", inRange: NSRange(location: 0, length: 0))) // Invalid start
        XCTAssertFalse(validator.validateReplacementString("+491234567890123456", fullString: "", inRange: NSRange(location: 0, length: 0))) // Too long
        XCTAssertFalse(validator.validateReplacementString("+44a12345678", fullString: "", inRange: NSRange(location: 0, length: 0))) // Contains non-numeric character
    }
}
