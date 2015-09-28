import Foundation
import Hex

struct CustomStyle {
    static func applyStyle() {
        TextField.appearance().setBorderWidth(2)
        TextField.appearance().setCornerRadius(30)
        TextField.appearance().setCustomFont(UIFont(name: "AvenirNext-Regular", size: 15))

        TextField.appearance().setActiveBackgroundColor(UIColor.whiteColor())
        TextField.appearance().setActiveBorderColor(UIColor(hex: "70D7FF"))

        TextField.appearance().setValidBackgroundColor(UIColor.whiteColor())
        TextField.appearance().setValidBorderColor(UIColor(hex: "70D7FF"))

        TextField.appearance().setEnabledBackgroundColor(UIColor.whiteColor())
        TextField.appearance().setEnabledBorderColor(UIColor(hex: "DFDFDF"))
        TextField.appearance().setEnabledTextColor(UIColor(hex: "455C73"))

        TextField.appearance().setDisabledBackgroundColor(UIColor(hex: "DFDFDF"))
        TextField.appearance().setDisabledBorderColor(UIColor(hex: "DFDFDF"))
        TextField.appearance().setDisabledTextColor(UIColor.grayColor())

        TextField.appearance().setInactiveBackgroundColor(UIColor.whiteColor())
        TextField.appearance().setInactiveBorderColor(UIColor(hex: "DFDFDF"))

        TextField.appearance().setInvalidBackgroundColor(UIColor(hex: "FFC9C8"))
        TextField.appearance().setInvalidBorderColor(UIColor(hex: "FF4B47"))
    }
}
