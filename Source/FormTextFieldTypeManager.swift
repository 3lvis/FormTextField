import UIKit

extension UITextField {
    func updateInputType(_ type: FormTextFieldInputType) {
        switch type {
        case .name:
            self.autocapitalizationType = .words
            self.autocorrectionType = .no
            break

        case .username:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .namePhonePad
            break

        case .phoneNumber:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .phonePad
            break

        case .integer:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .phonePad
            break

        case .decimal:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .numberPad
            break

        case .address:
            self.autocapitalizationType = .words
            self.keyboardType = .asciiCapable
            break

        case .email:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .emailAddress
            break

        case .password:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.keyboardType = .asciiCapable
            self.isSecureTextEntry = true
            break
        default: break
        }
    }
}
