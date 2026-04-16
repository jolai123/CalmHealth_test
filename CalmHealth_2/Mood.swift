import Foundation

enum MoodType: String, CaseIterable, Codable, Identifiable {
    case verySad = "Very Sad"
    case sad = "Sad"
    case neutral = "Neutral"
    case happy = "Happy"
    case veryHappy = "Very Happy"
    
    var id: String { self.rawValue }
}

struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mood: MoodType
    let note: String?
    
    init(date: Date, mood: MoodType, note: String? = nil) {
        self.id = UUID()
        self.date = date
        self.mood = mood
        self.note = note
    }
}
