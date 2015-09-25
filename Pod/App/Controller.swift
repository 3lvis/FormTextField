import UIKit

class Controller: UIViewController {
    override func loadView() {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.whiteColor()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let textField = TextField(frame: CGRect(x: 20, y: 20, width: 200, height: 60))
        textField.placeholder = "Email"
        textField.enabled = true
        self.view.addSubview(textField)
    }
}
