public struct CardExpirationDateFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        if string.count > 3 {
            let newString = string.replacingOccurrences(of: "/", with: "")
            return insertSlash(at: 2, in: newString)
        } else if reverse {
            switch string.count {
            case 0: return string
            case 1: return string
            case 2: return string
            case 3: 
                var newString = string.replacingOccurrences(of: "/", with: "")
                if newString.count == 3 {
                    newString = insertSlash(at: 2, in: newString)
                }
                return newString
            default: return ""
            }
        } else {
            switch string.count {
            case 0: return string
            case 1: return string
            case 2: return "\(string)/"
            case 3:
                let newString = string.replacingOccurrences(of: "/", with: "")
                return insertSlash(at: 2, in: newString)
            default: return ""
            }
        }
    }

    func insertSlash(at index: Int, in string: String) -> String {
        // Ensure the index is within the bounds of the string
        guard index < string.count else { return string }

        // Convert the string to an array of characters for easier manipulation
        var characters = Array(string)

        // Insert the "/" at the specified index
        characters.insert("/", at: index)

        // Convert the character array back to a string and return it
        return String(characters)
    }
}
