import Foundation

/**
 This input validator has required = true, by default.
 */
public struct RequiredInputValidator: InputValidatable {
    public var validation: ValidationRules?

    public init(validation: ValidationRules? = nil) {
        self.validation = validation ?? ValidationRules()
        self.validation?.minimumLength = 1
    }
}
