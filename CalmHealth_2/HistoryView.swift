//
//  HistoryView.swift
//  HealthKitNoModify
//
//  Created by Copilot on 9/4/2026.
//

import SwiftUI

struct HealthRecord: Identifiable {
    let id = UUID()
    let type: String
    let value: String
    let date: Date
    let icon: String
    let color: Color
}

struct HistoryView: View {
    @State private var selectedTab = 0
    @State private var mockRecords: [HealthRecord] = []
    @AppStorage("moodEntries") private var moodEntriesData: Data = Data()
    
    let tabs = ["All", "Temperature", "Oxygen", "Blood Pressure", "Mood"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Measurement History")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("Track your health measurements over time")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 20)
                
                // Tab Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            Button {
                                selectedTab = index
                            } label: {
                                Text(tabs[index])
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedTab == index ? LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) : LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .foregroundColor(selectedTab == index ? .white : .gray)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                // Records List
                if mockRecords.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        Text("No Records Yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Your measurements will appear here")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredRecords) { record in
                                HistoryRecordCard(record: record)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            initializeMockData()
        }
    }
    
    var filteredRecords: [HealthRecord] {
        if selectedTab == 0 {
            return mockRecords.sorted { $0.date > $1.date }
        } else {
            let selectedType = tabs[selectedTab]
            return mockRecords.filter { $0.type == selectedType }.sorted { $0.date > $1.date }
        }
    }
    
    private func initializeMockData() {
        let now = Date()
        var records: [HealthRecord] = [
            // Temperature samples
            HealthRecord(type: "Temperature", value: "36.8°C", date: now, icon: "thermometer.sun.fill", color: Color(red: 0.70, green: 0.65, blue: 0.55)),
            HealthRecord(type: "Temperature", value: "36.5°C", date: now.addingTimeInterval(-3600), icon: "thermometer.sun.fill", color: Color(red: 0.70, green: 0.65, blue: 0.55)),
            HealthRecord(type: "Temperature", value: "37.2°C", date: now.addingTimeInterval(-7200), icon: "thermometer.sun.fill", color: Color(red: 0.70, green: 0.65, blue: 0.55)),
            
            // Oxygen samples
            HealthRecord(type: "Oxygen", value: "98% SPO2, 72 BPM", date: now.addingTimeInterval(-1800), icon: "heart.fill", color: Color(red: 0.65, green: 0.55, blue: 0.70)),
            HealthRecord(type: "Oxygen", value: "97% SPO2, 68 BPM", date: now.addingTimeInterval(-5400), icon: "heart.fill", color: Color(red: 0.65, green: 0.55, blue: 0.70)),
            HealthRecord(type: "Oxygen", value: "99% SPO2, 75 BPM", date: now.addingTimeInterval(-10800), icon: "heart.fill", color: Color(red: 0.65, green: 0.55, blue: 0.70)),
            
            // Blood Pressure samples
            HealthRecord(type: "Blood Pressure", value: "120/80 mmHg", date: now.addingTimeInterval(-2700), icon: "waveform.circle.fill", color: Color(red: 0.40, green: 0.65, blue: 0.65)),
            HealthRecord(type: "Blood Pressure", value: "118/78 mmHg", date: now.addingTimeInterval(-6300), icon: "waveform.circle.fill", color: Color(red: 0.40, green: 0.65, blue: 0.65)),
            HealthRecord(type: "Blood Pressure", value: "122/82 mmHg", date: now.addingTimeInterval(-14400), icon: "waveform.circle.fill", color: Color(red: 0.40, green: 0.65, blue: 0.65)),
        ]
        
        // Load mood entries
        if let moodEntries = try? JSONDecoder().decode([MoodEntry].self, from: moodEntriesData) {
            for mood in moodEntries {
                let moodRecord = HealthRecord(
                    type: "Mood",
                    value: mood.mood.rawValue.capitalized + ((mood.note ?? "").isEmpty ? "" : " - \(mood.note ?? "")"),
                    date: mood.date,
                    icon: getMoodIcon(mood.mood),
                    color: getMoodColor(mood.mood)
                )
                records.append(moodRecord)
            }
        }
        
        mockRecords = records
    }
    
    private func getMoodIcon(_ mood: MoodType) -> String {
        switch mood {
        case .verySad: return "😢"
        case .sad: return "🙁"
        case .neutral: return "😐"
        case .happy: return "face.smiling"
        case .veryHappy: return "face.smiling.fill"
        }
    }
    
    private func getMoodColor(_ mood: MoodType) -> Color {
        switch mood {
        case .verySad: return Color(red: 0.8, green: 0.3, blue: 0.3)
        case .sad: return Color(red: 0.9, green: 0.5, blue: 0.3)
        case .neutral: return Color(red: 0.6, green: 0.6, blue: 0.6)
        case .happy: return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .veryHappy: return Color(red: 0.9, green: 0.8, blue: 0.2)
        }
    }
}

struct HistoryRecordCard: View {
    let record: HealthRecord
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .center, spacing: 0) {
                    if record.type == "Mood" {
                        Text(record.icon)
                            .font(.title2)
                    } else {
                        Image(systemName: record.icon)
                            .font(.title2)
                            .foregroundColor(record.color)
                    }
                }
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [record.color.opacity(0.3), record.color.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.type)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text(record.value)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(record.color)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formatTime(record.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(formatDate(record.date))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.1), radius: 3)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
}
