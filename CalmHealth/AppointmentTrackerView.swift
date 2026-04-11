//
//  AppointmentTrackerView.swift
//  HealthKitNoModify
//
//  Created on 10/4/2026.
//

import SwiftUI

struct AppointmentTrackerView: View {
    @AppStorage("appointments") var appointmentsData: Data = Data()
    @AppStorage("doctors") var doctorsData: Data = Data()
    
    @State private var appointments: [Appointment] = []
    @State private var doctors: [Doctor] = []
    @State private var showAddAppointment = false
    @State private var selectedTab: String = "Upcoming"
    
    let tabs = ["Upcoming", "Past"]
    
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
                    Text("📅 Appointments")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("Manage your doctor visits and checkups")
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
                        if selectedTab == "Upcoming" {
                            UpcomingAppointmentsSection(
                                appointments: appointments,
                                doctors: doctors,
                                onDelete: deleteAppointment
                            )
                        } else {
                            PastAppointmentsSection(
                                appointments: appointments,
                                doctors: doctors
                            )
                        }
                    }
                    .padding()
                }
                
                // Add button
                Button(action: { showAddAppointment = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Appointment")
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
        .sheet(isPresented: $showAddAppointment) {
            AddAppointmentSheet(
                isPresented: $showAddAppointment,
                doctors: doctors,
                onSave: addAppointment
            )
        }
        .onAppear {
            loadData()
        }
    }
    
    // MARK: - Load Data
    private func loadData() {
        if let decodedAppts = try? JSONDecoder().decode([Appointment].self, from: appointmentsData) {
            appointments = decodedAppts
        }
        if let decodedDocs = try? JSONDecoder().decode([Doctor].self, from: doctorsData) {
            doctors = decodedDocs
        }
    }
    
    // MARK: - Save Data
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(appointments) {
            appointmentsData = encoded
        }
        if let encoded = try? JSONEncoder().encode(doctors) {
            doctorsData = encoded
        }
    }
    
    // MARK: - Add Appointment
    private func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
        saveData()
        
        // Schedule notifications
        NotificationManager.shared.scheduleAppointmentReminders(appointment: appointment)
    }
    
    // MARK: - Delete Appointment
    private func deleteAppointment(_ appointmentId: UUID) {
        appointments.removeAll { $0.id == appointmentId }
        saveData()
        NotificationManager.shared.cancelAllRemindersForAppointment(appointmentId: appointmentId)
    }
}

// MARK: - Upcoming Appointments Section
struct UpcomingAppointmentsSection: View {
    let appointments: [Appointment]
    let doctors: [Doctor]
    let onDelete: (UUID) -> Void
    
    var upcomingAppointments: [Appointment] {
        appointments.filter { !$0.isCompleted && $0.date >= Calendar.current.startOfDay(for: Date()) }
            .sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if upcomingAppointments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("No Upcoming Appointments")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Schedule your next doctor visit")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
            } else {
                ForEach(upcomingAppointments) { appt in
                    AppointmentCard(
                        appointment: appt,
                        doctor: doctors.first { $0.id == appt.doctorId },
                        onDelete: { onDelete(appt.id) }
                    )
                }
            }
        }
    }
}

// MARK: - Past Appointments Section
struct PastAppointmentsSection: View {
    let appointments: [Appointment]
    let doctors: [Doctor]
    
    var pastAppointments: [Appointment] {
        appointments.filter { $0.isCompleted || $0.date < Calendar.current.startOfDay(for: Date()) }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if pastAppointments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("No Past Appointments")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
            } else {
                ForEach(pastAppointments) { appt in
                    PastAppointmentCard(
                        appointment: appt,
                        doctor: doctors.first { $0.id == appt.doctorId }
                    )
                }
            }
        }
    }
}

// MARK: - Appointment Card
struct AppointmentCard: View {
    let appointment: Appointment
    let doctor: Doctor?
    let onDelete: () -> Void
    
    @State private var showDeleteConfirm = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(appointment.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                        Text(formatAppointmentDateTime())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if let doctor = doctor {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.70))
                            Text(doctor.name)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if !appointment.location.isEmpty {
                        HStack(spacing: 12) {
                            Image(systemName: "location.circle")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                            Text(appointment.location)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: { showDeleteConfirm = true }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            if !appointment.notes.isEmpty {
                Text(appointment.notes)
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
        .alert("Delete Appointment?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This will remove '\(appointment.title)' and its reminders.")
        }
    }
    
    private func formatAppointmentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let dateStr = dateFormatter.string(from: appointment.date)
        let timeStr = timeFormatter.string(from: appointment.time)
        return "\(dateStr) at \(timeStr)"
    }
}

// MARK: - Past Appointment Card
struct PastAppointmentCard: View {
    let appointment: Appointment
    let doctor: Doctor?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appointment.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(formatAppointmentDateTime())
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if let doctor = doctor {
                        Text(doctor.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
            }
            
            if !appointment.notes.isEmpty {
                Text(appointment.notes)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .italic()
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
    
    private func formatAppointmentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let dateStr = dateFormatter.string(from: appointment.date)
        let timeStr = timeFormatter.string(from: appointment.time)
        return "\(dateStr) at \(timeStr)"
    }
}

// MARK: - Add Appointment Sheet
struct AddAppointmentSheet: View {
    @Binding var isPresented: Bool
    let doctors: [Doctor]
    let onSave: (Appointment) -> Void
    
    @State private var title = ""
    @State private var appointmentDate = Date()
    @State private var selectedHour = 14
    @State private var selectedMinute = 0
    @State private var selectedDoctorId: UUID?
    @State private var location = ""
    @State private var notes = ""
    @State private var selectedReminders: [AppointmentReminderTime] = [.oneDay, .oneHour]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appointment Details") {
                    TextField("Appointment Title", text: $title)
                    
                    Picker("Doctor", selection: $selectedDoctorId) {
                        Text("None").tag(UUID?.none)
                        ForEach(doctors) { doctor in
                            Text(doctor.name).tag(Optional(doctor.id))
                        }
                    }
                    
                    TextField("Location", text: $location)
                    TextField("Notes (optional)", text: $notes)
                }
                
                Section("Date & Time") {
                    DatePicker("Date", selection: $appointmentDate, displayedComponents: .date)
                    
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
                
                Section("Reminders") {
                    Toggle("15 minutes before", isOn: Binding(
                        get: { selectedReminders.contains(.fifteenMinutes) },
                        set: { isSelected in
                            if isSelected {
                                selectedReminders.append(.fifteenMinutes)
                            } else {
                                selectedReminders.removeAll { $0 == .fifteenMinutes }
                            }
                        }
                    ))
                    
                    Toggle("1 hour before", isOn: Binding(
                        get: { selectedReminders.contains(.oneHour) },
                        set: { isSelected in
                            if isSelected {
                                selectedReminders.append(.oneHour)
                            } else {
                                selectedReminders.removeAll { $0 == .oneHour }
                            }
                        }
                    ))
                    
                    Toggle("1 day before", isOn: Binding(
                        get: { selectedReminders.contains(.oneDay) },
                        set: { isSelected in
                            if isSelected {
                                selectedReminders.append(.oneDay)
                            } else {
                                selectedReminders.removeAll { $0 == .oneDay }
                            }
                        }
                    ))
                }
            }
            .navigationTitle("Add Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAppointment()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveAppointment() {
        let appointmentTime = Calendar.current.date(
            bySettingHour: selectedHour,
            minute: selectedMinute,
            second: 0,
            of: Date()
        ) ?? Date()
        
        let appointment = Appointment(
            title: title,
            date: appointmentDate,
            time: appointmentTime,
            doctorId: selectedDoctorId,
            location: location,
            notes: notes,
            reminderTimes: selectedReminders
        )
        
        onSave(appointment)
        isPresented = false
    }
}

#Preview {
    AppointmentTrackerView()
}
