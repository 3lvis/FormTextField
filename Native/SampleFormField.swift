import UIKit
import Formatter
import InputValidator
import Validation

enum FieldType {
    case header, field
}

struct SampleFormField: FormField {
    var placeholder: String?
    var inputType = FormTextFieldInputType.Default
    var inputValidator: InputValidatable?
    var formatter: Formattable?
    var value: String?
    var type = FieldType.field
    let title: String

    init(type: FieldType, title: String, placeholder: String? = nil) {
        self.type = type
        self.title = title
        self.placeholder = placeholder
    }
}
