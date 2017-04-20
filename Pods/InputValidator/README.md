# InputValidator

## Introduction

`InputValidator` is the easiest way to validate a value, things that `InputValidator` lets you validate:
- Required (non-empty)
- Maximum length
- Minimum length 
- Maximum value
- Minimum value
- Valid characters
- Format (regex)

For example if you want to validate that a value is between 5 and 6 you can do this:

```swift
let validation = Validation()
validation.minimumValue = 5
validation.maximumValue = 6

var result: Bool
let validator = InputValidator(validation: validation)
result = validator.validateString("4") // false
result = validator.validateString("5") // true
result = validator.validateString("6") // true
result = validator.validateString("7") // false
```

Find more information about the basic validations on the [`Validation` repository](https://github.com/3lvis/Validation).

It also helps you verify if a string should be inserted into another string, useful when validating inputs on a `UITextField`. For example validating the expiration date of a card, where the format is `MM/YY`, month is between 1-12 and YY is equal or later than the current year.

```objc
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string || [string isEqualToString:@"\n"]) return YES;

    CardExpirationDateInputValidator *inputValidator = [CardExpirationDateInputValidator new];
    return [inputValidator validateReplacementString:string withText:self.text withRange:range];
}
```

## Included built-in input validators

- CardExpirationDate
- Decimal

## Making your own input validator

`InputValidator` includes the `InputValidatable` protocol. Any class that conforms to this protocol can be considered an input validator. For example making an InputValidator that only allows letters could be as simple as this.

```swift
public struct LetterInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation: Validation? = nil) {
        self.validation = validation
    }

    public func validateReplacementString(replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        if valid {
            let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            if composedString.characters.count > 0 {
                let letterCharacterSet = NSCharacterSet.letterCharacterSet()
                let stringCharacterSet = NSCharacterSet(charactersInString: composedString)
                valid = letterCharacterSet.isSupersetOfSet(stringCharacterSet)
            }
        }

        return valid
    }
}

let validator = LetterInputValidator()
result = validator.validateString("A") // true
result = validator.validateString("2") // false
result = validator.validateString("AA") // true
result = validator.validateString("A7-w") // false
```

## Installation

**InputValidator** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InputValidator'
```

## License

**InputValidator** is available under the MIT license. See the LICENSE file for more info.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)
