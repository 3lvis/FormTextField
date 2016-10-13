import UIKit
import Formatter
import InputValidator
import Validation

public class FormField {
    var placeholder: String?
    var inputType: FormTextFieldInputType = .Default
    var inputValidator: InputValidatable?
    var formatter: Formattable?
    var value: String?
}
