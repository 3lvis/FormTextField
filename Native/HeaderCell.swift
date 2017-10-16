import UIKit

class HeaderCell: UITableViewCell {
    static let Identifier = "HeaderCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        selectionStyle = .none

        guard let textLabel = self.textLabel else { return }
        textLabel.textColor = UIColor(red: 109 / 255, green: 109 / 255, blue: 114 / 255, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 14)
    }

    required init?(coder _: NSCoder) {
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
