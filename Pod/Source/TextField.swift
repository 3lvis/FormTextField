import UIKit
import InputValidator
import Formatter

public enum TextFieldInputType {
    case Default, Name, Username, PhoneNumber, Integer, Decimal, Address, Email, Password, Unknown
}

public protocol TextFieldDelegate: class {
    func didBeginEditing(textField: TextField)
    func didEndEditing(textField: TextField)
    func didUpdateWithText(text: String?, textField: TextField)
    func didReturn(textField: TextField)
}

public class TextField: UITextField, UITextFieldDelegate {
    public var inputValidator: Validatable?
    public var formatter: Formattable?
    public weak var textFieldDelegate: TextFieldDelegate?

    static let LeftMargin = 10.0

    override init(frame: CGRect) {
        self.inputType = .Default

        super.init(frame: frame)

        self.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: TextField.LeftMargin, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .Always

        self.addTarget(self, action: "textFieldDidUpdate:", forControlEvents: .EditingChanged)
        self.addTarget(self, action: "textFieldDidReturn:", forControlEvents: .EditingDidEndOnExit)

        self.returnKeyType = .Done
        self.rightViewMode = .WhileEditing
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var customClearButton: UIButton = {
        return UIButton()
    }()

    override public var text: String? {
        didSet {

        }
    }

    override public var enabled: Bool {
        didSet {
            self.updateEnabled(self.enabled)
        }
    }

    public var valid: Bool = true {
        didSet {
            if self.enabled {
                self.updateValid(self.valid)
            }
        }
    }

    public var inputType: TextFieldInputType {
        didSet {

        }
    }

    // MARK: Public 

    func updateActive(active: Bool) {
        self.rightView = self.customClearButton
    }

    func updateValid(valid: Bool) {

    }

    func updateEnabled(enabled: Bool) {

    }

    public func validate() -> Bool {
        var isValid = true
        if let inputValidator = self.inputValidator{
            isValid = inputValidator.validateString(self.text ?? "")
        }

        return isValid
    }

    // MARK: UITextFieldDelegate

    public func textFieldDidBeginEditing(textField: UITextField) {
        self.updateActive(true)
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        self.updateActive(false)
    }

    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return true
        }

        if self.inputValidator != nil {
            return self.inputValidator!.validateReplacementString(string, usingFullString: self.text, inRange: range)
        }

        return true
    }

    // MARK: Notification

    func textFieldDidUpdate(textField: TextField) {
        if self.valid == false {
            self.updateValid(true)
        }

        self.textFieldDelegate?.didUpdateWithText(self.text, textField: self)
    }

    func textFieldDidReturn(textField: TextField) {
        self.textFieldDelegate?.didReturn(self)
    }

    // MARK: Actions

    func clearButtonAction() {
        self.text = nil

        self.textFieldDelegate?.didUpdateWithText(self.text, textField: self)
    }
}
