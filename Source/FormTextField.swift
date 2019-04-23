import UIKit

public enum FormTextFieldInputType: String {
    case `default`, name, username, phoneNumber, integer, decimal, address, email, password, unknown
}

@objc public protocol FormTextFieldDelegate: NSObjectProtocol {
    @objc optional func formTextFieldDidBeginEditing(_ textField: FormTextField)
    @objc optional func formTextFieldDidEndEditing(_ textField: FormTextField)
    @objc optional func formTextField(_ textField: FormTextField, didUpdateWithText text: String?)
    @objc optional func formTextFieldDidReturn(_ textField: FormTextField)
}

open class FormTextField: UITextField, UITextFieldDelegate {
    @objc open dynamic var borderWidth: CGFloat = 0 { didSet { self.layer.borderWidth = borderWidth } }
    @objc open dynamic var cornerRadius: CGFloat = 0 { didSet { self.layer.cornerRadius = cornerRadius } }
    @objc open dynamic var leftMargin: CGFloat = 10.0 { didSet { self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.leftMargin, height: 0)) } }

    @objc open dynamic var enabledBackgroundColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    @objc open dynamic var enabledBorderColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    @objc open dynamic var enabledTextColor: UIColor = UIColor.black { didSet { self.updateEnabled(self.isEnabled) } }

    @objc open dynamic var validBackgroundColor: UIColor = UIColor.clear
    @objc open dynamic var validBorderColor: UIColor = UIColor.clear
    @objc open dynamic var validTextColor: UIColor = UIColor.black

    @objc open dynamic var activeBackgroundColor: UIColor = UIColor.clear
    @objc open dynamic var activeBorderColor: UIColor = UIColor.clear
    @objc open dynamic var activeTextColor: UIColor = UIColor.black

    @objc open dynamic var inactiveBackgroundColor: UIColor = UIColor.clear
    @objc open dynamic var inactiveBorderColor: UIColor = UIColor.clear
    @objc open dynamic var inactiveTextColor: UIColor = UIColor.black

    @objc open dynamic var disabledBackgroundColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    @objc open dynamic var disabledBorderColor: UIColor = UIColor.clear { didSet { self.updateEnabled(self.isEnabled) } }
    @objc open dynamic var disabledTextColor: UIColor = UIColor.gray { didSet { self.updateEnabled(self.isEnabled) } }

    @objc open dynamic var invalidBackgroundColor: UIColor = UIColor.clear
    @objc open dynamic var invalidBorderColor: UIColor = UIColor.clear
    @objc open dynamic var invalidTextColor: UIColor = UIColor.red

    @objc open dynamic var defaultTextColor: UIColor? {
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
    open weak var textFieldDelegate: FormTextFieldDelegate?

    fileprivate static let AccessoryButtonWidth = 30.0
    fileprivate static let AccessoryButtonHeight = 20.0
    @objc open dynamic var accessoryViewMode: UITextField.ViewMode = .whileEditing { didSet { self.rightViewMode = self.accessoryViewMode } }
    @objc open dynamic var clearButtonColor: UIColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
    open var accessoryView: UIView?

    open fileprivate(set) var valid: Bool = true

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    fileprivate func commonInit() {
        updateInputType(self.inputType)

        delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftMargin, height: 0))
        leftView = paddingView
        leftViewMode = .always

        addTarget(self, action: #selector(FormTextField.textFieldDidUpdate(_:)), for: .editingChanged)
        addTarget(self, action: #selector(FormTextField.textFieldDidReturn(_:)), for: .editingDidEndOnExit)

        rightViewMode = .whileEditing
        returnKeyType = .done
        backgroundColor = UIColor.clear
    }

    fileprivate lazy var clearButton: UIButton = {
        let image = FormTextFieldClearButton.imageForSize(CGSize(width: 18, height: 18), color: self.clearButtonColor)
        let button = UIButton(type: .custom)
        button.setImage(image, for: UIControl.State())
        button.addTarget(self, action: #selector(FormTextField.clearButtonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: FormTextField.AccessoryButtonWidth, height: FormTextField.AccessoryButtonHeight)

        return button
    }()

    open override var isEnabled: Bool {
        didSet {
            self.updateEnabled(self.isEnabled)
        }
    }

    open var inputType: FormTextFieldInputType = .default {
        didSet {
            self.updateInputType(inputType)
        }
    }

    // Sets the textfields at the initial state, clear text and resets appearance too
    open func reset() {
        updateText(nil)
        updateEnabled(isEnabled)
    }

    func updateText(_ newValue: String?) {
        let text = newValue ?? ""

        if formatter != nil {
            let textRange = selectedTextRange
            let newRawText = formatter!.formatString(text, reverse: false)

            let didAddText = (newRawText.count > (self.text ?? "").count)
            let didFormat = (newRawText.count > (self.text ?? "").count)
            let cursorAtStart = (selectedTextRange!.start == position(from: beginningOfDocument, offset: 1))
            if didAddText && cursorAtStart {
                self.text = newRawText
                selectedTextRange = textRange
            } else if didAddText && didFormat {
                super.text = newRawText
            } else {
                super.text = newRawText
                selectedTextRange = textRange
            }
        } else {
            self.text = text
        }
    }

    fileprivate func updateActive(_ active: Bool) {
        if let accessoryView = self.accessoryView {
            rightView = accessoryView
        } else if accessoryViewMode != .never {
            rightView = clearButton
        }

        if active {
            layer.backgroundColor = activeBackgroundColor.cgColor
            layer.borderColor = activeBorderColor.cgColor
            textColor = activeTextColor
        } else {
            layer.backgroundColor = inactiveBackgroundColor.cgColor
            layer.borderColor = inactiveBorderColor.cgColor
            textColor = inactiveTextColor
        }
    }

    fileprivate func updateEnabled(_ enabled: Bool) {
        if enabled {
            layer.borderColor = enabledBorderColor.cgColor
            layer.backgroundColor = enabledBackgroundColor.cgColor
            textColor = enabledTextColor
        } else {
            layer.borderColor = disabledBorderColor.cgColor
            layer.backgroundColor = disabledBackgroundColor.cgColor
            textColor = disabledTextColor
        }
    }

    fileprivate func updateValid(_ valid: Bool) {
        if valid {
            layer.backgroundColor = validBackgroundColor.cgColor
            layer.borderColor = validBorderColor.cgColor
            textColor = validTextColor
        } else {
            layer.backgroundColor = invalidBackgroundColor.cgColor
            layer.borderColor = invalidBorderColor.cgColor
            textColor = invalidTextColor
        }

        if valid && isFirstResponder {
            updateActive(true)
        }
    }

    open func validate(updatingUI: Bool = true) -> Bool {
        var isValid = true
        if let inputValidator = self.inputValidator {
            isValid = inputValidator.validateString(text ?? "")
        }

        valid = isValid
        if isEnabled && updatingUI {
            updateValid(valid)
        }

        return isValid
    }

    // MARK: Notification

    @objc func textFieldDidUpdate(_: FormTextField) {
        updateText(text)

        if !valid {
            valid = true
            updateValid(valid)
        }

        textFieldDelegate?.formTextField?(self, didUpdateWithText: text)
    }

    @objc private func textFieldDidReturn(_: FormTextField) {
        textFieldDelegate?.formTextFieldDidReturn?(self)
    }

    // MARK: Actions

    @objc func clearButtonAction() {
        text = nil

        textFieldDelegate?.formTextField?(self, didUpdateWithText: text)
    }
}

// MARK: UITextFieldDelegate

extension FormTextField {
    public func textFieldDidBeginEditing(_: UITextField) {
        if let accessoryView = self.accessoryView {
            rightView = accessoryView
        } else if accessoryViewMode != .never {
            rightView = clearButton
        }

        updateActive(true)
    }

    public func textFieldDidEndEditing(_: UITextField) {
        updateActive(false)

        textFieldDelegate?.formTextFieldDidEndEditing?(self)
    }

    @objc(textField:shouldChangeCharactersInRange:replacementString:) public func textField(_: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return true
        }

        var valid = true
        if let inputValidator = self.inputValidator {
            valid = inputValidator.validateReplacementString(string, fullString: text, inRange: range)
        }

        return valid
    }
}
