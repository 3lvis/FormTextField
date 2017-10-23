import UIKit
import FormTextField

class Controller: UIViewController {
    let height = CGFloat(60)
    let initialY = CGFloat(60)

    lazy var emailField: FormTextField = {
        let margin = CGFloat(20)
        let textField = FormTextField(frame: CGRect(x: margin, y: self.initialY, width: self.view.frame.width - (margin * 2.0), height: self.height))
        textField.inputType = .email
        textField.placeholder = "Email"

        var validation = Validation()
        validation.minimumLength = 1
        validation.format = "[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator

        return textField
    }()

    lazy var cardNumberField: FormTextField = {
        let margin = CGFloat(20)
        var previousFrame = self.emailField.frame
        previousFrame.origin.y = self.emailField.frame.maxY + margin
        let textField = FormTextField(frame: previousFrame)
        textField.inputType = .integer
        textField.formatter = CardNumberFormatter()
        textField.placeholder = "Card Number"

        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".characters.count
        validation.minimumLength = "1234 5678 1234 5678".characters.count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator

        return textField
    }()

    lazy var cardExpirationDateField: FormTextField = {
        let margin = CGFloat(20)
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.y = self.cardNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.6
        let textField = FormTextField(frame: previousFrame)
        textField.inputType = .integer
        textField.formatter = CardExpirationDateFormatter()
        textField.placeholder = "Expiration Date (MM/YY)"

        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        textField.inputValidator = inputValidator

        return textField
    }()

    lazy var cvcField: FormTextField = {
        let margin = CGFloat(20)
        var previousFrame = self.cardNumberField.frame
        previousFrame.origin.x = self.cardExpirationDateField.frame.maxX + previousFrame.size.width * 0.05
        previousFrame.origin.y = self.cardNumberField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.35
        let textField = FormTextField(frame: previousFrame)
        textField.inputType = .integer
        textField.placeholder = "CVC"

        var validation = Validation()
        validation.maximumLength = "CVC".characters.count
        validation.minimumLength = "CVC".characters.count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator

        return textField
    }()

    lazy var payButton: UIButton = {
        let margin = CGFloat(20)
        var previousFrame = self.emailField.frame
        previousFrame.origin.y = self.cvcField.frame.maxY + margin
        let button = UIButton(frame: previousFrame)
        button.backgroundColor = UIColor(hex: "27C787")
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 24)
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 30.0
        button.layer.shadowColor = UIColor(hex: "21B177").cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 1
        button.addTarget(self, action: #selector(Controller.payAction), for: .touchUpInside)

        return button
    }()

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(hex: "D4F3FF")
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(emailField)
        view.addSubview(cardNumberField)
        view.addSubview(cardExpirationDateField)
        view.addSubview(cvcField)
        view.addSubview(payButton)
    }

    @objc func payAction() {
        let validEmail = emailField.validate()
        let validCardNumber = cardNumberField.validate()
        let validCardExpirationDate = cardExpirationDateField.validate()
        let validCVC = cvcField.validate()
        if validEmail && validCardNumber && validCardExpirationDate && validCVC {
            let alertController = UIAlertController(title: "Valid!", message: "The payment details are valid", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}
