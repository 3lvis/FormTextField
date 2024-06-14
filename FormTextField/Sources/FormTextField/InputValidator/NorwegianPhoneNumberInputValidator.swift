import Foundation

public struct NorwegianPhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation _: Validation? = nil) {
        var predefinedValidation = Validation()
        predefinedValidation.minimumLength = 8
        predefinedValidation.maximumLength = 8
        validation = predefinedValidation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        if valid {
            let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            valid = validatePartialNorwegianPhoneNumber(composedString)
        }

        return valid
    }

    private func validatePartialNorwegianPhoneNumber(_ phoneNumber: String) -> Bool {
        guard !phoneNumber.isEmpty else { return true }

        return phoneNumber.hasPrefix("4") || phoneNumber.hasPrefix("9")
    }

    private func composedString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> String {
        guard let replacementString = replacementString, let fullString = fullString, let range = range else {
            return replacementString ?? fullString ?? ""
        }
        let nsString = fullString as NSString
        return nsString.replacingCharacters(in: range, with: replacementString)
    }
}
