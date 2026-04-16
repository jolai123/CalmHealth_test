import SwiftUI

struct MoodTrackerView: View {
    @AppStorage("moodEntries") private var moodEntriesData: Data = Data()
    @State private var selectedMood: MoodType? = nil
    @State private var note: String = ""
    @State private var showSavedAlert = false
    @State private var entries: [MoodEntry] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("How are you feeling today?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 24) {
                                ForEach(MoodType.allCases) { mood in
                                    Button(action: {
                                        selectedMood = mood
                                    }) {
                                        VStack(spacing: 8) {
                                            ZStack {
                                                Circle()
                                                    .fill(moodColor(for: mood).opacity(selectedMood == mood ? 0.7 : 0.25))
                                                    .frame(width: 64, height: 64)
                                                    if mood == .happy || mood == .veryHappy {
                                                        Image(systemName: icon(for: mood))
                                                            .font(.system(size: 32))
                                                            .foregroundColor(moodColor(for: mood))
                                                    } else {
                                                        Text(icon(for: mood))
                                                            .font(.system(size: 32))
                                                        }
                                            }
                                            Text(mood.rawValue)
                                                .font(.caption)
                                                .foregroundColor(selectedMood == mood ? moodColor(for: mood) : .primary)
                                                .frame(width: 80)
                                        }
                                        .frame(width: 90)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        TextField("Add a note (optional)", text: $note)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        Button("Save Mood") {
                            saveMood()
                        }
                        .disabled(selectedMood == nil)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(selectedMood == nil ? Color.gray : Color(red: 0.2, green: 0.5, blue: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .alert(isPresented: $showSavedAlert) {
                            Alert(title: Text("Mood Saved!"))
                        }
                        Divider()
                        Text("Mood History")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                        VStack(spacing: 0) {
                            ForEach(entries.sorted { $0.date > $1.date }) { entry in
                                HStack {
                                    if entry.mood == .happy || entry.mood == .veryHappy {
                                        Image(systemName: icon(for: entry.mood))
                                            .font(.system(size: 24))
                                            .foregroundColor(moodColor(for: entry.mood))
                                    } else {
                                        Text(icon(for: entry.mood))
                                            .font(.system(size: 24))
                                    }
                                    VStack(alignment: .leading) {
                                        Text(entry.mood.rawValue)
                                        if let note = entry.note, !note.isEmpty {
                                            Text(note).font(.caption).foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    Text(dateString(entry.date))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding()
                }
                .navigationTitle("Mood Tracker")
                .onAppear(perform: loadEntries)
            }
        }
    }
    
    func icon(for mood: MoodType) -> String {
        switch mood {
        case .verySad: return "😢" // Emoji for very sad
        case .sad: return "🙁" // Emoji for sad
        case .neutral: return "😐" // Emoji for neutral
        case .happy: return "face.smiling" // SF Symbol for happy
        case .veryHappy: return "face.smiling.fill" // SF Symbol for very happy
        }
    }

    func moodColor(for mood: MoodType) -> Color {
        switch mood {
        case .verySad: return Color(red: 0.7, green: 0.2, blue: 0.2)
        case .sad: return Color(red: 0.9, green: 0.4, blue: 0.4)
        case .neutral: return Color.gray
        case .happy: return Color(red: 0.3, green: 0.7, blue: 0.4)
        case .veryHappy: return Color(red: 1.0, green: 0.8, blue: 0.2)
        }
    }
    
    func saveMood() {
        guard let mood = selectedMood else { return }
        let entry = MoodEntry(date: Date(), mood: mood, note: note)
        entries.append(entry)
        if let data = try? JSONEncoder().encode(entries) {
            moodEntriesData = data
        }
        showSavedAlert = true
        selectedMood = nil
        note = ""
    }
    
    func loadEntries() {
        if let loaded = try? JSONDecoder().decode([MoodEntry].self, from: moodEntriesData) {
            entries = loaded
        }
    }
    
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    MoodTrackerView()
}
