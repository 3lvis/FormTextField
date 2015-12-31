import UIKit

class FormTextFieldClearButton: UIView {
    var color: UIColor

    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        self.color.setStroke()

        let ovalPath = UIBezierPath(ovalInRect: CGRect(x: 0.5, y: 0.5, width: rect.size.width - 1.0, height: rect.size.height - 1.0))
        ovalPath.lineWidth = 1
        ovalPath.stroke()

        let leftHandle = UIBezierPath()
        leftHandle.moveToPoint(CGPoint(x: 5.5, y: 12.5))
        leftHandle.addCurveToPoint(CGPoint(x: 12.5, y: 5.5), controlPoint1: CGPoint(x: 12.5, y: 5.5), controlPoint2: CGPoint(x: 12.5, y: 5.5))
        leftHandle.lineWidth = 1
        leftHandle.stroke()

        let rightHandle = UIBezierPath()
        rightHandle.moveToPoint(CGPoint(x: 5.5, y: 5.5))
        rightHandle.addCurveToPoint(CGPoint(x: 12.5, y: 12.5), controlPoint1: CGPoint(x: 12.5, y: 12.5), controlPoint2: CGPoint(x: 12.5, y: 12.5))
        rightHandle.lineWidth = 1
        rightHandle.stroke()
    }

    class func imageForSize(size: CGSize, color: UIColor) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let view = FormTextFieldClearButton(frame: frame, color: color)
        view.backgroundColor = UIColor.clearColor()
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        view.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
