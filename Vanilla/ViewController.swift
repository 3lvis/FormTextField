import UIKit
import FormTextField

class ViewController: UIViewController {
    let formatter = CardExpirationDateFormatter()

    lazy var inputValidator: CardExpirationDateInputValidator = {
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        return inputValidator
    }()

    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .phonePad
        textField.placeholder = "Expiration Date (MM/YY)"
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

    var reverse = false

    @objc func textFieldDidUpdate() {
        updateText(textField.text)
    }

    func updateText(_ newValue: String?) {
        let text = newValue ?? ""
        let textRange = textField.selectedTextRange
        let newRawText = formatter.formatString(text, reverse: self.reverse)
        let didAddText = (newRawText.count > (textField.text ?? "").count)
        textField.text = newRawText

        // If no text was added, restore the previous text selection range
        // This ensures the cursor remains where it was before the text update
        if !didAddText {
            textField.selectedTextRange = textRange
        }
    }
}

extension ViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNewline = string == "\n"
        if isNewline {
            return true
        }

        self.reverse = string.isEmpty

        return self.inputValidator.validateReplacementString(string, fullString: textField.text, inRange: range)
    }
}

