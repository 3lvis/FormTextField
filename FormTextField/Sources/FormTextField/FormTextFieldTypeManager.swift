import UIKit

extension UITextField {
    func updateInputType(_ type: FormTextFieldInputType) {
        switch type {
        case .name:
            autocapitalizationType = .words
            autocorrectionType = .no
            break

        case .username:
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .namePhonePad
            break

        case .phoneNumber:
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .phonePad
            break

        case .integer:
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .phonePad
            break

        case .decimal:
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .numberPad
            break

        case .address:
            autocapitalizationType = .words
            keyboardType = .asciiCapable
            break

        case .email:
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .emailAddress
            break

        case .password:
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .asciiCapable
            isSecureTextEntry = true
            break
        default: break
        }
    }
}
