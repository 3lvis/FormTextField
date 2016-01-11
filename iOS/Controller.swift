import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

class Controller: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "EFEFF4")
        self.tableView.registerClass(FormTextFieldCell.self, forCellReuseIdentifier: FormTextFieldCell.Identifier)
        self.tableView.registerClass(HeaderCell.self, forCellReuseIdentifier: HeaderCell.Identifier)
        self.tableView.tableFooterView = UIView()
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

            switch indexPath.row {
            case 1:
                cell.textLabel?.text = "First name"
                cell.textField.placeholder = "First name"
                cell.textField.inputType = .Name
                break
            case 2:
                cell.textLabel?.text = "Last name"
                cell.textField.placeholder = "Last name"
                cell.textField.inputType = .Name
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
}
