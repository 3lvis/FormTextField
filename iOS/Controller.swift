import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

class Controller: UITableViewController {
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
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCell.Identifier, forIndexPath: indexPath) as! HeaderCell

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Cardholder".uppercaseString
                break
            case 3:
                cell.textLabel?.text = "Billing info".uppercaseString
                break
            default: break
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(FormTextFieldCell.Identifier, forIndexPath: indexPath) as! FormTextFieldCell
            cell.textField.textFieldDelegate = self

            switch indexPath.row {
            case 1:
                cell.textLabel?.text = "First name"
                cell.textField.placeholder = "First name"
                cell.textField.inputType = .Name

                var validation = Validation()
                validation.required = true
                let inputValidator = InputValidator(validation: validation)
                cell.textField.inputValidator = inputValidator

                break
            case 2:
                cell.textLabel?.text = "Last name"
                cell.textField.placeholder = "Last name"
                cell.textField.inputType = .Name

                var validation = Validation()
                validation.required = true
                let inputValidator = InputValidator(validation: validation)
                cell.textField.inputValidator = inputValidator

                break
            case 4:
                cell.textLabel?.text = "Number"
                cell.textField.placeholder = "Card Number"
                cell.textField.inputType = .Integer
                cell.textField.formatter = CardNumberFormatter()

                var validation = Validation()
                validation.minimumLength = "1234 5678 1234 5678".characters.count
                validation.maximumLength = "1234 5678 1234 5678".characters.count
                validation.required = true
                let characterSet = NSMutableCharacterSet.decimalDigitCharacterSet()
                characterSet.addCharactersInString(" ")
                validation.characterSet = characterSet
                let inputValidator = InputValidator(validation: validation)
                cell.textField.inputValidator = inputValidator

                break
            case 5:
                cell.textLabel?.text = "Expires"
                cell.textField.placeholder = "MM/YYYY"
                cell.textField.inputType = .Integer
                cell.textField.formatter = CardExpirationDateFormatter()

                var validation = Validation()
                validation.required = true
                let inputValidator = CardExpirationDateInputValidator(validation: validation)
                cell.textField.inputValidator = inputValidator
                break
            case 6:
                cell.textLabel?.text = "CVV"
                cell.textField.placeholder = "Security Code"
                cell.textField.inputType = .Integer

                var validation = Validation()
                validation.maximumLength = "CVC".characters.count
                validation.minimumLength = "CVC".characters.count
                validation.characterSet = NSCharacterSet.decimalDigitCharacterSet()
                let inputValidator = InputValidator(validation: validation)
                cell.textField.inputValidator = inputValidator
                break
            default: break
            }
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 3 {
            return 60
        } else {
            return 45
        }
    }

    func done() {
        let valid = self.validate()
        let title: String
        if valid {
            title = "The payment details are valid"
        } else {
            title = "The payment details are invalid 😢"
        }

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func validate() -> Bool {
        let rows = [1, 2, 4, 5, 6]
        var valid = true
        for row in rows {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! FormTextFieldCell
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
