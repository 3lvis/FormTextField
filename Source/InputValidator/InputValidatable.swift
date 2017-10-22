import Foundation

public protocol InputValidatable {
    var validation: Validation? { get }

    init(validation: Validation?)

    func validateString(_ string: String) -> Bool

    // This method is useful for partial validations, or validations where the final string is
    // in process of been completed. For example when entering characters into an UITextField.
    func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool
}

extension InputValidatable {
    public func validateString(_ string: String) -> Bool {
        var valid = true
        if let validation = self.validation {
            valid = validation.validateString(string)
        }

        if valid {
            valid = validateReplacementString(nil, fullString: string, inRange: nil)
        }

        return valid
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        return valid
    }

    public func composedString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> String {
        if let replacementString = replacementString, let range = range, let fullString = fullString as NSString? {
            return fullString.replacingCharacters(in: range, with: replacementString)
        }

        return fullString ?? ""
    }
}
