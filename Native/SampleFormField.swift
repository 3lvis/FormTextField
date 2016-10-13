import UIKit
import Formatter
import InputValidator
import Validation

enum FieldType {
    case header, field
}

class SampleFormField: FormField {
    var returnKeyType = UIReturnKeyType.default
    var placeholder: String?
    var inputType = FormTextFieldInputType.default
    var inputValidator: InputValidatable?
    var formatter: Formattable?
    var value: String?
    var type = FieldType.field
    let title: String
    var indexPath: IndexPath?

    init(type: FieldType, title: String, placeholder: String? = nil) {
        self.type = type
        self.title = title
        self.placeholder = placeholder
    }
}
