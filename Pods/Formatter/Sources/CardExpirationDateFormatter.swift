public struct CardExpirationDateFormatter: Formattable {
    public init() { }

    public func formatString(string: String, reverse: Bool = false) -> String {
        var formattedString = String()
        let normalizedString = string.stringByReplacingOccurrencesOfString("/", withString: "")
        if reverse {
            formattedString = normalizedString
        } else {
            var idx = 0
            var character: Character
            while idx < normalizedString.characters.count {
                let index = normalizedString.startIndex.advancedBy(idx)
                character = normalizedString[index]

                formattedString.append(character)
                if idx == 1{
                    formattedString.appendContentsOf("/")
                }

                idx += 1
            }
        }

        return formattedString
    }
}
