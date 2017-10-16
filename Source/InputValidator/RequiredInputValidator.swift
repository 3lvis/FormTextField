import Foundation

/**
 This input validator has required = true, by default.
 */
public struct RequiredInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation: Validation? = nil) {
        self.validation = validation ?? Validation()
        self.validation?.minimumLength = 1
    }
}
