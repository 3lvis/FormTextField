import UIKit

extension UITextField {
    func updateInputType(type: TextFieldInputType) {
        switch type {
        case .Default, .Unknown:
            self.autocapitalizationType = .Sentences
            self.autocorrectionType = .Default
            self.keyboardType = .Default
            self.secureTextEntry = false
            break

        case .Name:
            self.autocapitalizationType = .Words
            self.autocorrectionType = .No
            self.keyboardType = .NamePhonePad
            self.secureTextEntry = false
            break

        case .Username:
            self.autocapitalizationType = .None
            self.autocorrectionType = .No
            self.keyboardType = .NamePhonePad
            self.secureTextEntry = false
            break

        case .PhoneNumber:
            self.autocapitalizationType = .None
            self.autocorrectionType = .No
            self.keyboardType = .PhonePad
            self.secureTextEntry = false
            break

        case .Integer:
            self.autocapitalizationType = .None
            self.autocorrectionType = .No
            self.keyboardType = .PhonePad
            self.secureTextEntry = false
            break

        case .Decimal:
            self.autocapitalizationType = .None
            self.autocorrectionType = .No
            self.keyboardType = .NumberPad
            self.secureTextEntry = false
            break

        case .Address:
            self.autocapitalizationType = .Words
            self.autocorrectionType = .Default
            self.keyboardType = .ASCIICapable
            self.secureTextEntry = false
            break

        case .Email:
            self.autocapitalizationType = .None
            self.autocorrectionType = .No
            self.keyboardType = .EmailAddress
            self.secureTextEntry = false
            break

        case .Password:
            self.autocapitalizationType = .None
            self.autocorrectionType = .No
            self.keyboardType = .ASCIICapable
            self.secureTextEntry = true
            break
        }
    }
}
