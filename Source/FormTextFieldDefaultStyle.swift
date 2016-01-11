import UIKit
import Hex

public struct FormTextFieldDefaultStyle {
    public static func apply() {
        let enabledBackgroundColor = UIColor(hex: "E1F5FF")
        let enabledBorderColor = UIColor(hex: "3DAFEB")
        let enabledTextColor = UIColor(hex: "455C73")
        let activeBorderColor = UIColor(hex: "3DAFEB")

        FormTextField.appearance().borderWidth = 1
        FormTextField.appearance().cornerRadius = 5
        FormTextField.appearance().accessoryButtonColor = activeBorderColor
        FormTextField.appearance().font = UIFont(name: "AvenirNext-Regular", size: 15)

        FormTextField.appearance().enabledBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().enabledBorderColor = enabledBorderColor
        FormTextField.appearance().enabledTextColor = enabledTextColor

        FormTextField.appearance().validBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().validBorderColor = enabledBorderColor
        FormTextField.appearance().validTextColor = enabledTextColor

        FormTextField.appearance().activeBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().activeBorderColor = activeBorderColor
        FormTextField.appearance().activeTextColor = enabledTextColor

        FormTextField.appearance().inactiveBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().inactiveBorderColor = enabledBorderColor
        FormTextField.appearance().inactiveTextColor = enabledTextColor

        FormTextField.appearance().disabledBackgroundColor = UIColor(hex: "F5F5F8")
        FormTextField.appearance().disabledBorderColor = UIColor(hex: "DEDEDE")
        FormTextField.appearance().disabledTextColor = UIColor.whiteColor()

        FormTextField.appearance().invalidBackgroundColor = UIColor(hex: "FFD7D7")
        FormTextField.appearance().invalidBorderColor = UIColor(hex: "EC3031")
        FormTextField.appearance().invalidTextColor = UIColor(hex: "EC3031")
    }
}
