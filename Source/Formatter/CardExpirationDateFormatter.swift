public struct CardExpirationDateFormatter: Formattable {
    public init() { }

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        var formattedString = String()
        let normalizedString = string.replacingOccurrences(of: "/", with: "")
        if reverse {
            formattedString = normalizedString
        } else {
            var idx = 0
            var character: Character
            while idx < normalizedString.characters.count {
                let index = normalizedString.characters.index(normalizedString.startIndex, offsetBy: idx)
                character = normalizedString[index]

                formattedString.append(character)
                if idx == 1{
                    formattedString.append("/")
                }

                idx += 1
            }
        }

        return formattedString
    }
}
