import UIKit
import FormTextField

enum FieldType {
    case header, field
}

struct Field {
    let type: FieldType
    let title: String
    let placeholder: String?
    var inputType: FormTextFieldInputType = .default
    var inputValidator: InputValidatable?
    var formatter: Formattable?

    init(type: FieldType, title: String, placeholder: String? = nil) {
        self.type = type
        self.title = title
        self.placeholder = placeholder
    }

    static func fields() -> [Field] {
        var items = [Field]()

        items.append(Field(type: .header, title: "Cardholder"))

        var requiredValidation = Validation()
        requiredValidation.minimumLength = 1
        let requiredInputValidator = InputValidator(validation: requiredValidation)

        let emailField: Field = {
            var field = Field(type: .field, title: "Email")
            field.inputType = .email

            var validation = Validation()
            validation.minimumLength = 1
            validation.format = "[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"
            field.inputValidator = InputValidator(validation: validation)

            return field
        }()
        items.append(emailField)

        let UsernameField: Field = {
            var field = Field(type: .field, title: "Username")
            field.inputType = .name
            field.inputValidator = requiredInputValidator

            return field
        }()
        items.append(UsernameField)

        items.append(Field(type: .header, title: "Billing info"))

        let cardNumberField: Field = {
            var field = Field(type: .field, title: "Number", placeholder: "Card Number")
            field.inputType = .integer
            field.formatter = CardNumberFormatter()
            var validation = Validation()
            validation.minimumLength = "1234 5678 1234 5678".count
            validation.maximumLength = "1234 5678 1234 5678".count
            let characterSet = NSMutableCharacterSet.decimalDigit()
            characterSet.addCharacters(in: " ")
            validation.characterSet = characterSet as CharacterSet
            let inputValidator = InputValidator(validation: validation)
            field.inputValidator = inputValidator

            return field
        }()
        items.append(cardNumberField)

        let expirationDateField: Field = {
            var field = Field(type: .field, title: "Expires", placeholder: "MM/YY")
            field.formatter = CardExpirationDateFormatter()
            field.inputType = .integer
            var validation = Validation()
            validation.minimumLength = 1
            let inputValidator = CardExpirationDateInputValidator(validation: validation)
            field.inputValidator = inputValidator

            return field
        }()
        items.append(expirationDateField)

        let securityCodeField: Field = {
            var field = Field(type: .field, title: "CVC", placeholder: "Security Code")
            field.inputType = .integer
            var validation = Validation()
            validation.maximumLength = "CVC".count
            validation.minimumLength = "CVC".count
            validation.characterSet = CharacterSet.decimalDigits
            let inputValidator = InputValidator(validation: validation)
            field.inputValidator = inputValidator

            return field
        }()
        items.append(securityCodeField)

        return items
    }
}
