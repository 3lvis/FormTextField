import Foundation

public struct DecimalInputValidator: InputValidatable {
    public var validation: Validation?

    public init(validation: Validation? = nil) {
        self.validation = validation
    }

    public func validateReplacementString(_ replacementString: String?, fullString: String?, inRange range: NSRange?) -> Bool {
        var valid = true
        if let validation = self.validation {
            let evaluatedString = composedString(replacementString, fullString: fullString, inRange: range)
            valid = validation.validateString(evaluatedString, complete: false)
        }

        if valid {
            let composedString = self.composedString(replacementString, fullString: fullString, inRange: range)
            if composedString.count > 0 {
                let stringSet = CharacterSet(charactersIn: composedString)
                var floatSet = CharacterSet.decimalDigits
                floatSet.insert(charactersIn: ".,")
                let hasValidElements = floatSet.isSuperset(of: stringSet)
                if hasValidElements {
                    let firstElementSet = CharacterSet(charactersIn: String(composedString.first!))
                    let integerSet = CharacterSet.decimalDigits
                    let firstCharacterIsNumber = integerSet.isSuperset(of: firstElementSet)
                    if firstCharacterIsNumber {
                        if replacementString == nil {
                            let lastElementSet = CharacterSet(charactersIn: String(composedString.last!))
                            let lastCharacterIsInvalid = !integerSet.isSuperset(of: lastElementSet)
                            if lastCharacterIsInvalid {
                                valid = false
                            }
                        }

                        if valid {
                            let elementsSeparatedByDot = composedString.components(separatedBy: ".")
                            let elementsSeparatedByComma = composedString.components(separatedBy: ",")
                            if elementsSeparatedByDot.count >= 2 && elementsSeparatedByComma.count >= 2 {
                                valid = false
                            } else if elementsSeparatedByDot.count > 2 || elementsSeparatedByComma.count > 2 {
                                valid = false
                            }
                        }
                    } else {
                        valid = false
                    }
                } else {
                    valid = false
                }
            }
        }

        return valid
    }
}
