import UIKit

extension UIColor {
    /**
     Base initializer, it creates an instance of `UIColor` using an HEX string.
     - parameter hex: The base HEX string to create the color.
     */
    public convenience init(hex: String) {
        let noHashString = hex.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: noHashString)
        scanner.charactersToBeSkipped = NSCharacterSet.symbolCharacterSet()
        
        var alpha:CGFloat = 1.0
        if noHashString.characters.count > 6 {
            let startIndex = noHashString.endIndex.advancedBy(-2)
            let alphaString = noHashString.substringFromIndex(startIndex)
            if let value = NSNumberFormatter().numberFromString(alphaString) {
                alpha = CGFloat(Float(value) * 0.01)
            }
        }

        var hexInt: UInt32 = 0
        if (scanner.scanHexInt(&hexInt)) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }

    internal func convertToRGBSpace(color: UIColor) -> UIColor {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()

        if  CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == CGColorSpaceModel.Monochrome {
            let oldComponents = CGColorGetComponents(color.CGColor)
            let colorRef = CGColorCreate(colorSpaceRGB, [oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]])!
            let color = UIColor(CGColor: colorRef)

            return color
        }

        return self
    }

    /**
     Checks if two colors are equal.
     - parameter color: The color to compare.
     - returns: `true` if the colors are equal.
     */
    public func isEqualTo(color: UIColor) -> Bool {
        let selfColor = self.convertToRGBSpace(self)
        let otherColor = self.convertToRGBSpace(color)

        return selfColor.isEqual(otherColor)
    }
}
