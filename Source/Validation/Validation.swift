import Foundation

public struct Validation {
    public var minimumLength = 0
    public var maximumLength: Int?
    public var maximumValue: Double?
    public var minimumValue: Double?
    public var characterSet: CharacterSet?
    public var format: String?

    public init() {}

    // Making complete false will cause minimumLength, minimumValue and format to be ignored
    // this is useful for partial validations, or validations where the final string is
    // in process of been completed. For example when entering characters into an UITextField
    public func validateString(_ string: String, complete: Bool = true) -> Bool {
        var valid = true

        if complete {
            valid = (string.characters.count >= minimumLength)
        }

        if valid {
            if let maximumLength = self.maximumLength {
                valid = (string.characters.count <= maximumLength)
            }
        }

        if valid {
            let formatter = NumberFormatter()
            let number = formatter.number(from: string)
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
                let stringCharacterSet = CharacterSet(charactersIn: string)
                valid = characterSet.superSetOf(other: stringCharacterSet)
            }
        }

        if valid && complete {
            if let format = self.format {
                let regex = try! NSRegularExpression(pattern: format, options: .caseInsensitive)
                let range = regex.rangeOfFirstMatch(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.characters.count))
                valid = (range.location == 0 && range.length == string.characters.count)
            }
        }

        return valid
    }
}

extension CharacterSet {
    // Workaround for crash in Swift:
    // https://github.com/apple/swift/pull/4162
    func superSetOf(other: CharacterSet) -> Bool {
        return CFCharacterSetIsSupersetOfSet(self as CFCharacterSet, (other as NSCharacterSet).copy() as! CFCharacterSet)
    }
}
