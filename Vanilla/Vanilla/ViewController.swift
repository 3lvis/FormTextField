import UIKit
import FormTextField

class ViewController: UIViewController {
    let inputValidator = MixedPhoneNumberInputValidator()

    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .phonePad
        textField.textContentType = .telephoneNumber
        textField.placeholder = "Phone number"
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidUpdate), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }

    @objc func textFieldDidUpdate() {
        let phoneNumber = textField.text ?? ""
        textField.backgroundColor = self.inputValidator.validateString(phoneNumber) ? .systemMint : .secondarySystemBackground
    }
}

extension ViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNewline = string == "\n"
        if isNewline {
            return true
        }

        return self.inputValidator.validateReplacementString(string, fullString: textField.text, inRange: range)
    }
}

