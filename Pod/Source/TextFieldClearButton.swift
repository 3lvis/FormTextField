import UIKit

class TextFieldClearButton: UIView {
    var color: UIColor

    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func imageForSize(size: CGSize, color: UIColor) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let view = TextFieldClearButton(frame: frame, color: color)
        view.backgroundColor = UIColor.clearColor()
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        view.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
