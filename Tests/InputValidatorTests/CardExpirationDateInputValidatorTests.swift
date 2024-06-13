import XCTest
import Foundation
import FormTextField

class CardExpirationDateInputValidatorTests: XCTestCase {
    func testCardExpirationDate() {
        // Create a specific baseline date for testing (e.g., June 15, 2024)
        let testDateComponents = DateComponents(year: 2024, month: 6, day: 15)
        let calendar = Calendar.current
        let baselineDate = calendar.date(from: testDateComponents)!
        var validator = CardExpirationDateInputValidator()
        validator.baselineDate = baselineDate

        // Dynamically determine the current decade and year
        let components = calendar.dateComponents([.year, .month], from: baselineDate)
        let currentYear = components.year!
        let currentMonth = components.month!

        let decade = (currentYear / 10) % 10
        let yearLastDigit = currentYear % 10
        let nextYearLastDigit = (yearLastDigit + 1) % 10

        // Full date: Ensure expired date is invalid and future date is valid
        let currentYearString = String(currentYear % 100)
        let previousYearString = String((currentYear - 1) % 100)
        let nextYearString = String((currentYear + 1) % 100)

        let currentMonthString = currentMonth < 10 ? "0\(currentMonth)" : "\(currentMonth)"
        let nextMonthString = currentMonth < 9 ? "0\(currentMonth + 1)" : "\(currentMonth + 1)"
        let previousMonthString = currentMonth > 1 ? (currentMonth - 1 < 10 ? "0\(currentMonth - 1)" : "\(currentMonth - 1)") : "12"

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

        // 4th character: The fourth character has to be higher than or equal to the decimal of the current year.
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

        // Current month and year (should be valid)
        XCTAssertTrue(validator.validateString("\(currentMonthString)/\(currentYearString)"))

        // Next month and current year (should be valid)
        XCTAssertTrue(validator.validateString("\(nextMonthString)/\(currentYearString)"))

        // Previous month and current year (should be invalid)
        let previousMonthAndCurrentYear = "\(previousMonthString)/\(currentYearString)"
        XCTAssertFalse(validator.validateString(previousMonthAndCurrentYear))

        // Any month and next year (should be valid)
        XCTAssertTrue(validator.validateString("01/\(nextYearString)"))

        // Any month and previous year (should be invalid)
        let anyMonthAndPreviousYear = "12/\(previousYearString)"
        XCTAssertFalse(validator.validateString(anyMonthAndPreviousYear))
    }
}
