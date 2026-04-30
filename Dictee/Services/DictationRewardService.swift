import Foundation
import SwiftData

/// Grants and tallies stars earned from completed dictations.
///
/// Slice 1 rule: **1 star per correctly written word**, granted exactly once
/// per dictation session (idempotent against `SessionResult.id`).
///
/// The total balance is derived by summing all transactions on demand —
/// no cached counter to drift out of sync.
enum DictationRewardService {

    /// Pure: stars earned for a given correct-answer count.
    /// Stub — returns 0 until the implementation lands.
    static func starsEarned(correctCount: Int) -> Int {
        0
    }

    /// Idempotently records a star grant for `sessionId`.
    /// Returns the number of stars granted by *this* call (0 if the session
    /// was already awarded earlier).
    /// Stub — does nothing and returns 0 until the implementation lands.
    @MainActor
    @discardableResult
    static func award(sessionId: UUID, correctCount: Int, in context: ModelContext) -> Int {
        0
    }

    /// Total lifetime stars across all recorded transactions.
    /// Stub — returns 0 until the implementation lands.
    @MainActor
    static func totalStars(in context: ModelContext) -> Int {
        0
    }
}
