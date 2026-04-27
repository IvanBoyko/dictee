import Foundation

/// Aligns OCR chunks from a paper-session photo to the dictated word order.
///
/// Pure function — no Vision, no SwiftUI, no SwiftData. The view layer calls
/// this after `OCRService.recognizeText`, then zips the result with
/// `SessionWord` to build `Answer` records.
///
/// **Recovery**: when OCR returns fewer chunks than expected (the pupil
/// forgot a separator and the recogniser merged multiple answers into one
/// chunk), chunks containing internal whitespace are split so each piece
/// occupies its own position. Spelling correctness is decided downstream by
/// `Answer.correct`; this matcher only restores positional alignment.
enum PaperSessionMatcher {
    struct Result: Equatable {
        let typed: [String]
        /// Number of OCR chunks that were split during recovery. Each
        /// recovered chunk represents one missing separator and warrants a
        /// neatness-score dock from the caller.
        let recoveredChunks: Int
    }

    static func match(ocrChunks: [String], expectedCount: Int) -> Result {
        var typed: [String] = []
        var i = 0
        var j = 0
        var deficit = expectedCount - ocrChunks.count
        var recovered = 0

        while j < expectedCount {
            guard i < ocrChunks.count else {
                typed.append("")
                j += 1
                continue
            }

            let chunk = ocrChunks[i]
            let pieces = chunk
                .split(whereSeparator: \.isWhitespace)
                .map(String.init)

            if pieces.count > 1 && deficit > 0 {
                let take = min(pieces.count, expectedCount - j)
                typed.append(contentsOf: pieces.prefix(take))
                deficit -= (take - 1)
                j += take
                i += 1
                recovered += 1
            } else {
                typed.append(chunk)
                i += 1
                j += 1
            }
        }

        return Result(typed: typed, recoveredChunks: recovered)
    }
}
