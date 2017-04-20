public struct CardNumberFormatter: Formattable {
    public init() { }

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        var formattedString = String()
        let normalizedString = string.replacingOccurrences(of: " ", with: "")
        if reverse {
            formattedString = normalizedString
        } else {
            var idx = 0
            var character: Character
            while idx < normalizedString.characters.count {
                let index = normalizedString.characters.index(normalizedString.startIndex, offsetBy: idx)
                character = normalizedString[index]

                if idx != 0 && idx % 4 == 0 {
                    formattedString.append(" ")
                }

                formattedString.append(character)
                idx += 1
            }
        }

        return formattedString
    }
}
