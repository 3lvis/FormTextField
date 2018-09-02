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
        // remove whitespaces and possible repeating dots
        return string.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "..", with: ".")
    }
    
}

public class Validation {
    
    public var name: String? { didSet { reloadErrorTexts() } }
    public var minimumLength = 0 { didSet { reloadErrorTexts() } }
    public var maximumLength: Int? { didSet { reloadErrorTexts() } }
    public var maximumValue: Double? { didSet { reloadErrorTexts() } }
    public var minimumValue: Double? { didSet { reloadErrorTexts() } }
    public var characterSet: CharacterSet? { didSet { reloadErrorTexts() } }
    public var format: String? { didSet { reloadErrorTexts() } }
    public var errors = ValidationErrors()
    
    public init(name: String? = nil, minLength: Int = 0, maxLength: Int? = nil, minValue: Double? = nil, maxValue: Double? = nil, charSet: CharacterSet? = nil, format: String? = nil) {
        self.name = name
        minimumLength = minLength
        maximumLength = maxLength
        if maximumLength != nil {
            assert(minimumLength <= maximumLength!, "Invalid min/max length bounds.")
        }
        minimumValue = minValue
        maximumValue = maxValue
        if let min = minimumValue, let max = maximumValue {
            assert(min <= max, "Invalid min/max value bounds.")
        }
        characterSet = charSet
        self.format = format
        // configure default errors text
        reloadErrorTexts()
    }
    
    /// Sets default texts for different error types. Depends on `name` field, it must be non-nil to proceed.
    public func reloadErrorTexts() {
        guard let name = name else {
            return
        }
        if errors.minimumLength.text == nil {
            errors.minimumLength.text = (
                minimumLength == 1
                    ? "\(name) is required."
                    : "\(name) must contain \(minimumLength) characters or more."
            )
        }
        if errors.maximumLength.text == nil && maximumLength != nil {
            errors.maximumLength.text = "\(name) must contain \(maximumLength!) characters or less."
        }
        if errors.minimumValue.text == nil && minimumValue != nil {
            errors.minimumValue.text = "\(name) must be greater than or equal to \(minimumValue!)."
        }
        if errors.maximumValue.text == nil && maximumValue != nil {
            errors.maximumValue.text = "\(name) must be less than or equal to \(maximumValue!)."
        }
        if errors.characterSet.text == nil && characterSet != nil {
            errors.characterSet.text = "\(name) must contain only characters in set \(characterSet!)."
        }
        if errors.format.text == nil && self.format != nil {
            errors.format.text = "\(name) has invalid format."
        }
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
