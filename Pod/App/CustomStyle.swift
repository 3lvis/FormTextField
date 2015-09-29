import Foundation
import Hex

struct CustomStyle {
    static func apply() {
        TextField.appearance().borderWidth = 2
        TextField.appearance().cornerRadius = 10
        TextField.appearance().accessoryButtonColor = UIColor(hex: "70D7FF")
        TextField.appearance().font = UIFont(name: "AvenirNext-Regular", size: 15)!

        let enabledBackgroundColor = UIColor.whiteColor()
        let enabledBorderColor = UIColor(hex: "DFDFDF")
        let enabledTextColor = UIColor(hex: "455C73")
        TextField.appearance().enabledBackgroundColor = enabledBackgroundColor
        TextField.appearance().enabledBorderColor = enabledBorderColor
        TextField.appearance().enabledTextColor = enabledTextColor

        TextField.appearance().validBackgroundColor = enabledBackgroundColor
        TextField.appearance().validBorderColor = enabledBorderColor
        TextField.appearance().validTextColor = enabledTextColor

        TextField.appearance().activeBackgroundColor = enabledBackgroundColor
        TextField.appearance().activeBorderColor = UIColor(hex: "70D7FF")
        TextField.appearance().activeTextColor = enabledTextColor

        TextField.appearance().inactiveBackgroundColor = enabledBackgroundColor
        TextField.appearance().inactiveBorderColor = enabledBorderColor
        TextField.appearance().inactiveTextColor = enabledTextColor

        TextField.appearance().disabledBackgroundColor = UIColor(hex: "DFDFDF")
        TextField.appearance().disabledBorderColor = UIColor(hex: "DFDFDF")
        TextField.appearance().disabledTextColor = UIColor.whiteColor()

        TextField.appearance().invalidBackgroundColor = UIColor(hex: "FFC9C8")
        TextField.appearance().invalidBorderColor = UIColor(hex: "FF4B47")
        TextField.appearance().invalidTextColor = UIColor(hex: "FF4B47")
    }
}




