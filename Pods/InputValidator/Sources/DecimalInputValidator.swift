import Foundation
import Validation

public struct DecimalInputValidator: InputValidatable {
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
                let stringSet = NSCharacterSet(charactersInString: composedString)
                let floatSet = NSMutableCharacterSet.decimalDigitCharacterSet()
                floatSet.addCharactersInString(".,")
                let hasValidElements = floatSet.isSupersetOfSet(stringSet)
                if hasValidElements  {
                    let firstElementSet = NSCharacterSet(charactersInString: String(composedString.characters.first!))
                    let integerSet = NSCharacterSet.decimalDigitCharacterSet()
                    let firstCharacterIsNumber = integerSet.isSupersetOfSet(firstElementSet)
                    if firstCharacterIsNumber {
                        if replacementString == nil {
                            let lastElementSet = NSCharacterSet(charactersInString: String(composedString.characters.last!))
                            let lastCharacterIsInvalid = !integerSet.isSupersetOfSet(lastElementSet)
                            if lastCharacterIsInvalid {
                                valid = false
                            }
                        }

                        if valid {
                            let elementsSeparatedByDot = composedString.componentsSeparatedByString(".")
                            let elementsSeparatedByComma = composedString.componentsSeparatedByString(",")
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
