import UIKit
import Formatter
import InputValidator
import Validation

enum FieldType {
    case header, field
}

class SampleFormField: FormField {
    let type: FieldType
    let title: String

    init(type: FieldType, title: String, placeholder: String? = nil) {
        self.type = type
        self.title = title

        super.init()

        self.placeholder = placeholder
    }
}
