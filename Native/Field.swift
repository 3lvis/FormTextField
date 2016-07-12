import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

enum FieldType {
    case Header, Field
}

struct Field {
    let type: FieldType
    let title: String
    let placeholder: String?
    var inputType: FormTextFieldInputType = .Default
    var inputValidator: InputValidatable?
    var formatter: Formattable?

    init(type: FieldType, title: String, placeholder: String? = nil) {
        self.type = type
        self.title = title
        self.placeholder = placeholder
    }

    static func fields() -> [Field] {
        var items = [Field]()

        items.append(Field(type: .Header, title: "Cardholder"))

        var requiredValidation = Validation()
        requiredValidation.required = true
        let requiredInputValidator = InputValidator(validation: requiredValidation)

        let emailField: Field = {
            var field = Field(type: .Field, title: "Email")
            field.inputType = .Email

            var validation = Validation()
            validation.required = true
            validation.format = "[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"
            field.inputValidator = InputValidator(validation: validation)

            return field
        }()
        items.append(emailField)

        let UsernameField: Field = {
            var field = Field(type: .Field, title: "Username")
            field.inputType = .Name
            field.inputValidator = requiredInputValidator
            return field
        }()
        items.append(UsernameField)

        items.append(Field(type: .Header, title: "Billing info"))

        let cardNumberField: Field = {
            var field = Field(type: .Field, title: "Number", placeholder: "Card Number")
            field.inputType = .Integer
            field.formatter = CardNumberFormatter()
            var validation = Validation()
            validation.minimumLength = "1234 5678 1234 5678".characters.count
            validation.maximumLength = "1234 5678 1234 5678".characters.count
            validation.required = true
            let characterSet = NSMutableCharacterSet.decimalDigitCharacterSet()
            characterSet.addCharactersInString(" ")
            validation.characterSet = characterSet
            let inputValidator = InputValidator(validation: validation)
            field.inputValidator = inputValidator
            return field
        }()
        items.append(cardNumberField)

        let expirationDateField: Field = {
            var field = Field(type: .Field, title: "Expires", placeholder: "MM/YYYY")
            field.formatter = CardExpirationDateFormatter()
            field.inputType = .Integer
            var validation = Validation()
            validation.required = true
            let inputValidator = CardExpirationDateInputValidator(validation: validation)
            field.inputValidator = inputValidator
            return field
        }()
        items.append(expirationDateField)

        let securityCodeField: Field = {
            var field = Field(type: .Field, title: "CVV", placeholder: "Security Code")
            field.inputType = .Integer
            var validation = Validation()
            validation.maximumLength = "CVC".characters.count
            validation.minimumLength = "CVC".characters.count
            validation.characterSet = NSCharacterSet.decimalDigitCharacterSet()
            let inputValidator = InputValidator(validation: validation)
            field.inputValidator = inputValidator
            return field
        }()
        items.append(securityCodeField)
        
        return items
    }
}

