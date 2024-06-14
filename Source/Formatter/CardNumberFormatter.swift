public struct CardNumberFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        var formattedString = String()
        let normalizedString = string.replacingOccurrences(of: " ", with: "")

        if reverse {
            // If reverse is true, just return the normalized string with spaces removed
            var idx = 0
            for character in normalizedString {
                if idx != 0 && idx % 4 == 0 {
                    formattedString.append(" ")
                }
                formattedString.append(character)
                idx += 1
            }
        } else {
            // If reverse is false, add spaces every four characters
            var idx = 0
            for character in normalizedString {
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
