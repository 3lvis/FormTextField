import Foundation

public struct MixedPhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    private let norwegianValidator = NorwegianPhoneNumberInputValidator()
    private let europeanValidator = PhoneNumberInputValidator()

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
        if let aFullString = fullString, let aReplacementString = replacementString, aFullString.isEmpty && aReplacementString.isEmpty && range == NSRange(location: 0, length: 0) {
            return true
        }

        let noSpacesReplacementString = replacementString?.replacingOccurrences(of: " ", with: "")
        let composedString = self.composedString(noSpacesReplacementString, fullString: fullString, inRange: range)
        if composedString.hasPrefix("+") {
            return europeanValidator.validateReplacementString(noSpacesReplacementString, fullString: fullString, inRange: range)
        } else {
            return norwegianValidator.validateReplacementString(noSpacesReplacementString, fullString: fullString, inRange: range)
        }
    }
}
