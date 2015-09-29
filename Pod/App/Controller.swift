import UIKit
import Formatter
import InputValidator

class Controller: UIViewController {
    let height = CGFloat(60)
    let initialY = CGFloat(60)

    lazy var emailTextField: TextField = {
        let margin = CGFloat(20)
        let textField = TextField(frame: CGRect(x: margin, y: self.initialY, width: self.view.frame.width - (margin * 2.0), height: self.height))
        textField.inputType = .Email
        textField.placeholder = "Email"

        var validator = Validation()
        validator.minimumLength = 1
        let inputValidator = InputValidator(validation: validator)
        textField.inputValidator = inputValidator

        return textField
    }()

    lazy var cardNumberTextField: TextField = {
        let margin = CGFloat(20)
        var previousFrame = self.emailTextField.frame
        previousFrame.origin.y = self.emailTextField.frame.maxY + margin
        let textField = TextField(frame: previousFrame)
        textField.inputType = .Integer
        textField.formatter = CardNumberFormatter()
        textField.placeholder = "Card Number"

        var validator = Validation()
        let count = "1234 5678 1234 5678".characters.count
        validator.maximumLength = count
        validator.minimumLength = 1
        let inputValidator = IntegerInputValidator(validation: validator)
        textField.inputValidator = inputValidator

        return textField
        }()

    lazy var cardExpirationDateTextField: TextField = {
        let margin = CGFloat(20)
        var previousFrame = self.cardNumberTextField.frame
        previousFrame.origin.y = self.cardNumberTextField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.6
        let textField = TextField(frame: previousFrame)
        textField.inputType = .Integer
        textField.formatter = CardExpirationDateFormatter()
        textField.placeholder = "Expiration Date (MM/YY)"

        var validator = Validation()
        let count = "MM/YY".characters.count
        validator.maximumLength = count
        validator.minimumLength = 1
        let inputValidator = IntegerInputValidator(validation: validator)
        textField.inputValidator = inputValidator

        return textField
        }()

    lazy var cvcTextField: TextField = {
        let margin = CGFloat(20)
        var previousFrame = self.cardNumberTextField.frame
        previousFrame.origin.x = self.cardExpirationDateTextField.frame.maxX + previousFrame.size.width * 0.05
        previousFrame.origin.y = self.cardNumberTextField.frame.maxY + margin
        previousFrame.size.width = previousFrame.size.width * 0.35
        let textField = TextField(frame: previousFrame)
        textField.inputType = .Integer
        textField.placeholder = "CVC"

        var validator = Validation()
        let count = "CVC".characters.count
        validator.maximumLength = count
        validator.minimumLength = 1
        let inputValidator = IntegerInputValidator(validation: validator)
        textField.inputValidator = inputValidator

        return textField
        }()

    lazy var payButton: UIButton = {
        let margin = CGFloat(20)
        var previousFrame = self.emailTextField.frame
        previousFrame.origin.y = self.cvcTextField.frame.maxY + margin
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
        button.addTarget(self, action: "payAction", forControlEvents: .TouchUpInside)

        return button
        }()

    override func loadView() {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor(hex: "D4F3FF")
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.cardNumberTextField)
        self.view.addSubview(self.cardExpirationDateTextField)
        self.view.addSubview(self.cvcTextField)
        self.view.addSubview(self.payButton)
    }

    func payAction() {
        let validEmail = self.emailTextField.validate()
        let validCardNumber = self.cardNumberTextField.validate()
        let validCardExpirationDate = self.cardExpirationDateTextField.validate()
        let validCVC = self.cvcTextField.validate()
        if validEmail && validCardNumber && validCardExpirationDate && validCVC {
            let alertController = UIAlertController(title: "Valid!", message: "The payment details are valid", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
