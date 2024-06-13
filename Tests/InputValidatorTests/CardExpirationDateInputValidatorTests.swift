import XCTest
import Foundation
import FormTextField

class CardExpirationDateInputValidatorTests: XCTestCase {
    func testCardExpirationDate() {
        let validator = CardExpirationDateInputValidator()
        XCTAssertTrue(validator.validateString("12/34"))

        // 1st character: First character can be 0, 1
        let oneCharacter = ""
        let oneCharacterLength = oneCharacter.count
        XCTAssertTrue(validator.validateReplacementString("0", fullString: "", inRange: NSRange(location: oneCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("1", fullString: "", inRange: NSRange(location: oneCharacterLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("2", fullString: "", inRange: NSRange(location: oneCharacterLength, length: 0)))

        // 2nd character: The second character composed with the first one should be equal or less than 12
        let secondCharacter = "1"
        let secondCharacterLength = secondCharacter.count
        XCTAssertTrue(validator.validateReplacementString("1", fullString: "0", inRange: NSRange(location: secondCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("2", fullString: "1", inRange: NSRange(location: secondCharacterLength, length: 0)))
        XCTAssertFalse(validator.validateReplacementString("3", fullString: "1", inRange: NSRange(location: secondCharacterLength, length: 0)))

        // 3rd character: The third character is the '/'
        let thirdCharacter = "MM"
        let thirdCharacterLength = thirdCharacter.count
        XCTAssertFalse(validator.validateReplacementString("0", fullString: "12", inRange: NSRange(location: thirdCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString("/", fullString: "12", inRange: NSRange(location: thirdCharacterLength, length: 0)))

        // Dynamically determine the current decade and year
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let currentYear = components.year!

        let decade = (currentYear / 10) % 10
        let yearLastDigit = currentYear % 10
        let nextYearLastDigit = (yearLastDigit + 1) % 10

        // 4th character: The fourth character has to be higher than or equal to the decimal of the current year.
        // For example, if the current year is 2024, then the fourth character has to be equal or higher than 2
        let fourthCharacter = "MM/"
        let fourthCharacterLength = fourthCharacter.count
        XCTAssertFalse(validator.validateReplacementString(String(decade - 1), fullString: "12/", inRange: NSRange(location: fourthCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString(String(decade), fullString: "12/", inRange: NSRange(location: fourthCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString(String(decade + 1), fullString: "12/", inRange: NSRange(location: fourthCharacterLength, length: 0)))

        // 5th character: The fifth character composed with the fourth character should be equal or higher than the current year
        let fifthCharacter = "MM/\(decade)"
        let fifthCharacterLength = fifthCharacter.count
        XCTAssertFalse(validator.validateReplacementString(String(yearLastDigit - 1), fullString: "12/\(decade)", inRange: NSRange(location: fifthCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString(String(yearLastDigit), fullString: "12/\(decade)", inRange: NSRange(location: fifthCharacterLength, length: 0)))
        XCTAssertTrue(validator.validateReplacementString(String(nextYearLastDigit), fullString: "12/\(decade)", inRange: NSRange(location: fifthCharacterLength, length: 0)))
    }
}
