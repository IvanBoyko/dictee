import SwiftUI
import SwiftData

struct RevisitSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \ReviewBankEntry.addedAt) private var reviewBank: [ReviewBankEntry]
    @AppStorage("revisitSessionCap") private var sessionCap: Int = 20

    /// Words are snapshotted once on first appear so that Review Bank deletions
    /// performed by ResultsView.persistResults() don't trigger a structural
    /// re-render that would tear down SessionView / ResultsView mid-session.
    @State private var snapshot: [SessionWord]? = nil

    enum SessionMode { case typed, paper }
    @State private var selectedMode: SessionMode? = nil

    var body: some View {
        Group {
            if let words = snapshot {
                if words.isEmpty {
                    // Shouldn't normally appear (banner is hidden when bank is empty)
                    ContentUnavailableView(
                        "Review Bank Empty",
                        systemImage: "checkmark.circle",
                        description: Text("All caught up! Keep practising your word lists.")
                    )
                } else {
                    switch selectedMode {
                    case .none:
                        SessionModePicker(
                            heading: "Revisit · \(words.count) \(words.count == 1 ? "word" : "words")",
                            onTyped: { selectedMode = .typed },
                            onPaper:  { selectedMode = .paper }
                        )
                    case .typed:
                        // onComplete is intentionally omitted: the sheet is dismissed by
                        // the "Back to Home" button in ResultsView → dismiss().
                        SessionView(
                            words: words,
                            title: "Revisit",
                            listId: nil,
                            isRevisit: true
                        )
                    case .paper:
                        // Neatness is shown in results but not persisted (words span
                        // multiple lists), so onNeatnessSaved is omitted.
                        PaperSessionView(
                            words: words,
                            title: "Revisit",
                            listId: nil,
                            isRevisit: true
                        )
                    }
                }
            }
            // snapshot == nil: empty Group for one frame until onAppear fires.
        }
        .onAppear {
            guard snapshot == nil else { return }
            snapshot = Array(reviewBank.prefix(sessionCap)).map {
                SessionWord(id: $0.id, text: $0.wordText, reviewEntryId: $0.id)
            }
        }
    }


}
