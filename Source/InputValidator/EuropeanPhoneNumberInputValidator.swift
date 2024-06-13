import Foundation

public struct EuropeanPhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation _: Validation? = nil) {
        var predefinedValidation = Validation()
        predefinedValidation.minimumLength = 8
        predefinedValidation.maximumLength = 15
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
            valid = validatePartialEuropeanPhoneNumber(composedString)
        }

        return valid
    }

    private func validatePartialEuropeanPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count >= 8 && phoneNumber.count <= 15 {
            return validateEuropeanPhoneNumber(phoneNumber)
        }

        if phoneNumber.hasPrefix("+") {
            return true // Partial European phone number starting with "+"
        }

        return false
    }

    private func validateEuropeanPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberPattern = "^\\+[1-9]\\d{7,14}$"
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

