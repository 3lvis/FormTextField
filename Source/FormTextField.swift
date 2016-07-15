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
    dynamic public var leftMargin : CGFloat = 10.0 { didSet { self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.leftMargin, height: 0)) } }

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

    dynamic public var defaultTextColor: UIColor? {
        didSet {
            if let defaultColor = self.defaultTextColor {
                self.enabledTextColor = defaultColor
                self.validTextColor = defaultColor
                self.activeTextColor = defaultColor
                self.inactiveTextColor = defaultColor
                self.disabledTextColor = defaultColor
                self.invalidTextColor = defaultColor
            }
        }
    }

    public var inputValidator: InputValidatable?
    public var formatter: Formattable?
    weak public var textFieldDelegate: FormTextFieldDelegate?

    static private let AccessoryButtonWidth = 30.0
    static private let AccessoryButtonHeight = 20.0
    dynamic public var accessoryViewMode : UITextFieldViewMode = .WhileEditing { didSet { self.rightViewMode = self.accessoryViewMode } }
    dynamic public var clearButtonColor: UIColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    public var accessoryView: UIView?

    private(set) public var valid: Bool = true

    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        self.updateInputType(self.inputType)

        self.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.leftMargin, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .Always

        self.addTarget(self, action: #selector(FormTextField.textFieldDidUpdate(_:)), forControlEvents: .EditingChanged)
        self.addTarget(self, action: #selector(FormTextField.textFieldDidReturn(_:)), forControlEvents: .EditingDidEndOnExit)

        self.rightViewMode = .WhileEditing
        self.returnKeyType = .Done
        self.backgroundColor = UIColor.clearColor()
    }

    private lazy var clearButton: UIButton = {
        let image = FormTextFieldClearButton.imageForSize(CGSize(width: 18, height: 18), color: self.clearButtonColor)
        let button = UIButton(type: .Custom)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: #selector(FormTextField.clearButtonAction), forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: FormTextField.AccessoryButtonWidth, height: FormTextField.AccessoryButtonHeight)

        return button
    }()

    override public var enabled: Bool {
        didSet {
            self.updateEnabled(self.enabled)
        }
    }

    public var inputType: FormTextFieldInputType = .Default {
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
        if let accessoryView = self.accessoryView {
            self.rightView = accessoryView
        } else if self.accessoryViewMode != .Never {
            self.rightView = self.clearButton
        }

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
        if let accessoryView = self.accessoryView {
            self.rightView = accessoryView
        } else if self.accessoryViewMode != .Never {
            self.rightView = self.clearButton
        }

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
