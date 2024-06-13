import Foundation

/**
 This input validator should validate strings with the following pattern:
 MM/YY, where MM is month and YY is year. MM shouldn't be more than 12 and year
 can be pretty much any number above the current year (this to ensure that the
 card is not expired).
 */
public struct CardExpirationDateInputValidator: InputValidatable {
    public var validation: Validation?
    public var baselineDate = Date()

    public init(validation: Validation? = nil) {
        var predefinedValidation = Validation()
        predefinedValidation.minimumLength = "MM/YY".count
        predefinedValidation.maximumLength = "MM/YY".count
        var characterSet = CharacterSet.decimalDigits
        characterSet.insert(charactersIn: "/")
        predefinedValidation.characterSet = characterSet
        self.validation = predefinedValidation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        if valid {
            let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)

            // Ensure the first two digits form a valid month (01-12)
            if composedString.count >= 2 {
                let monthString = composedString.prefix(2)
                if let month = Int(monthString), month < 1 || month > 12 {
                    return false
                }
            }

            if composedString.count > 0 {
                var precomposedString = composedString
                if composedString.count == 4 || composedString.count == 5 {
                    let index = composedString.index(composedString.startIndex, offsetBy: "MM/".count)
                    precomposedString = String(composedString[index...])
                }

                let formatter = NumberFormatter()
                let number = formatter.number(from: precomposedString)?.intValue
                if let number = number {
                    switch composedString.count {
                    case 1:
                        valid = (number == 0 || number == 1)
                    case 2:
                        let maximumMonth = 12
                        valid = (number > 0 && number <= maximumMonth)
                    case 3:
                        valid = (replacementString == "/")
                    case 4, 5:
                        let year = Calendar.current.component(.year, from: baselineDate)
                        let currentMonth = Calendar.current.component(.month, from: baselineDate)
                        let century = floor(Double(year) / 100.0)
                        let basicYear = Double(year) - (century * 100.0)
                        let decade = floor(basicYear / 10.0)

                        let isDecimal = (precomposedString.count == 1)
                        let isYear = (precomposedString.count == 2)
                        if isDecimal {
                            valid = number >= Int(decade)
                        } else if isYear {
                            valid = number >= Int(basicYear)
                        }

                        if composedString.count == 5, valid {
                            let monthString = composedString.prefix(2)
                            let yearString = composedString.suffix(2)
                            if let month = Int(monthString), let expYear = Int(yearString) {
                                if expYear == Int(basicYear) && month < currentMonth {
                                    valid = false
                                } else if expYear < Int(basicYear) {
                                    valid = false
                                }
                            }
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
