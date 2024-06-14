public struct CardExpirationDateFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        if string.count > 3 {
            let newString = string.replacingOccurrences(of: "/", with: "")
            return insertSlash(at: 2, in: newString)
        } else if reverse {
            switch string.count {
            case 0, 1, 2:
                return string
            case 3:
                var newString = string.replacingOccurrences(of: "/", with: "")
                if newString.count == 3 {
                    newString = insertSlash(at: 2, in: newString)
                }
                return newString
            default:
                return ""
            }
        } else {
            switch string.count {
            case 0, 1:
                return string
            case 2:
                return "\(string)/"
            case 3:
                let newString = string.replacingOccurrences(of: "/", with: "")
                return insertSlash(at: 2, in: newString)
            default:
                return ""
            }
        }
    }

    private func insertSlash(at index: Int, in string: String) -> String {
        guard index < string.count else { return string }
        var characters = Array(string)
        characters.insert("/", at: index)
        return String(characters)
    }
}
