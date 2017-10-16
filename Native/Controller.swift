import UIKit
import Formatter
import InputValidator
import Validation
import FormTextField

class Controller: UITableViewController {
    let fields = Field.fields()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        self.tableView.register(FormTextFieldCell.self, forCellReuseIdentifier: FormTextFieldCell.Identifier)
        self.tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.Identifier)
        self.tableView.tableFooterView = UIView()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Controller.done))
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[(indexPath as NSIndexPath).row]
        if field.type == .header {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.Identifier, for: indexPath) as! HeaderCell
            cell.textLabel?.text = field.title.uppercased()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FormTextFieldCell.Identifier, for: indexPath) as! FormTextFieldCell
            cell.textField.textFieldDelegate = self
            cell.textLabel?.text = field.title
            cell.textField.placeholder = field.placeholder ?? field.title
            cell.textField.inputType = field.inputType
            cell.textField.inputValidator = field.inputValidator
            cell.textField.formatter = field.formatter
            showCheckAccessory(cell.textField)

            return cell
        }
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let field = fields[(indexPath as NSIndexPath).row]
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
        present(alertController, animated: true, completion: nil)
    }

    func validate() -> Bool {
        var valid = true
        for (index, field) in fields.enumerated() {
            if field.type == .field {
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! FormTextFieldCell
                let validField = cell.textField.validate()
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
    func formTextField(_ textField: FormTextField, didUpdateWithText _: String?) {
        showCheckAccessory(textField)
        let valid = validate()
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = valid
        }
    }
}
