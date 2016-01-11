import UIKit

class HeaderCell: UITableViewCell {
    static let Identifier = "HeaderCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor(hex: "EFEFF4")
        self.selectionStyle = .None

        guard let textLabel = self.textLabel else { return }
        textLabel.textColor = UIColor(hex: "6D6D72")
        textLabel.font = UIFont.systemFontOfSize(14)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let textLabel = self.textLabel else { return }
        var frame = textLabel.frame
        frame.size.height = 30
        frame.origin.x = 20
        frame.origin.y = self.frame.height - frame.height
        textLabel.frame = frame
    }
}
