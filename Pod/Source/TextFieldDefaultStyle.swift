import UIKit
import Hex

struct TextFieldDefaultStyle {
    static func apply() {
        TextField.appearance().borderWidth = 1
        TextField.appearance().cornerRadius = 5
        TextField.appearance().accessoryButtonColor = UIColor(hex: "3DAFEB")
        TextField.appearance().font = UIFont(name: "AvenirNext-Regular", size: 15)

        TextField.appearance().activeBackgroundColor = UIColor(hex: "C0EAFF")
        TextField.appearance().activeBorderColor = UIColor(hex: "3DAFEB")

        TextField.appearance().validBackgroundColor = UIColor(hex: "E1F5FF")
        TextField.appearance().validBorderColor = UIColor(hex: "3DAFEB")

        TextField.appearance().enabledBackgroundColor = UIColor(hex: "E1F5FF")
        TextField.appearance().enabledBorderColor = UIColor(hex: "3DAFEB")
        TextField.appearance().enabledTextColor = UIColor(hex: "455C73")

        TextField.appearance().disabledBackgroundColor = UIColor(hex: "F5F5F8")
        TextField.appearance().disabledBorderColor = UIColor(hex: "DEDEDE")
        TextField.appearance().disabledTextColor = UIColor.grayColor()

        TextField.appearance().inactiveBackgroundColor = UIColor(hex: "E1F5FF")
        TextField.appearance().inactiveBorderColor = UIColor(hex: "3DAFEB")

        TextField.appearance().invalidBackgroundColor = UIColor(hex: "FFD7D7")
        TextField.appearance().invalidBorderColor = UIColor(hex: "EC3031")

    }
}
