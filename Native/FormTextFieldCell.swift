import UIKit
import FormTextField

class FormTextFieldCell: UITableViewCell {
    static let Identifier = "FormTextFieldCell"

    lazy var textField: FormTextField = {
        let textField = FormTextField()
        textField.defaultTextColor = UIColor.blackColor()

        return textField
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .None
        self.contentView.addSubview(self.textField)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let textLabel = self.textLabel else { return }

        var textLabelFrame = textLabel.frame
        textLabelFrame.origin.x = 20
        textLabelFrame.size.width = 90
        textLabel.frame = textLabelFrame

        let bounds = UIScreen.mainScreen().bounds
        let x = textLabelFrame.width + textLabelFrame.origin.x
        let rightMargin = CGFloat(10)
        let width = bounds.size.width - x - rightMargin
        let textFieldFrame = CGRect(x: x, y: 0, width: width, height: self.frame.size.height)
        self.textField.frame = textFieldFrame
    }
}
