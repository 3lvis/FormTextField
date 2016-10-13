import UIKit
import Formatter
import InputValidator
import Validation

public protocol FormField {
    var placeholder: String? { get set }
    var inputType: FormTextFieldInputType { get }
    var value: String? { get set }
    var inputValidator: InputValidatable? { get set }
    var formatter: Formattable? { get set }
}

public extension FormField {
    public func validate() -> Bool {
        var isValid = true
        if let inputValidator = self.inputValidator {
            isValid = inputValidator.validateString(self.value ?? "")
        }

        return isValid
    }
}

public struct DefaultFormField: FormField {
    public var placeholder: String?
    public var inputType = FormTextFieldInputType.Default
    public var value: String?
    public var inputValidator: InputValidatable?
    public var formatter: Formattable?

    init() {
    }

    init(placeholder: String?, inputType: FormTextFieldInputType) {
        self.placeholder = placeholder
        self.inputType = inputType
    }

    init(placeholder: String?, inputType: FormTextFieldInputType, initialValue: String?, inputValidator: InputValidatable? = nil, formatter: Formattable? = nil) {
        self.placeholder = placeholder
        self.inputType = inputType
        self.value = initialValue
        self.inputValidator = inputValidator
        self.formatter = formatter
    }
}
