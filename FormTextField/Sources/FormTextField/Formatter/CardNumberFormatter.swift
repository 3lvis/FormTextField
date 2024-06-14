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
        for (index, character) in self.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
        }
        return formattedString
    }
}
