import Foundation

class MoodAnalyticsManager {
    static func moodTrend(entries: [MoodEntry]) -> String {
        guard entries.count > 1 else { return "Not enough data for trend analysis." }
        let sorted = entries.sorted { $0.date < $1.date }
        let scores = sorted.map { score(for: $0.mood) }
        let trend = scores.last! - scores.first!
        if trend > 0 {
            return "Your mood is improving! Keep it up."
        } else if trend < 0 {
            return "Your mood has decreased. Consider self-care and reflection."
        } else {
            return "Your mood is stable."
        }
    }
    
    static func improvementTips(for entries: [MoodEntry]) -> String {
        let sadCount = entries.filter { $0.mood == .sad || $0.mood == .verySad }.count
        if sadCount > entries.count / 3 {
            return "Try to get more sleep, exercise, and talk to friends or family."
        }
        let neutralCount = entries.filter { $0.mood == .neutral }.count
        if neutralCount > entries.count / 2 {
            return "Consider new hobbies or mindfulness activities to boost your mood."
        }
        return "Keep tracking your mood and practicing gratitude."
    }
    
    private static func score(for mood: MoodType) -> Int {
        switch mood {
        case .verySad: return 1
        case .sad: return 2
        case .neutral: return 3
        case .happy: return 4
        case .veryHappy: return 5
        }
    }
}
