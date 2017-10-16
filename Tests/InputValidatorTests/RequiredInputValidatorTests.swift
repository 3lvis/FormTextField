import XCTest
import Foundation

class RequiredInputValidatorTests: XCTestCase {
    func testValidation() {
        let validator = RequiredInputValidator()
        XCTAssertTrue(validator.validateString("12/12"))
        XCTAssertFalse(validator.validateString(""))
    }
}
