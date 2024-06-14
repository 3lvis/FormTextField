import Foundation

public struct MixedPhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    private let norwegianValidator = NorwegianPhoneNumberInputValidator()
    private let europeanValidator = EuropeanPhoneNumberInputValidator()

    public init(validation: Validation? = nil) {
        self.validation = validation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        guard let replacementString = replacementString, let range = range else { return false }

        let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)

        if composedString.hasPrefix("+") {
            return europeanValidator.validateReplacementString(replacementString, fullString: fullString, inRange: range)
        } else {
            return norwegianValidator.validateReplacementString(replacementString, fullString: fullString, inRange: range)
        }
    }
}
