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

struct BaseFormField: FormField {
    var placeholder: String?
    var inputType = FormTextFieldInputType.Default
    var inputValidator: InputValidatable?
    var formatter: Formattable?
    var value: String?
 }
