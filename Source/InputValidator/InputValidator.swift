import Foundation

public struct InputValidator: InputValidatable {
    public var validation: ValidationRules?

    public init(validation: ValidationRules? = nil) {
        self.validation = validation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        return valid
    }
}
