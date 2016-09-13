import UIKit

extension UITextField {
    func updateInputType(_ type: FormTextFieldInputType) {
        switch type {
        case .Name:
            self.autocapitalizationType = .words
            self.autocorrectionType = .no
            break

        case .Username:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .namePhonePad
            break

        case .PhoneNumber:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .phonePad
            break

        case .Integer:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .phonePad
            break

        case .Decimal:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .numberPad
            break

        case .Address:
            self.autocapitalizationType = .words
            self.keyboardType = .asciiCapable
            break

        case .Email:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .emailAddress
            break

        case .Password:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .asciiCapable
            self.isSecureTextEntry = true
            break
        default: break
        }
    }
}
