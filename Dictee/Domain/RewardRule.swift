import Foundation

/// Reward thresholds and progress calculation for the learner reward system.
///
/// Slice 1 has a single locked threshold; future slices may add tiers
/// (e.g. 50 → small surprise, 150 → secret game) by extending this type
/// without touching call sites.
struct RewardRule {
    /// Stars required to fill the locked Secret reward bar in Slice 1.
    static let secretRewardThreshold: Int = 50

    /// 0…1 progress toward the secret reward threshold.
    /// Stub — returns 0 until the implementation lands.
    static func progressFraction(totalStars: Int) -> Double {
        0
    }
}
