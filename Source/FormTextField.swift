import UIKit
import Formatter
import InputValidator

public enum FormTextFieldInputType: String {
    case Default, Name, Username, PhoneNumber, Integer, Decimal, Address, Email, Password, Unknown
}

@objc public protocol FormTextFieldDelegate: NSObjectProtocol {
    optional func formTextFieldDidBeginEditing(textField: FormTextField)
    optional func formTextFieldDidEndEditing(textField: FormTextField)
    optional func formTextField(textField: FormTextField, didUpdateWithText text: String?)
    optional func formTextFieldDidReturn(textField: FormTextField)
}

public class FormTextField: UITextField, UITextFieldDelegate {
    dynamic public var borderWidth: CGFloat = 0 { didSet { self.layer.borderWidth = borderWidth } }
    dynamic public var cornerRadius: CGFloat = 0 { didSet { self.layer.cornerRadius = cornerRadius } }
    dynamic public var accessoryButtonColor: UIColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)

    dynamic public var enabledBackgroundColor: UIColor = UIColor.clearColor() { didSet { self.updateEnabled(self.enabled) } }
    dynamic public var enabledBorderColor: UIColor = UIColor.clearColor() { didSet { self.updateEnabled(self.enabled) } }
    dynamic public var enabledTextColor: UIColor = UIColor.blackColor() { didSet { self.updateEnabled(self.enabled) } }

    dynamic public var validBackgroundColor: UIColor = UIColor.clearColor()
    dynamic public var validBorderColor: UIColor = UIColor.clearColor()
    dynamic public var validTextColor: UIColor = UIColor.blackColor()

    dynamic public var activeBackgroundColor: UIColor = UIColor.clearColor()
    dynamic public var activeBorderColor: UIColor = UIColor.clearColor()
    dynamic public var activeTextColor: UIColor = UIColor.blackColor()

    dynamic public var inactiveBackgroundColor: UIColor = UIColor.clearColor()
    dynamic public var inactiveBorderColor: UIColor = UIColor.clearColor()
    dynamic public var inactiveTextColor: UIColor = UIColor.blackColor()

    dynamic public var disabledBackgroundColor: UIColor = UIColor.clearColor() { didSet { self.updateEnabled(self.enabled) } }
    dynamic public var disabledBorderColor: UIColor = UIColor.clearColor() { didSet { self.updateEnabled(self.enabled) } }
    dynamic public var disabledTextColor: UIColor = UIColor.grayColor() { didSet { self.updateEnabled(self.enabled) } }

    dynamic public var invalidBackgroundColor: UIColor = UIColor.clearColor()
    dynamic public var invalidBorderColor: UIColor = UIColor.clearColor()
    dynamic public var invalidTextColor: UIColor = UIColor.redColor()

    public var inputValidator: InputValidatable?
    public var formatter: Formattable?
    weak public var textFieldDelegate: FormTextFieldDelegate?

    static private let LeftMargin = 10.0
    static private let AccessoryButtonWidth = 30.0
    static private let AccessoryButtonHeight = 20.0

    private func commonInit() {
        self.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: FormTextField.LeftMargin, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .Always

        self.addTarget(self, action: "textFieldDidUpdate:", forControlEvents: .EditingChanged)
        self.addTarget(self, action: "textFieldDidReturn:", forControlEvents: .EditingDidEndOnExit)

        self.returnKeyType = .Done
        self.rightViewMode = .WhileEditing
        self.backgroundColor = UIColor.clearColor()
    }

    override public init(frame: CGRect) {
        self.inputType = .Default

        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.inputType = .Default

        super.init(coder: aDecoder)
        commonInit()
    }

    private lazy var customClearButton: UIButton = {
        let image = FormTextFieldClearButton.imageForSize(CGSize(width: 18, height: 18), color: self.accessoryButtonColor)
        let button = UIButton(type: .Custom)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: "clearButtonAction", forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: FormTextField.AccessoryButtonWidth, height: FormTextField.AccessoryButtonHeight)

        return button
    }()

    override public var enabled: Bool {
        didSet {
            self.updateEnabled(self.enabled)
        }
    }

    private(set) public var valid: Bool = true

    public var inputType: FormTextFieldInputType {
        didSet {
            self.updateInputType(inputType)
        }
    }

    // Sets the textfields at the initial state, clear text and resets appearance too
    public func reset() {
        self.updateText(nil)
        self.updateEnabled(self.enabled)
    }

    func updateText(newValue: String?) {
        let text = newValue ?? ""

        if self.formatter != nil {
            let textRange = self.selectedTextRange
            let newRawText = self.formatter!.formatString(text, reverse: false)

            let didAddText = (newRawText.characters.count > (self.text ?? "").characters.count)
            let didFormat = (newRawText.characters.count > (self.text ?? "").characters.count)
            let cursorAtStart = (self.selectedTextRange!.start == self.positionFromPosition(self.beginningOfDocument, offset: 1))
            if (didAddText && cursorAtStart) {
                self.text = newRawText
                self.selectedTextRange = textRange
            } else if (didAddText && didFormat) {
                super.text = newRawText
            } else {
                super.text = newRawText
                self.selectedTextRange = textRange
            }
        } else {
            self.text = text
        }
    }

    private func updateActive(active: Bool) {
        self.rightView = self.customClearButton

        if active {
            self.layer.backgroundColor = self.activeBackgroundColor.CGColor
            self.layer.borderColor = self.activeBorderColor.CGColor
            self.textColor = self.activeTextColor
        } else {
            self.layer.backgroundColor = self.inactiveBackgroundColor.CGColor
            self.layer.borderColor = self.inactiveBorderColor.CGColor
            self.textColor = self.inactiveTextColor
        }
    }

    private func updateEnabled(enabled: Bool) {
        if enabled {
            self.layer.borderColor = self.enabledBorderColor.CGColor
            self.layer.backgroundColor = self.enabledBackgroundColor.CGColor
            self.textColor = self.enabledTextColor
        } else {
            self.layer.borderColor = self.disabledBorderColor.CGColor
            self.layer.backgroundColor = self.disabledBackgroundColor.CGColor
            self.textColor = self.disabledTextColor
        }
    }

    private func updateValid(valid: Bool) {
        if valid {
            self.layer.backgroundColor = self.validBackgroundColor.CGColor
            self.layer.borderColor = self.validBorderColor.CGColor
            self.textColor = self.validTextColor
        } else {
            self.layer.backgroundColor = self.invalidBackgroundColor.CGColor
            self.layer.borderColor = self.invalidBorderColor.CGColor
            self.textColor = self.invalidTextColor
        }

        if valid && self.isFirstResponder() {
            self.updateActive(true)
        }
    }

    public func validate(updatingUI updatingUI: Bool = true) -> Bool {
        var isValid = true
        if let inputValidator = self.inputValidator {
            isValid = inputValidator.validateString(self.text ?? "")
        }

        self.valid = isValid
        if self.enabled && updatingUI {
            self.updateValid(self.valid)
        }

        return isValid
    }

    // MARK: Notification

    func textFieldDidUpdate(textField: FormTextField) {
        self.updateText(self.text)

        if self.valid == false {
            self.valid = true
            self.updateValid(self.valid)
        }

        self.textFieldDelegate?.formTextField?(self, didUpdateWithText: self.text)
    }

    func textFieldDidReturn(textField: FormTextField) {
        self.textFieldDelegate?.formTextFieldDidReturn?(self)
    }

    // MARK: Actions

    func clearButtonAction() {
        self.text = nil

        self.textFieldDelegate?.formTextField?(self, didUpdateWithText: self.text)
    }
}

// MARK: UITextFieldDelegate

extension FormTextField {
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.rightView = self.customClearButton

        self.updateActive(true)
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        self.updateActive(false)

        self.textFieldDelegate?.formTextFieldDidEndEditing?(self)
    }

    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return true
        }

        var valid = true
        if let inputValidator = self.inputValidator {
            valid = inputValidator.validateReplacementString(string, fullString: self.text, inRange: range)
        }
        
        return valid
    }
}
