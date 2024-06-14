import Foundation

public struct EuropeanPhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation: Validation? = nil) {
        var predefinedValidation = Validation()
        predefinedValidation.minimumLength = 8
        predefinedValidation.maximumLength = 15
        self.validation = predefinedValidation
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
        // Allow a single "+" as valid partial input
        if phoneNumber == "+" {
            return true
        }

        // Handle valid complete numbers within length limits
        if phoneNumber.count >= 8 && phoneNumber.count <= 15 {
            return validateEuropeanPhoneNumber(phoneNumber)
        }

        // Handle partial sequences starting with "+"
        if phoneNumber.hasPrefix("+") {
            let withoutPlus = String(phoneNumber.dropFirst())
            // Ensure the first digit after "+" is between 1 and 9
            if let firstDigit = withoutPlus.first {
                if ("1"..."9").contains(firstDigit) {
                    return true
                }
            }
        }

        return false
    }
    private func validateEuropeanPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberPattern = "^\\+([1-9]\\d{0,2})\\d{7,14}$"
        let regex = try! NSRegularExpression(pattern: phoneNumberPattern)
        let range = NSRange(location: 0, length: phoneNumber.utf16.count)
        return regex.firstMatch(in: phoneNumber, options: [], range: range) != nil
    }
}
