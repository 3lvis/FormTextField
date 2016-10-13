import UIKit
import Formatter
import InputValidator
import Validation

class Controller: UITableViewController {
    lazy var fields: [SampleFormField] = {
        var items = [SampleFormField]()

        items.append(SampleFormField(type: .header, title: "Cardholder"))

        var requiredValidation = Validation()
        requiredValidation.required = true
        let requiredInputValidator = InputValidator(validation: requiredValidation)

        let emailField: SampleFormField = {
            var field = SampleFormField(type: .field, title: "Email")
            field.inputType = .email
            field.returnKeyType = .next

            var validation = Validation()
            validation.required = true
            validation.format = "[\\w._%+-]+@[\\w.-]+\\.\\w{2,}"
            field.inputValidator = InputValidator(validation: validation)

            return field
        }()
        items.append(emailField)

        let usernameField: SampleFormField = {
            var field = SampleFormField(type: .field, title: "Username")
            field.inputType = .name
            field.inputValidator = requiredInputValidator
            field.returnKeyType = .next

            return field
        }()
        items.append(usernameField)

        items.append(SampleFormField(type: .header, title: "Billing info"))

        let cardNumberField: SampleFormField = {
            var field = SampleFormField(type: .field, title: "Number", placeholder: "Card Number")
            field.inputType = .integer
            field.formatter = CardNumberFormatter()
            var validation = Validation()
            validation.minimumLength = "1234 5678 1234 5678".characters.count
            validation.maximumLength = "1234 5678 1234 5678".characters.count
            validation.required = true
            let characterSet = NSMutableCharacterSet.decimalDigit()
            characterSet.addCharacters(in: " ")
            validation.characterSet = characterSet as CharacterSet
            let inputValidator = InputValidator(validation: validation)
            field.inputValidator = inputValidator
            field.returnKeyType = .next

            return field
        }()
        items.append(cardNumberField)

        let expirationDateField: SampleFormField = {
            var field = SampleFormField(type: .field, title: "Expires", placeholder: "MM/YY")
            field.formatter = CardExpirationDateFormatter()
            field.inputType = .integer
            var validation = Validation()
            validation.required = true
            let inputValidator = CardExpirationDateInputValidator(validation: validation)
            field.inputValidator = inputValidator
            field.returnKeyType = .next

            return field
        }()
        items.append(expirationDateField)

        let securityCodeField: SampleFormField = {
            var field = SampleFormField(type: .field, title: "CVC", placeholder: "Security Code")
            field.inputType = .integer
            var validation = Validation()
            validation.maximumLength = "CVC".characters.count
            validation.minimumLength = "CVC".characters.count
            validation.characterSet = CharacterSet.decimalDigits
            let inputValidator = InputValidator(validation: validation)
            field.inputValidator = inputValidator
            field.returnKeyType = .done

            return field
        }()
        items.append(securityCodeField)
        
        return items
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.tableView.register(FormTextFieldCell.self, forCellReuseIdentifier: FormTextFieldCell.Identifier)
        self.tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.Identifier)
        self.tableView.tableFooterView = UIView()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Controller.done))
        doneButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = self.fields[indexPath.row]
        field.indexPath = indexPath

        if field.type == .header {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.Identifier, for: indexPath) as! HeaderCell
            cell.textLabel?.text = field.title.uppercased()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FormTextFieldCell.Identifier, for: indexPath) as! FormTextFieldCell
            cell.textField.textFieldDelegate = self
            cell.textLabel?.text = field.title
            cell.textField.formField = field
            self.showCheckAccessory(cell.textField)
            print("title: \(field.title), tag: \(indexPath.row)")

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let field = self.fields[(indexPath as NSIndexPath).row]
        if field.type == .header {
            return 60
        } else {
            return 45
        }
    }

    func done() {
        let alertController = UIAlertController(title: "The payment details are valid", message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func validate() -> Bool {
        var valid = true
        for field in fields {
            if field.type == .field {
                let validField = field.validate()
                if validField == false {
                    valid = validField
                }
            }
        }
        return valid
    }

    func showCheckAccessory(_ textField: FormTextField) {
        let valid = textField.validate()
        if valid {
            let imageView = UIImageView(image: UIImage(named: "check-icon")!)
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            textField.accessoryView = imageView
            textField.accessoryViewMode = .always
        } else {
            textField.accessoryView = nil
            textField.accessoryViewMode = .never
        }
    }
}

extension Controller: FormTextFieldDelegate {
    func formTextField(_ textField: FormTextField, didUpdateWithText text: String?) {
        textField.formField.value = text
        self.showCheckAccessory(textField)
        let valid = self.validate()
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = valid
        }
    }

    func formTextFieldDidReturn(_ textField: FormTextField) {
        var nextIndexPath: IndexPath?
        var found = false
        for field in self.fields {
            if found {
                if field.type == .field {
                    nextIndexPath = field.indexPath
                    break
                }
            }

            if field.indexPath == (textField.formField as! SampleFormField).indexPath {
                found = true
            }
        }

        if let nextIndexPath = nextIndexPath {
            let cell = self.tableView(self.tableView, cellForRowAt: nextIndexPath) as! FormTextFieldCell
            cell.textField.becomeFirstResponder()
            //cell.textField.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.2)
        } else {
            self.setEditing(false, animated: true)
        }
    }
}
