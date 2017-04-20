# Formatter

##### CardNumberFormatter
```swift
let formatter = CardNumberFormatter()
formatter.formatString("1234 5678 1234 5678") 
// => "1234 5678 1234 5678"
```

##### CardExpirationDateFormatter
```swift
let formatter = CardExpirationDateFormatter()
formatter.formatString("0119")
// => 01/19
```

Use `reverse` to return the formatted text to its original form.

```swift
let formatter = CardExpirationDateFormatter()
formatter.formatString("01/19", reverse:true)
// => 0119
```

## Installation

**Formatter** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Formatter'
```

## License

**Formatter** is available under the MIT license. See the LICENSE file for more info.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)
