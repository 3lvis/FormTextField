import XCTest
import Foundation
import FormTextField

class InputValidatableTests: XCTestCase {
    func testComposedStringStrings() {
        var validation = Validation()
        validation.maximumLength = 5
        let inputValidator = InputValidator(validation: validation)
        let result = inputValidator.composedString("a", fullString: "n", inRange: NSRange(location: 1, length: 0))
        XCTAssertEqual(result, "na")
    }

    func testComposedStringEmoji() {
        var validation = Validation()
        validation.maximumLength = 5
        let inputValidator = InputValidator(validation: validation)
        let result = inputValidator.composedString("👌", fullString: "💕", inRange: NSRange(location: 2, length: 0))
        XCTAssertEqual(result, "💕👌")
    }
}
