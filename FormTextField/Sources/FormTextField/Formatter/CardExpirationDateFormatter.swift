public struct CardExpirationDateFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        if string.count > 3 {
            let newString = string.replacingOccurrences(of: "/", with: "")
            return insertSlash(at: 2, in: newString)
        } else if reverse {
            if string.count == 2 {
                return String(string.dropLast())
            } else {
                return string
            }
        } else {
            switch string.count {
            case 2:
                return "\(string)/"
            case 3:
                let newString = string.replacingOccurrences(of: "/", with: "")
                return insertSlash(at: 2, in: newString)
            default:
                return string
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
