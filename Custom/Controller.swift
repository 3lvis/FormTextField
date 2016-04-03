import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

class Controller: UIViewController {
    let height = CGFloat(60)
    let initialY = CGFloat(60)

    lazy var emailField: FormTextField = {
        let margin = CGFloat(20)
        let textField = FormTextField(frame: CGRect(x: margin, y: self.initialY, width: self.view.frame.width - (margin * 2.0), height: self.height))
        textField.inputType = .Email
        textField.placeholder = "Email"

        var validation = Validation()
        validation.required = true
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
        textField.inputType = .Integer
        textField.formatter = CardNumberFormatter()
        textField.placeholder = "Card Number"

        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".characters.count
        validation.minimumLength = "1234 5678 1234 5678".characters.count
        validation.required = true
        let characterSet = NSMutableCharacterSet.decimalDigitCharacterSet()
        characterSet.addCharactersInString(" ")
        validation.characterSet = characterSet
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
        textField.inputType = .Integer
        textField.formatter = CardExpirationDateFormatter()
        textField.placeholder = "Expiration Date (MM/YY)"

        var validation = Validation()
        validation.required = true
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
        textField.inputType = .Integer
        textField.placeholder = "CVC"

        var validation = Validation()
        validation.maximumLength = "CVC".characters.count
        validation.minimumLength = "CVC".characters.count
        validation.characterSet = NSCharacterSet.decimalDigitCharacterSet()
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
        button.setTitle("Pay", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 30.0
        button.layer.shadowColor = UIColor(hex: "21B177").CGColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 1
        button.addTarget(self, action: #selector(Controller.payAction), forControlEvents: .TouchUpInside)

        return button
    }()

    override func loadView() {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor(hex: "D4F3FF")
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.emailField)
        self.view.addSubview(self.cardNumberField)
        self.view.addSubview(self.cardExpirationDateField)
        self.view.addSubview(self.cvcField)
        self.view.addSubview(self.payButton)
    }

    func payAction() {
        let validEmail = self.emailField.validate()
        let validCardNumber = self.cardNumberField.validate()
        let validCardExpirationDate = self.cardExpirationDateField.validate()
        let validCVC = self.cvcField.validate()
        if validEmail && validCardNumber && validCardExpirationDate && validCVC {
            let alertController = UIAlertController(title: "Valid!", message: "The payment details are valid", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
