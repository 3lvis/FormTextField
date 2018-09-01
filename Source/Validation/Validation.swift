import Foundation

public class ValidationErrors: CustomStringConvertible {
    
    public typealias ValidationError = (text: String?, occured: Bool)
    
    public var minimumLength = ValidationError(nil, false)
    public var maximumLength = ValidationError(nil, false)
    public var minimumValue = ValidationError(nil, false)
    public var maximumValue = ValidationError(nil, false)
    public var characterSet = ValidationError(nil, false)
    public var format = ValidationError(nil, false)
    
    public func reset() {
        minimumLength.occured = false
        maximumLength.occured = false
        minimumValue.occured = false
        maximumValue.occured = false
        characterSet.occured = false
        format.occured = false
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        var string = ""
        let list: [ValidationError] = [minimumLength, maximumLength, minimumValue, maximumValue, characterSet, format]
        for item in list {
            if let text = item.text, item.occured {
                string.append(" \(text).")
            }
        }
        return string.trimmingCharacters(in: .whitespaces)
    }
    
}

public class Validation {
    
    public var minimumLength = 0
    public var maximumLength: Int?
    public var maximumValue: Double?
    public var minimumValue: Double?
    public var characterSet: CharacterSet?
    public var format: String?
    public var errors = ValidationErrors()
    
    public init(minLength: Int = 0, maxLength: Int? = nil, minValue: Double? = nil, maxValue: Double? = nil, charSet: CharacterSet? = nil, format: String? = nil) {
        minimumLength = minLength
        maximumLength = maxLength
        minimumValue = minValue
        maximumValue = maxValue
        characterSet = charSet
        self.format = format
    }

    // Making complete false will cause minimumLength, minimumValue and format to be ignored
    // this is useful for partial validations, or validations where the final string is
    // in process of been completed. For example when entering characters into an UITextField
    public func validateString(_ string: String, complete: Bool = true) -> Bool {
        var valid = true
        errors.reset()
        
        if complete {
            valid = (string.count >= minimumLength)
            errors.minimumLength.occured = !valid
        }

        if let maximumLength = self.maximumLength {
            if valid {
                valid = (string.count <= maximumLength)
            }
            errors.maximumLength.occured = !valid
        }

        let formatter = NumberFormatter()
        let number = formatter.number(from: string)
        if let number = number {
            if let maximumValue = self.maximumValue {
                if valid {
                    valid = (number.doubleValue <= maximumValue)
                }
                errors.maximumValue.occured = !valid
            }

            if complete {
                if let minimumValue = self.minimumValue {
                    if valid {
                        valid = (number.doubleValue >= minimumValue)
                    }
                    errors.minimumValue.occured = !valid
                }
            }
        }

        if let characterSet = self.characterSet {
            let stringCharacterSet = CharacterSet(charactersIn: string)
            if valid {
                valid = characterSet.superSetOf(other: stringCharacterSet)
            }
            errors.characterSet.occured = !valid
        }

        if complete {
            if let format = self.format {
                let regex = try! NSRegularExpression(pattern: format, options: .caseInsensitive)
                let range = regex.rangeOfFirstMatch(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.count))
                if valid {
                    valid = (range.location == 0 && range.length == string.count)
                }
                errors.format.occured = !valid
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
