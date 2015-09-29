import Foundation
import Hex

struct CustomStyle {
    static func apply() {
        TextField.appearance().borderWidth = 2
        TextField.appearance().cornerRadius = 10
        TextField.appearance().customFont = UIFont(name: "AvenirNext-Regular", size: 15)!

        TextField.appearance().activeBackgroundColor = UIColor.whiteColor()
        TextField.appearance().activeBorderColor = UIColor(hex: "70D7FF")

        TextField.appearance().validBackgroundColor = UIColor.whiteColor()
        TextField.appearance().validBorderColor = UIColor(hex: "70D7FF")

        TextField.appearance().enabledBackgroundColor = UIColor.whiteColor()
        TextField.appearance().enabledBorderColor = UIColor(hex: "DFDFDF")
        TextField.appearance().enabledTextColor = UIColor(hex: "455C73")

        TextField.appearance().disabledBackgroundColor = UIColor(hex: "DFDFDF")
        TextField.appearance().disabledBorderColor = UIColor(hex: "DFDFDF")
        TextField.appearance().disabledTextColor = UIColor.grayColor()

        TextField.appearance().inactiveBackgroundColor = UIColor.whiteColor()
        TextField.appearance().inactiveBorderColor = UIColor(hex: "DFDFDF")

        TextField.appearance().invalidBackgroundColor = UIColor(hex: "FFC9C8")
        TextField.appearance().invalidBorderColor = UIColor(hex: "FF4B47")

        TextField.appearance().accessoryButtonColor = UIColor(hex: "70D7FF")
    }
}




