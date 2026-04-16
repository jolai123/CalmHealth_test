//
//  NotificationManager.swift
//  HealthKitNoModify
//
//  Created on 10/4/2026.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Request Permissions
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
                let badgeCount = UIApplication.shared.applicationIconBadgeNumber
                print("✅ Notification permission \(granted ? "granted" : "denied")")
            }
        }
    }
    
    // MARK: - Schedule Medication Reminder
    func scheduleMedicationReminder(
        medication: MedicationReminder,
        reminderTime: Date
    ) {
        let content = UNMutableNotificationContent()
        content.title = "💊 Medication Reminder"
        content.body = "Time to take \(medication.name) (\(medication.dosage))"
        content.sound = .default
        let currentBadge = DispatchQueue.main.sync { UIApplication.shared.applicationIconBadgeNumber }
        content.badge = NSNumber(value: currentBadge + 1)
        
        // Add custom data
        content.userInfo = [
            "medicationId": medication.id.uuidString,
            "medicationName": medication.name
        ]
        
        // Create time components from reminderTime
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        dateComponents.timeZone = TimeZone.current
        
        // For repeating reminders based on frequency
        if medication.frequency == .daily {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "med_\(medication.id)_daily",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Medication notification error: \(error.localizedDescription)")
                } else {
                    print("✅ Scheduled daily reminder for \(medication.name) at \(dateComponents.hour ?? 0):\(String(format: "%02d", dateComponents.minute ?? 0))")
                }
            }
        } else if medication.frequency == .weekly {
            var weeklyComponents = dateComponents
            weeklyComponents.weekday = Calendar.current.component(.weekday, from: reminderTime)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "med_\(medication.id)_weekly",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Medication notification error: \(error.localizedDescription)")
                } else {
                    print("✅ Scheduled weekly reminder for \(medication.name)")
                }
            }
        } else if medication.frequency == .asNeeded {
            // For one-time reminders, schedule next day
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
            let request = UNNotificationRequest(
                identifier: "med_\(medication.id)_asneeded",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Medication notification error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Schedule Appointment Reminders
    func scheduleAppointmentReminders(
        appointment: Appointment
    ) {
        for reminderTime in appointment.reminderTimes {
            let content = UNMutableNotificationContent()
            content.title = "📅 Appointment Reminder"
            content.body = appointment.title + (appointment.location.isEmpty ? "" : " at \(appointment.location)")
            content.sound = .default
            let currentBadge = DispatchQueue.main.sync { UIApplication.shared.applicationIconBadgeNumber }
            content.badge = NSNumber(value: currentBadge + 1)
            
            content.userInfo = [
                "appointmentId": appointment.id.uuidString,
                "appointmentTitle": appointment.title
            ]
            
            // Calculate reminder time
            let appointmentDateTime = Calendar.current.date(
                bySettingHour: Calendar.current.component(.hour, from: appointment.time),
                minute: Calendar.current.component(.minute, from: appointment.time),
                second: 0,
                of: appointment.date
            ) ?? appointment.date
            
            let reminderDateTime = appointmentDateTime.addingTimeInterval(-reminderTime.timeInterval)
            
            // Only schedule if reminder is in the future
            if reminderDateTime > Date() {
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDateTime),
                    repeats: false
                )
                
                let request = UNNotificationRequest(
                    identifier: "appt_\(appointment.id)_\(reminderTime.rawValue)",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Appointment notification error: \(error.localizedDescription)")
                    } else {
                        print("✅ Scheduled appointment reminder: \(appointment.title) (\(reminderTime.rawValue) before)")
                    }
                }
            }
        }
    }
    
    // MARK: - Cancel Reminder
    func cancelReminder(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("🗑️ Cancelled notification: \(identifier)")
    }
    
    func cancelAllRemindersForMedication(medicationId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [
                "med_\(medicationId)_daily",
                "med_\(medicationId)_weekly",
                "med_\(medicationId)_asneeded"
            ]
        )
        print("🗑️ Cancelled all reminders for medication: \(medicationId)")
    }
    
    func cancelAllRemindersForAppointment(appointmentId: UUID) {
        let identifiers = [
            "appt_\(appointmentId)_15m",
            "appt_\(appointmentId)_1h",
            "appt_\(appointmentId)_1d",
            "appt_\(appointmentId)_2d"
        ]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("🗑️ Cancelled all reminders for appointment: \(appointmentId)")
    }
    
    // MARK: - Get Pending Notifications
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
    // MARK: - Check Missed Medications
    func checkMissedMedications(
        medications: [MedicationReminder],
        logs: [MedicationLog]
    ) -> [MedicationReminder] {
        var missedMeds: [MedicationReminder] = []
        let today = Calendar.current.startOfDay(for: Date())
        
        for medication in medications {
            guard medication.isActive else { continue }
            guard medication.startDate <= today else { continue }
            if let endDate = medication.endDate, endDate < today { continue }
            
            // Check if there's a log entry for today
            let todayLog = logs.first { log in
                log.medicationId == medication.id &&
                Calendar.current.isDateInToday(log.date) &&
                log.status == .taken
            }
            
            if todayLog == nil {
                missedMeds.append(medication)
            }
        }
        
        return missedMeds
    }
}
