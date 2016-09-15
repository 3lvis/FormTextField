import UIKit
import Formatter
import InputValidator

public enum FormTextFieldInputType: String {
    case Default, Name, Username, PhoneNumber, Integer, Decimal, Address, Email, Password, Unknown
}

@objc public protocol FormTextFieldDelegate: NSObjectProtocol {
    @objc optional func formTextFieldDidBeginEditing(_ textField: FormTextField)
    @objc optional func formTextFieldDidEndEditing(_ textField: FormTextField)
    @objc optional func formTextField(_ textField: FormTextField, didUpdateWithText text: String?)
    @objc optional func formTextFieldDidReturn(_ textField: FormTextField)
}

open class FormTextField: UITextField, UITextFieldDelegate {
    dynamic open var borderWidth: CGFloat = 0 { didSet { self.layer.borderWidth = borderWidth } }
    dynamic open var cornerRadius: CGFloat = 0 { didSet { self.layer.cornerRadius = cornerRadius } }
    dynamic open var leftMargin : CGFloat = 10.0 { didSet { self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.leftMargin, height: 0)) } }

    dynamic open var enabledBackgroundColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    dynamic open var enabledBorderColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    dynamic open var enabledTextColor: UIColor = UIColor.black { didSet { self.updateEnabled(self.isEnabled) } }

    dynamic open var validBackgroundColor: UIColor = UIColor.clear
    dynamic open var validBorderColor: UIColor = UIColor.clear
    dynamic open var validTextColor: UIColor = UIColor.black

    dynamic open var activeBackgroundColor: UIColor = UIColor.clear
    dynamic open var activeBorderColor: UIColor = UIColor.clear
    dynamic open var activeTextColor: UIColor = UIColor.black

    dynamic open var inactiveBackgroundColor: UIColor = UIColor.clear
    dynamic open var inactiveBorderColor: UIColor = UIColor.clear
    dynamic open var inactiveTextColor: UIColor = UIColor.black

    dynamic open var disabledBackgroundColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    dynamic open var disabledBorderColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    dynamic open var disabledTextColor: UIColor = UIColor.gray { didSet { self.updateEnabled(self.isEnabled) } }

    dynamic open var invalidBackgroundColor: UIColor = UIColor.clear
    dynamic open var invalidBorderColor: UIColor = UIColor.clear
    dynamic open var invalidTextColor: UIColor = UIColor.red

    dynamic open var defaultTextColor: UIColor? {
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

    open var inputValidator: InputValidatable?
    open var formatter: Formattable?
    weak open var textFieldDelegate: FormTextFieldDelegate?

    static fileprivate let AccessoryButtonWidth = 30.0
    static fileprivate let AccessoryButtonHeight = 20.0
    dynamic open var accessoryViewMode : UITextFieldViewMode = .whileEditing { didSet { self.rightViewMode = self.accessoryViewMode } }
    dynamic open var clearButtonColor: UIColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    open var accessoryView: UIView?

    fileprivate(set) open var valid: Bool = true

    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    fileprivate func commonInit() {
        self.updateInputType(self.inputType)

        self.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.leftMargin, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always

        self.addTarget(self, action: #selector(FormTextField.textFieldDidUpdate(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(FormTextField.textFieldDidReturn(_:)), for: .editingDidEndOnExit)

        self.rightViewMode = .whileEditing
        self.returnKeyType = .done
        self.backgroundColor = UIColor.clear
    }

    fileprivate lazy var clearButton: UIButton = {
        let image = FormTextFieldClearButton.imageForSize(CGSize(width: 18, height: 18), color: self.clearButtonColor)
        let button = UIButton(type: .custom)
        button.setImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(FormTextField.clearButtonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: FormTextField.AccessoryButtonWidth, height: FormTextField.AccessoryButtonHeight)

        return button
    }()

    override open var isEnabled: Bool {
        didSet {
            self.updateEnabled(self.isEnabled)
        }
    }

    open var inputType: FormTextFieldInputType = .Default {
        didSet {
            self.updateInputType(inputType)
        }
    }

    // Sets the textfields at the initial state, clear text and resets appearance too
    open func reset() {
        self.updateText(nil)
        self.updateEnabled(self.isEnabled)
    }

    func updateText(_ newValue: String?) {
        let text = newValue ?? ""

        if self.formatter != nil {
            let textRange = self.selectedTextRange
            let newRawText = self.formatter!.formatString(text, reverse: false)

            let didAddText = (newRawText.characters.count > (self.text ?? "").characters.count)
            let didFormat = (newRawText.characters.count > (self.text ?? "").characters.count)
            let cursorAtStart = (self.selectedTextRange!.start == self.position(from: self.beginningOfDocument, offset: 1))
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

    fileprivate func updateActive(_ active: Bool) {
        if let accessoryView = self.accessoryView {
            self.rightView = accessoryView
        } else if self.accessoryViewMode != .never {
            self.rightView = self.clearButton
        }

        if active {
            self.layer.backgroundColor = self.activeBackgroundColor.cgColor
            self.layer.borderColor = self.activeBorderColor.cgColor
            self.textColor = self.activeTextColor
        } else {
            self.layer.backgroundColor = self.inactiveBackgroundColor.cgColor
            self.layer.borderColor = self.inactiveBorderColor.cgColor
            self.textColor = self.inactiveTextColor
        }
    }

    fileprivate func updateEnabled(_ enabled: Bool) {
        if enabled {
            self.layer.borderColor = self.enabledBorderColor.cgColor
            self.layer.backgroundColor = self.enabledBackgroundColor.cgColor
            self.textColor = self.enabledTextColor
        } else {
            self.layer.borderColor = self.disabledBorderColor.cgColor
            self.layer.backgroundColor = self.disabledBackgroundColor.cgColor
            self.textColor = self.disabledTextColor
        }
    }

    fileprivate func updateValid(_ valid: Bool) {
        if valid {
            self.layer.backgroundColor = self.validBackgroundColor.cgColor
            self.layer.borderColor = self.validBorderColor.cgColor
            self.textColor = self.validTextColor
        } else {
            self.layer.backgroundColor = self.invalidBackgroundColor.cgColor
            self.layer.borderColor = self.invalidBorderColor.cgColor
            self.textColor = self.invalidTextColor
        }

        if valid && self.isFirstResponder {
            self.updateActive(true)
        }
    }

    open func validate(updatingUI: Bool = true) -> Bool {
        var isValid = true
        if let inputValidator = self.inputValidator {
            isValid = inputValidator.validateString(self.text ?? "")
        }

        self.valid = isValid
        if self.isEnabled && updatingUI {
            self.updateValid(self.valid)
        }

        return isValid
    }

    // MARK: Notification

    func textFieldDidUpdate(_ textField: FormTextField) {
        self.updateText(self.text)

        if self.valid == false {
            self.valid = true
            self.updateValid(self.valid)
        }

        self.textFieldDelegate?.formTextField?(self, didUpdateWithText: self.text)
    }

    @objc private func textFieldDidReturn(_ textField: FormTextField) {
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
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let accessoryView = self.accessoryView {
            self.rightView = accessoryView
        } else if self.accessoryViewMode != .never {
            self.rightView = self.clearButton
        }

        self.updateActive(true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateActive(false)

        self.textFieldDelegate?.formTextFieldDidEndEditing?(self)
    }

    @objc(textField:shouldChangeCharactersInRange:replacementString:) public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
