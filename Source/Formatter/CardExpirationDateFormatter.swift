public struct CardExpirationDateFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        var formattedString = String()
        let normalizedString = string.replacingOccurrences(of: "/", with: "")
        if reverse {
            formattedString = normalizedString
        } else {
            var idx = 0
            var character: Character
            while idx < normalizedString.count {
                let index = normalizedString.index(normalizedString.startIndex, offsetBy: idx)
                character = normalizedString[index]

                if idx == 2 {
                    formattedString.append("/")
                }
                formattedString.append(character)

                idx += 1
            }
        }

        return formattedString
    }
}
