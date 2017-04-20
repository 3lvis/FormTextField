import Foundation

public struct Validation {
    public var required: Bool? = nil
    public var minimumLength: Int? = nil
    public var maximumLength: Int? = nil
    public var maximumValue: Double? = nil
    public var minimumValue: Double? = nil
    public var characterSet: NSCharacterSet? = nil
    public var format: String? = nil

    public init() { }

    // Making complete false will cause minimumLength, minimumValue and format to be ignored
    // this is useful for partial validations, or validations where the final string is
    // in process of been completed. For example when entering characters into an UITextField
    public func validateString(string: String, complete: Bool = true) -> Bool {
        var valid = true

        if complete {
            var minimumLength: Int? = nil

            if let required = self.required where required == true {
                minimumLength = 1
            }

            if let validationMinimumLength = self.minimumLength {
                minimumLength = validationMinimumLength
            }

            if let minimumLength = minimumLength {
                valid = (string.characters.count >= minimumLength)
            }
        }

        if valid {
            if let maximumLength = self.maximumLength {
                valid = (string.characters.count <= maximumLength)
            }
        }

        if valid {
            let formatter = NSNumberFormatter()
            let number = formatter.numberFromString(string)
            if let number = number {
                if let maximumValue = self.maximumValue {
                    valid = (number.doubleValue <= maximumValue)
                }

                if valid && complete {
                    if let minimumValue = self.minimumValue {
                        valid = (number.doubleValue >= minimumValue)
                    }
                }
            }
        }

        if valid {
            if let characterSet = self.characterSet {
                let stringCharacterSet = NSCharacterSet(charactersInString: string)
                valid = characterSet.isSupersetOfSet(stringCharacterSet)
            }
        }

        if valid && complete {
            if let format = self.format {
                let regex = try! NSRegularExpression(pattern: format, options: .CaseInsensitive)
                let range = regex.rangeOfFirstMatchInString(string, options: .ReportProgress, range: NSRange(location: 0, length: string.characters.count))
                valid = (range.location == 0 && range.length == string.characters.count)
            }
        }

        return valid
    }
}
