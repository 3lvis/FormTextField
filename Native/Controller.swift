import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

enum FieldType {
    case Header, Field
}

struct Field {
    let type: FieldType
    let title: String
    let placeholder: String?
    var inputType: FormTextFieldInputType = .Default
    var inputValidator: InputValidatable?
    var formatter: Formattable?

    init(type: FieldType, title: String, placeholder: String? = nil) {
        self.type = type
        self.title = title
        self.placeholder = placeholder
    }
}

class Controller: UITableViewController {
    lazy var items: [Field] = {
        var items = [Field]()

        items.append(Field(type: .Header, title: "Cardholder"))

        var requiredValidation = Validation()
        requiredValidation.required = true
        let requiredInputValidator = InputValidator(validation: requiredValidation)

        var firstNameField = Field(type: .Field, title: "First name")
        firstNameField.inputType = .Name
        firstNameField.inputValidator = requiredInputValidator
        items.append(firstNameField)

        var lastNameField = Field(type: .Field, title: "Last name")
        lastNameField.inputType = .Name
        lastNameField.inputValidator = requiredInputValidator
        items.append(lastNameField)

        items.append(Field(type: .Header, title: "Billing info"))

        var cardNumberField = Field(type: .Field, title: "Number", placeholder: "Card Number")
        cardNumberField.inputType = .Integer
        cardNumberField.formatter = CardNumberFormatter()

        var cardNumberValidation = Validation()
        cardNumberValidation.minimumLength = "1234 5678 1234 5678".characters.count
        cardNumberValidation.maximumLength = "1234 5678 1234 5678".characters.count
        cardNumberValidation.required = true
        let characterSet = NSMutableCharacterSet.decimalDigitCharacterSet()
        characterSet.addCharactersInString(" ")
        cardNumberValidation.characterSet = characterSet
        let cardNumberInputValidator = InputValidator(validation: cardNumberValidation)
        cardNumberField.inputValidator = cardNumberInputValidator
        items.append(cardNumberField)

        var expirationDateField = Field(type: .Field, title: "Expires", placeholder: "MM/YYYY")
        expirationDateField.formatter = CardExpirationDateFormatter()
        expirationDateField.inputType = .Integer
        var expirationDateValidation = Validation()
        expirationDateValidation.required = true
        let expirationDateInputValidator = CardExpirationDateInputValidator(validation: expirationDateValidation)
        expirationDateField.inputValidator = expirationDateInputValidator
        items.append(expirationDateField)

        var securityCodeField = Field(type: .Field, title: "CVV", placeholder: "Security Code")
        securityCodeField.inputType = .Integer
        var securityCodeValidation = Validation()
        securityCodeValidation.maximumLength = "CVC".characters.count
        securityCodeValidation.minimumLength = "CVC".characters.count
        securityCodeValidation.characterSet = NSCharacterSet.decimalDigitCharacterSet()
        let securityCodeInputValidator = InputValidator(validation: securityCodeValidation)
        securityCodeField.inputValidator = securityCodeInputValidator
        items.append(securityCodeField)

        return items
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.tableView.registerClass(FormTextFieldCell.self, forCellReuseIdentifier: FormTextFieldCell.Identifier)
        self.tableView.registerClass(HeaderCell.self, forCellReuseIdentifier: HeaderCell.Identifier)
        self.tableView.tableFooterView = UIView()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        doneButton.enabled = false
        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        if item.type == .Header {
            let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCell.Identifier, forIndexPath: indexPath) as! HeaderCell
            cell.textLabel?.text = item.title.uppercaseString
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(FormTextFieldCell.Identifier, forIndexPath: indexPath) as! FormTextFieldCell
            cell.textField.textFieldDelegate = self
            cell.textLabel?.text = item.title
            cell.textField.placeholder = item.placeholder ?? item.title
            cell.textField.inputType = item.inputType
            cell.textField.inputValidator = item.inputValidator
            cell.textField.formatter = item.formatter
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = self.items[indexPath.row]
        if item.type == .Header {
            return 60
        } else {
            return 45
        }
    }

    func done() {
        let alertController = UIAlertController(title: "The payment details are valid", message: nil, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func validate() -> Bool {
        var valid = true
        let rows = self.items.filter({ $0.type == .Field })
        for (index, _) in rows.enumerate() {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! FormTextFieldCell
            let validField = cell.textField.validate()
            if validField == false {
                valid = validField
            }
        }
        return valid
    }
}

extension Controller: FormTextFieldDelegate {
    func formTextField(textField: FormTextField, didUpdateWithText text: String?) {
        let valid = self.validate()
        if let button = self.navigationItem.rightBarButtonItem {
            button.enabled = valid
        }
    }
}
