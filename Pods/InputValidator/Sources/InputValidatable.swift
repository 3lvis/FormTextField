import Foundation
import Validation

public protocol InputValidatable {
    var validation: Validation? { get }

    init(validation: Validation?)

    func validateString(string: String) -> Bool

    // This method is useful for partial validations, or validations where the final string is
    // in process of been completed. For example when entering characters into an UITextField.
    func validateReplacementString(replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool
}

extension InputValidatable {
    public func validateString(string: String) -> Bool {
        var valid = true
        if let validation = self.validation {
            valid = validation.validateString(string)
        }

        if valid {
            valid = self.validateReplacementString(nil, fullString: string, inRange: nil)
        }

        return valid
    }

    public func validateReplacementString(replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        return valid
    }

    public func composedString(replacementString: String?, fullString: String?, inRange range: NSRange?) -> String {
        var composedString = fullString ?? ""

        if let replacementString = replacementString, range = range {
            let index = composedString.startIndex.advancedBy(range.location)
            if range.location == composedString.characters.count {
                composedString.insertContentsOf(replacementString.characters, at: index)
            } else {
                composedString = (composedString as NSString).stringByReplacingCharactersInRange(range, withString: replacementString)
            }
            return composedString
        }

        return composedString
    }
}
