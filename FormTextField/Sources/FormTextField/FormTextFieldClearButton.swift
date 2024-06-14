import UIKit

class FormTextFieldClearButton: UIView {
    fileprivate var color: UIColor

    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        color.setStroke()

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0.5, y: 0.5, width: rect.size.width - 1.0, height: rect.size.height - 1.0))
        ovalPath.lineWidth = 1
        ovalPath.stroke()

        let leftHandle = UIBezierPath()
        leftHandle.move(to: CGPoint(x: 5.5, y: 12.5))
        leftHandle.addCurve(to: CGPoint(x: 12.5, y: 5.5), controlPoint1: CGPoint(x: 12.5, y: 5.5), controlPoint2: CGPoint(x: 12.5, y: 5.5))
        leftHandle.lineWidth = 1
        leftHandle.stroke()

        let rightHandle = UIBezierPath()
        rightHandle.move(to: CGPoint(x: 5.5, y: 5.5))
        rightHandle.addCurve(to: CGPoint(x: 12.5, y: 12.5), controlPoint1: CGPoint(x: 12.5, y: 12.5), controlPoint2: CGPoint(x: 12.5, y: 12.5))
        rightHandle.lineWidth = 1
        rightHandle.stroke()
    }

    class func imageForSize(_ size: CGSize, color: UIColor) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let view = FormTextFieldClearButton(frame: frame, color: color)
        view.backgroundColor = UIColor.clear
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        view.drawHierarchy(in: frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        #if swift(>=2.3)
            return image!
        #else
            return image
        #endif
    }
}
