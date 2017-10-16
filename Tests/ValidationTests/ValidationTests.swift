import UIKit
import XCTest

class ValidationTests: XCTestCase {
    func testEmptyValidation() {
        let validation = Validation()

        XCTAssertTrue(validation.validateString("1233"))
        XCTAssertTrue(validation.validateString("1234"))
        XCTAssertTrue(validation.validateString("12345"))
        XCTAssertTrue(validation.validateString("123456"))
    }

    func testMaximumLengthValidation() {
        var validation = Validation()
        validation.maximumLength = 5

        XCTAssertTrue(validation.validateString("1234"))
        XCTAssertTrue(validation.validateString("12345"))
        XCTAssertFalse(validation.validateString("123456"))
    }

    func testMinimumLengthValidation() {
        var validation = Validation()
        validation.minimumLength = 5

        XCTAssertFalse(validation.validateString("1234"))
        XCTAssertTrue(validation.validateString("12345"))
        XCTAssertTrue(validation.validateString("123456"))
    }

    func testBetweenLengthsValidation() {
        var validation = Validation()
        validation.minimumLength = 5
        validation.maximumLength = 6

        XCTAssertFalse(validation.validateString("1234"))
        XCTAssertTrue(validation.validateString("12345"))
        XCTAssertTrue(validation.validateString("123456"))
        XCTAssertFalse(validation.validateString("1234567"))

        XCTAssertTrue(validation.validateString("1234", complete: false))
        XCTAssertTrue(validation.validateString("12345", complete: false))
        XCTAssertTrue(validation.validateString("123456", complete: false))
        XCTAssertFalse(validation.validateString("1234567", complete: false))
    }

    func testMaximumValueValidation() {
        var validation = Validation()
        validation.maximumValue = 100

        XCTAssertTrue(validation.validateString("50"))
        XCTAssertTrue(validation.validateString("100"))
        XCTAssertFalse(validation.validateString("200"))
    }

    func testMinimumValueValidation() {
        var validation = Validation()
        validation.minimumValue = 100

        XCTAssertFalse(validation.validateString("50"))
        XCTAssertTrue(validation.validateString("100"))
        XCTAssertTrue(validation.validateString("200"))
    }

    func testBetweenValuesValidation() {
        var validation = Validation()
        validation.minimumValue = 5
        validation.maximumValue = 6

        XCTAssertFalse(validation.validateString("4"))
        XCTAssertTrue(validation.validateString("5"))
        XCTAssertTrue(validation.validateString("6"))
        XCTAssertFalse(validation.validateString("7"))

        XCTAssertTrue(validation.validateString("4", complete: false))
        XCTAssertTrue(validation.validateString("5", complete: false))
        XCTAssertTrue(validation.validateString("6", complete: false))
        XCTAssertFalse(validation.validateString("7", complete: false))
    }

    func testRequiredValidation() {
        var validation = Validation()
        validation.minimumLength = 1

        XCTAssertTrue(validation.validateString("12345"))
        XCTAssertFalse(validation.validateString(""))
    }

    func testEmailFormatValidation() {
        var validation = Validation()
        validation.format = "[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"

        XCTAssertTrue(validation.validateString("elvisnunez@me.co"))
        XCTAssertFalse(validation.validateString("elvnume.co"))
        XCTAssertFalse(validation.validateString("hi there elvisnunez@me.com"))

        XCTAssertTrue(validation.validateString("elvisnunez@me.co", complete: false))
        XCTAssertTrue(validation.validateString("elvnume.co", complete: false))
        XCTAssertTrue(validation.validateString("hi there elvisnunez@me.com", complete: false))
    }

    func testCharacterSetValidation() {
        var validation = Validation()
        validation.characterSet = CharacterSet.decimalDigits
        validation.minimumLength = 1

        XCTAssertFalse(validation.validateString(""))
        XCTAssertTrue(validation.validateString("232132"))
        XCTAssertFalse(validation.validateString("elvnume.co"))
    }

    func testCharacterSetWithSpaceValidation() {
        var validation = Validation()
        var characterSet = CharacterSet.decimalDigits
        characterSet.insert(charactersIn: " ")
        validation.characterSet = characterSet
        validation.minimumLength = 1

        XCTAssertFalse(validation.validateString(""))
        XCTAssertTrue(validation.validateString("5"))
        XCTAssertFalse(validation.validateString("d"))
    }

    func testCharacterSetValidationAllowingEmptyStrings() {
        var validation = Validation()
        validation.characterSet = CharacterSet.decimalDigits

        XCTAssertTrue(validation.validateString(""))
        XCTAssertTrue(validation.validateString("232132"))
        XCTAssertFalse(validation.validateString("elvnume.co"))
    }
}
