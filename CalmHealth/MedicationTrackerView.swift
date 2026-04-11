//
//  MedicationTrackerView.swift
//  HealthKitNoModify
//
//  Created on 10/4/2026.
//

import SwiftUI

struct MedicationTrackerView: View {
    @AppStorage("medications") var medicationsData: Data = Data()
    @AppStorage("medicationLogs") var medicationLogsData: Data = Data()
    
    @State private var medications: [MedicationReminder] = []
    @State private var medicationLogs: [MedicationLog] = []
    @State private var showAddMedication = false
    @State private var selectedTab: String = "Active"
    
    let tabs = ["Active", "History"]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("💊 Medications")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("Track your medications and reminders")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.3))
                
                // Tab buttons
                HStack(spacing: 12) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: { selectedTab = tab }) {
                            Text(tab)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(selectedTab == tab ? .white : Color(red: 0.4, green: 0.65, blue: 0.65))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    selectedTab == tab ?
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 0.4, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.4, green: 0.65, blue: 0.65).opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) : LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        if selectedTab == "Active" {
                            ActiveMedicationsSection(
                                medications: medications,
                                medicationLogs: medicationLogs,
                                onMarkTaken: markMedicationTaken,
                                onDelete: deleteMedication
                            )
                        } else {
                            MedicationHistorySection(
                                medications: medications,
                                medicationLogs: medicationLogs
                            )
                        }
                    }
                    .padding()
                }
                
                // Add button
                Button(action: { showAddMedication = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Medication")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.4, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.4, green: 0.65, blue: 0.65).opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showAddMedication) {
            AddMedicationSheet(
                isPresented: $showAddMedication,
                onSave: addMedication
            )
        }
        .onAppear {
            loadMedications()
        }
    }
    
    // MARK: - Load Medications
    private func loadMedications() {
        if let decodedMeds = try? JSONDecoder().decode([MedicationReminder].self, from: medicationsData) {
            medications = decodedMeds
        }
        if let decodedLogs = try? JSONDecoder().decode([MedicationLog].self, from: medicationLogsData) {
            medicationLogs = decodedLogs
        }
    }
    
    // MARK: - Save Medications
    private func saveMedications() {
        if let encoded = try? JSONEncoder().encode(medications) {
            medicationsData = encoded
        }
        if let encoded = try? JSONEncoder().encode(medicationLogs) {
            medicationLogsData = encoded
        }
    }
    
    // MARK: - Add Medication
    private func addMedication(_ medication: MedicationReminder) {
        medications.append(medication)
        saveMedications()
        
        // Schedule notifications
        for time in medication.reminderTimes {
            NotificationManager.shared.scheduleMedicationReminder(medication: medication, reminderTime: time)
        }
    }
    
    // MARK: - Mark as Taken
    private func markMedicationTaken(_ medicationId: UUID) {
        let log = MedicationLog(
            medicationId: medicationId,
            date: Date(),
            timeTaken: Date(),
            status: .taken
        )
        medicationLogs.append(log)
        saveMedications()
        
        // Show confirmation
        print("✅ Medication marked as taken!")
    }
    
    // MARK: - Delete Medication
    private func deleteMedication(_ medicationId: UUID) {
        medications.removeAll { $0.id == medicationId }
        medicationLogs.removeAll { $0.medicationId == medicationId }
        saveMedications()
        
        // Cancel notifications
        NotificationManager.shared.cancelAllRemindersForMedication(medicationId: medicationId)
    }
}

// MARK: - Active Medications Section
struct ActiveMedicationsSection: View {
    let medications: [MedicationReminder]
    let medicationLogs: [MedicationLog]
    let onMarkTaken: (UUID) -> Void
    let onDelete: (UUID) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if medications.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "pills")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("No Active Medications")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Add your first medication to get started")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
            } else {
                ForEach(medications.filter { $0.isActive }) { med in
                    MedicationCard(
                        medication: med,
                        isTakenToday: isMedicationTakenToday(med.id),
                        onMarkTaken: { onMarkTaken(med.id) },
                        onDelete: { onDelete(med.id) }
                    )
                }
            }
        }
    }
    
    private func isMedicationTakenToday(_ medicationId: UUID) -> Bool {
        medicationLogs.contains { log in
            log.medicationId == medicationId &&
            Calendar.current.isDateInToday(log.date) &&
            log.status == .taken
        }
    }
}

// MARK: - Medication Card
struct MedicationCard: View {
    let medication: MedicationReminder
    let isTakenToday: Bool
    let onMarkTaken: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteConfirm = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(medication.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(medication.dosage)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.70))
                        Text(getNextReminderTime(medication.reminderTimes))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: onMarkTaken) {
                        Image(systemName: isTakenToday ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.system(size: 24))
                            .foregroundColor(isTakenToday ? Color(red: 0.4, green: 0.65, blue: 0.65) : .gray)
                    }
                    
                    Button(action: { showDeleteConfirm = true }) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            if !medication.notes.isEmpty {
                Text(medication.notes)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .italic()
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .alert("Delete Medication?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This will remove '\(medication.name)' and cancel all reminders.")
        }
    }
    
    private func getNextReminderTime(_ times: [Date]) -> String {
        guard let nextTime = times.first else { return "No reminders" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "Next: " + formatter.string(from: nextTime)
    }
}

// MARK: - Medication History Section
struct MedicationHistorySection: View {
    let medications: [MedicationReminder]
    let medicationLogs: [MedicationLog]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if medicationLogs.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("No History")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Your medication logs will appear here")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
            } else {
                ForEach(medicationLogs.sorted { $0.date > $1.date }) { log in
                    if let med = medications.first(where: { $0.id == log.medicationId }) {
                        MedicationLogCard(medication: med, log: log)
                    }
                }
            }
        }
    }
}

// MARK: - Medication Log Card
struct MedicationLogCard: View {
    let medication: MedicationReminder
    let log: MedicationLog
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(medication.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                HStack(spacing: 12) {
                    Text(formatDate(log.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 4, height: 4)
                    
                    HStack(spacing: 4) {
                        Image(systemName: statusIcon(log.status))
                            .font(.caption2)
                        Text(log.status.rawValue.capitalized)
                    }
                    .font(.caption)
                    .foregroundColor(statusColor(log.status))
                }
            }
            
            Spacer()
            
            if let timeTaken = log.timeTaken {
                Text(formatTime(timeTaken))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func statusIcon(_ status: MedicationStatus) -> String {
        switch status {
        case .taken:
            return "checkmark.circle.fill"
        case .missed:
            return "xmark.circle.fill"
        case .skipped:
            return "minus.circle.fill"
        case .pending:
            return "clock.circle"
        }
    }
    
    private func statusColor(_ status: MedicationStatus) -> Color {
        switch status {
        case .taken:
            return Color(red: 0.4, green: 0.65, blue: 0.65)
        case .missed:
            return Color.red
        case .skipped:
            return Color.orange
        case .pending:
            return Color.gray
        }
    }
}

// MARK: - Add Medication Sheet
struct AddMedicationSheet: View {
    @Binding var isPresented: Bool
    let onSave: (MedicationReminder) -> Void
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var frequency: MedicationFrequency = .daily
    @State private var reminderTime = Date()
    @State private var notes = ""
    @State private var selectedHour = 8
    @State private var selectedMinute = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Medication Details") {
                    TextField("Medication Name", text: $name)
                    TextField("Dosage (e.g., 10mg)", text: $dosage)
                    TextField("Notes (optional)", text: $notes)
                }
                
                Section("Frequency") {
                    Picker("Frequency", selection: $frequency) {
                        Text("Daily").tag(MedicationFrequency.daily)
                        Text("Weekly").tag(MedicationFrequency.weekly)
                        Text("As Needed").tag(MedicationFrequency.asNeeded)
                    }
                }
                
                Section("Reminder Time") {
                    HStack {
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text(String(format: "%02d", hour))
                            }
                        }
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(Array(stride(from: 0, to: 60, by: 5)), id: \.self) { minute in
                                Text(String(format: "%02d", minute))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMedication()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveMedication() {
        var reminderDate = Calendar.current.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: Date()) ?? Date()
        
        let medication = MedicationReminder(
            name: name,
            dosage: dosage,
            frequency: frequency,
            reminderTimes: [reminderDate],
            notes: notes
        )
        
        onSave(medication)
        isPresented = false
    }
}

#Preview {
    MedicationTrackerView()
}
