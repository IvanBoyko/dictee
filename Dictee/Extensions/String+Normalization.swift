import Foundation

extension String {
    /// Returns the string in a canonical form suitable for dictation comparison:
    /// - Folds all apostrophe variants to a plain straight apostrophe (U+0027)
    /// - Lowercases
    /// - Trims leading/trailing whitespace
    ///
    /// Characters normalised:
    ///   U+2019  '  RIGHT SINGLE QUOTATION MARK  (iOS Smart Punctuation default)
    ///   U+2018  '  LEFT SINGLE QUOTATION MARK
    ///   U+02BC  ʼ  MODIFIER LETTER APOSTROPHE
    var normalizedForDictation: String {
        let apostropheVariants: [Character] = ["\u{2019}", "\u{2018}", "\u{02BC}"]
        let folded = apostropheVariants.reduce(self) {
            $0.replacingOccurrences(of: String($1), with: "'")
        }
        return folded
            .trimmingCharacters(in: .whitespaces)
            .lowercased()
    }
}
