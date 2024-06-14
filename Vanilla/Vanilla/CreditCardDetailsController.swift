import UIKit
import FormTextField

class CreditCardDetailsController: UIViewController {
    lazy var inputValidator: InputValidator = {
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        return inputValidator
    }()

    let formatter = CardNumberFormatter()

    lazy var creditCardNumberTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.textContentType = .creditCardNumber
        textField.placeholder = "Credit card number"
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidUpdate(_:)), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(creditCardNumberTextField)
        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            creditCardNumberTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            creditCardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            creditCardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }

    @objc func textFieldDidUpdate(_ textField: UITextField) {
        let creditCardNumber = creditCardNumberTextField.text ?? ""
        textField.text = formatter.formatString(creditCardNumber, reverse: reverse)
        creditCardNumberTextField.backgroundColor = self.inputValidator.validateString(creditCardNumber) ? .systemMint : .secondarySystemBackground
    }

    var reverse = false
}

extension CreditCardDetailsController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        reverse = string.isEmpty
        return self.inputValidator.validateReplacementString(string, fullString: textField.text, inRange: range)
    }
}

