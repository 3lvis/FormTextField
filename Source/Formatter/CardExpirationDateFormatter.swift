public struct CardExpirationDateFormatter: Formattable {
    public init() {}

    public func formatString(_ string: String, reverse: Bool = false) -> String {
        if reverse {
            // Remove the "/" character if present
            return string.replacingOccurrences(of: "/", with: "")
        } else {
            // Add the "/" character after the second digit
            let normalizedString = string.replacingOccurrences(of: "/", with: "")
            var formattedString = ""
            for (index, character) in normalizedString.enumerated() {
                formattedString.append(character)
                if index == 1 {
                    formattedString.append("/")
                }
            }
            return formattedString
        }
    }
}
