import Foundation
import Validation

/**
 This input validator should validate strings with the following pattern:
 MM/YY, where MM is month and YY is year. MM shouldn't be more than 12 and year
 can be pretty much any number above the current year (this to ensure that the
 card is not expired).
 */
public struct CardExpirationDateInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation: Validation? = nil) {
        var predefinedValidation = Validation()
        predefinedValidation.minimumLength = "MM/YY".characters.count
        predefinedValidation.maximumLength = "MM/YY".characters.count
        predefinedValidation.required = validation?.required ?? false
        self.validation = predefinedValidation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        if valid {
            guard let replacementString = replacementString, let range = range else { return valid }

            var composedString = self.composedString(replacementString, fullString: fullString, inRange: range)

            if composedString.characters.count > 0 {
                var precomposedString = composedString
                if composedString.characters.count == 4 || composedString.characters.count == 5 {
                    let index = composedString.characters.index(composedString.startIndex, offsetBy: "MM/".characters.count)
                    precomposedString = composedString.substring(from: index)
                }

                let formatter = NumberFormatter()
                let number = formatter.number(from: precomposedString)?.intValue
                if let number = number {
                    switch composedString.characters.count {
                    case 1:
                        valid = (number == 0 || number == 1)
                        break
                    case 2:
                        let maximumMonth = 12
                        valid = (number > 0 && number <= maximumMonth)
                        break
                    case 3:
                        let index = composedString.characters.index(composedString.startIndex, offsetBy: "MM".characters.count)
                        composedString = composedString.substring(from: index)
                        valid = (composedString == "/")
                        break
                    case 4, 5:
                        let year = Calendar.current.component(.year, from: Date())
                        let century = floor(Double(year) / 100.0)
                        let basicYear = Double(year) - (century * 100.0)
                        let decade = floor(basicYear / 10.0)

                        let isDecimal = (precomposedString.characters.count == 1)
                        let isYear = (precomposedString.characters.count == 2)
                        if isDecimal {
                            valid = number >= Int(decade)
                        } else if isYear {
                            valid = number >= Int(basicYear)
                        }

                        break
                    default:
                        break
                    }
                }
            }
        }

        return valid
    }
}
