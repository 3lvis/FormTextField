import Foundation
import Hex
import FormTextField

struct CustomStyle {
    static func apply() {
        let enabledBackgroundColor = UIColor.whiteColor()
        let enabledBorderColor = UIColor(hex: "DFDFDF")
        let enabledTextColor = UIColor(hex: "455C73")
        let activeBorderColor = UIColor(hex: "70D7FF")

        FormTextField.appearance().borderWidth = 2
        FormTextField.appearance().cornerRadius = 10
        FormTextField.appearance().clearButtonColor = activeBorderColor
        FormTextField.appearance().font = UIFont(name: "AvenirNext-Regular", size: 15)!

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

        FormTextField.appearance().disabledBackgroundColor = UIColor(hex: "DFDFDF")
        FormTextField.appearance().disabledBorderColor = UIColor(hex: "DFDFDF")
        FormTextField.appearance().disabledTextColor = UIColor.whiteColor()

        FormTextField.appearance().invalidBackgroundColor = UIColor(hex: "FFC9C8")
        FormTextField.appearance().invalidBorderColor = UIColor(hex: "FF4B47")
        FormTextField.appearance().invalidTextColor = UIColor(hex: "FF4B47")
    }
}




