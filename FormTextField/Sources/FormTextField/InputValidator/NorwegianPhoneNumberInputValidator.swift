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
            guard let replacementString = replacementString, let range = range else { return false }

            let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            valid = validatePartialNorwegianPhoneNumber(composedString)
        }

        return valid
    }

    private func validatePartialNorwegianPhoneNumber(_ phoneNumber: String) -> Bool {
        guard !phoneNumber.isEmpty else { return true }
        
        if phoneNumber.count == 8 {
            return validateNorwegianPhoneNumber(phoneNumber)
        }

        if phoneNumber.hasPrefix("4") {
            if phoneNumber.count == 1 {
                return true // Just "4" is valid as partial input
            } else if phoneNumber.hasPrefix("48") {
                return true // Longer sequences must start with "48"
            } else {
                return false // Any other "4x" is invalid
            }
        }

        let validStartDigits: Set<Character> = ["2", "3", "9"]
        if let firstDigit = phoneNumber.first {
            return validStartDigits.contains(firstDigit)
        }

        return false
    }

    private func validateNorwegianPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberPattern = "^[2349]\\d{7}$|^48\\d{6}$"
        let regex = try! NSRegularExpression(pattern: phoneNumberPattern)
        let range = NSRange(location: 0, length: phoneNumber.utf16.count)
        return regex.firstMatch(in: phoneNumber, options: [], range: range) != nil
    }

    private func composedString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> String {
        guard let replacementString = replacementString, let fullString = fullString, let range = range else {
            return replacementString ?? fullString ?? ""
        }
        let nsString = fullString as NSString
        return nsString.replacingCharacters(in: range, with: replacementString)
    }
}
