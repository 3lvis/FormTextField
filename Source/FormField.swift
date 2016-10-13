import UIKit
import Formatter
import InputValidator
import Validation

public protocol FormField {
    var placeholder: String? { get set }
    var inputType: FormTextFieldInputType { get }
    var inputValidator: InputValidatable? { get set }
    var formatter: Formattable? { get set }
    var value: String? { get set }
}

class BaseFormField: FormField {
    var placeholder: String?
    var inputType = FormTextFieldInputType.Default
    var inputValidator: InputValidatable?
    var formatter: Formattable?
    var value: String?
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
