# FormTextField

This a `UITextField` subclass that supports styling for valid / invalid just using a boolean, formatters so you can easily format credit card numbers, phone numbers and more. It supports input validators so you can limit the contents of a UITextField using maximum length, maximum value or even regex (perfect for validating emails).

## [Native Demo](https://github.com/3lvis/FormTextField/tree/master/Native)

<p align="center">
  <img src="https://raw.githubusercontent.com/3lvis/FormTextField/master/GitHub/native.gif"/>
</p>

## [Custom Demo](https://github.com/3lvis/FormTextField/tree/master/Custom)

<p align="center">
  <img src="https://raw.githubusercontent.com/3lvis/FormTextField/master/GitHub/custom.gif"/>
</p>

### Styling

**FormTextField** also supports styling using UIAppearance protocol. The example shown above uses this for styling.

```swift
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
```

## Installation

**FormTextField** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FormTextField'
```

## License

**FormTextField** is available under the MIT license. See the LICENSE file for more info.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)
