//
//  Medication.swift
//  HealthKitNoModify
//
//  Created on 10/4/2026.
//

import Foundation

// MARK: - Frequency Enum
enum MedicationFrequency: String, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case custom = "custom"
    case asNeeded = "asNeeded"
}

// MARK: - Medication Reminder
struct MedicationReminder: Identifiable, Codable {
    let id: UUID
    var name: String
    var dosage: String
    var frequency: MedicationFrequency
    var reminderTimes: [Date] // Array of times (store as Date with time components)
    var startDate: Date
    var endDate: Date?
    var notes: String
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        dosage: String,
        frequency: MedicationFrequency,
        reminderTimes: [Date] = [],
        startDate: Date = Date(),
        endDate: Date? = nil,
        notes: String = "",
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.reminderTimes = reminderTimes
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.isActive = isActive
    }
}

// MARK: - Medication Log Entry
struct MedicationLog: Identifiable, Codable {
    let id: UUID
    let medicationId: UUID
    let date: Date
    var timeTaken: Date?
    var status: MedicationStatus
    var notes: String
    
    init(
        id: UUID = UUID(),
        medicationId: UUID,
        date: Date = Date(),
        timeTaken: Date? = nil,
        status: MedicationStatus = .pending,
        notes: String = ""
    ) {
        self.id = id
        self.medicationId = medicationId
        self.date = date
        self.timeTaken = timeTaken
        self.status = status
        self.notes = notes
    }
}

// MARK: - Medication Status Enum
enum MedicationStatus: String, Codable {
    case pending = "pending"
    case taken = "taken"
    case missed = "missed"
    case skipped = "skipped"
}

// MARK: - Doctor
struct Doctor: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var phone: String
    var clinic: String
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        phone: String = "",
        clinic: String = ""
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.clinic = clinic
    }
}

// MARK: - Appointment
struct Appointment: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var time: Date
    var doctorId: UUID?
    var location: String
    var notes: String
    var reminderTimes: [AppointmentReminderTime]
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date = Date(),
        time: Date = Date(),
        doctorId: UUID? = nil,
        location: String = "",
        notes: String = "",
        reminderTimes: [AppointmentReminderTime] = [.oneDay, .oneHour],
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.time = time
        self.doctorId = doctorId
        self.location = location
        self.notes = notes
        self.reminderTimes = reminderTimes
        self.isCompleted = isCompleted
    }
}

// MARK: - Appointment Reminder Time
enum AppointmentReminderTime: String, Codable {
    case fifteenMinutes = "15m"
    case oneHour = "1h"
    case oneDay = "1d"
    case twoDays = "2d"
    
    var timeInterval: TimeInterval {
        switch self {
        case .fifteenMinutes:
            return 15 * 60
        case .oneHour:
            return 60 * 60
        case .oneDay:
            return 24 * 60 * 60
        case .twoDays:
            return 48 * 60 * 60
        }
    }
}

// MARK: - Caregiver Alert
struct CaregiverAlert: Identifiable, Codable {
    let id: UUID
    let medicationId: UUID?
    let date: Date
    var alertType: CaregiverAlertType
    var message: String
    var isRead: Bool
    
    init(
        id: UUID = UUID(),
        medicationId: UUID? = nil,
        date: Date = Date(),
        alertType: CaregiverAlertType,
        message: String,
        isRead: Bool = false
    ) {
        self.id = id
        self.medicationId = medicationId
        self.date = date
        self.alertType = alertType
        self.message = message
        self.isRead = isRead
    }
}

// MARK: - Caregiver Alert Type
enum CaregiverAlertType: String, Codable {
    case missedMedication = "missed"
    case abnormalVital = "vital"
    case appointmentReminder = "appointment"
    case other = "other"
}
