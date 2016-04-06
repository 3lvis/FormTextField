import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

class Controller: UITableViewController {
    let fields = Field.fields()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.tableView.registerClass(FormTextFieldCell.self, forCellReuseIdentifier: FormTextFieldCell.Identifier)
        self.tableView.registerClass(HeaderCell.self, forCellReuseIdentifier: HeaderCell.Identifier)
        self.tableView.tableFooterView = UIView()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(Controller.done))
        doneButton.enabled = false
        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fields.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let field = self.fields[indexPath.row]
        if field.type == .Header {
            let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCell.Identifier, forIndexPath: indexPath) as! HeaderCell
            cell.textLabel?.text = field.title.uppercaseString
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(FormTextFieldCell.Identifier, forIndexPath: indexPath) as! FormTextFieldCell
            cell.textField.textFieldDelegate = self
            cell.textLabel?.text = field.title
            cell.textField.placeholder = field.placeholder ?? field.title
            cell.textField.inputType = field.inputType
            cell.textField.inputValidator = field.inputValidator
            cell.textField.formatter = field.formatter
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let field = self.fields[indexPath.row]
        if field.type == .Header {
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
        for (index, field) in self.fields.enumerate() {
            if field.type == .Field {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! FormTextFieldCell
                let validField = cell.textField.validate()
                if validField == false {
                    valid = validField
                }
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
