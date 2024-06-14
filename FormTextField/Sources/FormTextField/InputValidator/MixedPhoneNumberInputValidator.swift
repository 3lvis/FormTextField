import Foundation

public struct MixedPhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    private let norwegianValidator = NorwegianPhoneNumberInputValidator()
    private let europeanValidator = EuropeanPhoneNumberInputValidator()

    public init(validation: Validation? = nil) {
        self.validation = validation
    }

    public func validateString(_ string: String) -> Bool {
        if string.hasPrefix("+") {
            return europeanValidator.validateString(string)
        } else {
            return norwegianValidator.validateString(string)
        }
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)

        if composedString.hasPrefix("+") {
            return europeanValidator.validateReplacementString(replacementString, fullString: fullString, inRange: range)
        } else {
            return norwegianValidator.validateReplacementString(replacementString, fullString: fullString, inRange: range)
        }
    }
}
