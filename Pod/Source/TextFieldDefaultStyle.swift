import UIKit
import Hex

struct TextFieldDefaultStyle {
    static func apply() {
        TextField.appearance().borderWidth = 1
        TextField.appearance().cornerRadius = 5
        TextField.appearance().accessoryButtonColor = UIColor(hex: "3DAFEB")
        TextField.appearance().font = UIFont(name: "AvenirNext-Regular", size: 15)

        let enabledBackgroundColor = UIColor(hex: "E1F5FF")
        let enabledBorderColor = UIColor(hex: "3DAFEB")
        let enabledTextColor = UIColor(hex: "455C73")
        TextField.appearance().enabledBackgroundColor = enabledBackgroundColor
        TextField.appearance().enabledBorderColor = enabledBorderColor
        TextField.appearance().enabledTextColor = enabledTextColor

        TextField.appearance().validBackgroundColor = enabledBackgroundColor
        TextField.appearance().validBorderColor = enabledBorderColor
        TextField.appearance().validTextColor = enabledTextColor

        TextField.appearance().activeBackgroundColor = enabledBackgroundColor
        TextField.appearance().activeBorderColor = UIColor(hex: "3DAFEB")
        TextField.appearance().activeTextColor = enabledTextColor

        TextField.appearance().inactiveBackgroundColor = enabledBackgroundColor
        TextField.appearance().inactiveBorderColor = enabledBorderColor
        TextField.appearance().inactiveTextColor = enabledTextColor

        TextField.appearance().disabledBackgroundColor = UIColor(hex: "F5F5F8")
        TextField.appearance().disabledBorderColor = UIColor(hex: "DEDEDE")
        TextField.appearance().disabledTextColor = UIColor.whiteColor()

        TextField.appearance().invalidBackgroundColor = UIColor(hex: "FFD7D7")
        TextField.appearance().invalidBorderColor = UIColor(hex: "EC3031")
        TextField.appearance().invalidTextColor = UIColor(hex: "EC3031")
    }
}
