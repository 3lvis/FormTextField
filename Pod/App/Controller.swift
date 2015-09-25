import UIKit
import Formatter

class Controller: UIViewController {
    override func loadView() {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.whiteColor()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let margin = CGFloat(20)
        let emailTextField = TextField(frame: CGRect(x: margin, y: 60, width: self.view.frame.width - (margin * 2.0), height: 45))
        emailTextField.inputTypeString = "email"
        emailTextField.placeholder = "Email"
        emailTextField.enabled = true
        self.view.addSubview(emailTextField)

        var previousFrame = emailTextField.frame
        previousFrame.origin.y = emailTextField.frame.maxY + margin
        let phoneNumberTextField = TextField(frame: previousFrame)
        phoneNumberTextField.inputTypeString = "phone"
        phoneNumberTextField.placeholder = "Phone number"
        phoneNumberTextField.enabled = true
        phoneNumberTextField.formatter = PhoneNumberFormatter()
        self.view.addSubview(phoneNumberTextField)

        let clear = TextFieldClearButton(frame: CGRect(x: 200, y: 300, width: 18, height: 18), andButtonType: .Clear)
        clear.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(clear)

        let plus = TextFieldClearButton(frame: CGRect(x: 220, y: 300, width: 18, height: 18), andButtonType: .Plus)
        plus.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(plus)

        let minus = TextFieldClearButton(frame: CGRect(x: 240, y: 300, width: 18, height: 18), andButtonType: .Minus)
        minus.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(minus)
    }
}
