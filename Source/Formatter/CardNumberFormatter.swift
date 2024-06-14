public struct CardNumberFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        let normalizedString = string.replacingOccurrences(of: " ", with: "")
        return normalizedString.addSpaceEveryFourCharacters()
    }
}

private extension String {
    func addSpaceEveryFourCharacters() -> String {
        var formattedString = ""
        var idx = 0
        for character in self {
            if idx != 0 && idx % 4 == 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
            idx += 1
        }
        return formattedString
    }
}
