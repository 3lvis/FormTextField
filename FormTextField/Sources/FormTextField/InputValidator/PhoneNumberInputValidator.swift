import Foundation

public struct PhoneNumberInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation: Validation? = nil) {
        var predefinedValidation = Validation()
        predefinedValidation.minimumLength = 8
        predefinedValidation.maximumLength = 15
        var characterSet = CharacterSet.decimalDigits
        characterSet.insert(charactersIn: "+")
        predefinedValidation.characterSet = characterSet
        self.validation = predefinedValidation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        if valid {
            let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            valid = validatePartialEuropeanPhoneNumber(composedString)
        }

        return valid
    }

    private func validatePartialEuropeanPhoneNumber(_ phoneNumber: String) -> Bool {
        guard !phoneNumber.isEmpty else { return true }

        // Allow a single "+" as valid partial input
        if phoneNumber == "+" {
            return true
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
}
