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
        let emailTextField = TextField(frame: CGRect(x: margin, y: 60, width: self.view.frame.width - (margin * 2.0), height: 60))
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
    }
}
