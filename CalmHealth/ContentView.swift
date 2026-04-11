//
//  ContentView.swift
//  VibeCoding1
//
//  Created by chapman on 15/8/2025.
//

import SwiftUI
import UserNotifications

enum NavigationDestination: String, CaseIterable {
    case thermometer = "Thermometer"
    case oximeter = "Oximeter"
    case bloodPressureMeter = "Blood Pressure Meter"
}

struct ContentView: View {
    @State private var navigationDestination: NavigationDestination?
    @State private var navigationPath = [NavigationDestination]()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                // Home Tab
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    VStack(alignment: .center, spacing: 30) {
                        VStack(spacing: 10) {
                            Text("Calm Health")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                            Text("Monitor Your Wellness")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        VStack(spacing: 15) {
                            // Thermometer Button
                            NavigationLink(value: NavigationDestination.thermometer) {
                                HStack {
                                    Image(systemName: "thermometer")
                                        .font(.title2)
                                    Text("Thermometer")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(20)
                                .shadow(color: Color(red: 0.4, green: 0.65, blue: 0.65).opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            // Oximeter Button
                            NavigationLink(value: NavigationDestination.oximeter) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .font(.title2)
                                    Text("Oximeter")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.70))
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(20)
                                .shadow(color: Color(red: 0.65, green: 0.55, blue: 0.70).opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            // Blood Pressure Button
                            NavigationLink(value: NavigationDestination.bloodPressureMeter) {
                                HStack {
                                    Image(systemName: "waveform.circle")
                                        .font(.title2)
                                    Text("Blood Pressure Meter")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(20)
                                .shadow(color: Color(red: 0.70, green: 0.65, blue: 0.55).opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                // Mood Tracker Tab
                MoodTrackerView()
                    .tabItem {
                        Image(systemName: "face.smiling")
                        Text("Mood")
                    }
                    .tag(1)
                // Dashboard Tab
                DashboardView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Dashboard")
                    }
                    .tag(2)
                // History Tab
                HistoryView()
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
                    .tag(3)
                // Insights Tab
                InsightsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Insights")
                    }
                    .tag(4)
                
                // Medications & Appointments Tab
                MedicationAppointmentTabView()
                    .tabItem {
                        Image(systemName: "pill.fill")
                        Text("Health Plan")
                    }
                    .tag(5)
                
                // ChatBot Tab
                ChatBotView()
                    .tabItem {
                        Image(systemName: "bubble.left")
                        Text("Assistant")
                    }
                    .tag(6)
            }
            .accentColor(Color(red: 0.4, green: 0.65, blue: 0.65))
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .thermometer:
                    ThermometerView()
                case .oximeter:
                    OximeterView()
                case .bloodPressureMeter:
                    BloodPressureMeterView()
                }
            }
            .onAppear {
                // Request notification permissions
                NotificationManager.shared.requestNotificationPermission { granted in
                    print("Notification permission: \(granted)")
                }
            }
        }
    }
}

struct HealthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

// MARK: - Medication & Appointment Combined Tab
struct MedicationAppointmentTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Tab selector
                HStack(spacing: 12) {
                    Button(action: { selectedTab = 0 }) {
                        HStack(spacing: 6) {
                            Image(systemName: "pill.fill")
                            Text("Medications")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedTab == 0 ? .white : Color(red: 0.4, green: 0.65, blue: 0.65))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedTab == 0 ?
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
                    
                    Button(action: { selectedTab = 1 }) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                            Text("Appointments")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedTab == 1 ? .white : Color(red: 0.4, green: 0.65, blue: 0.65))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedTab == 1 ?
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
                .padding()
                
                // Tab content
                if selectedTab == 0 {
                    MedicationTrackerView()
                } else {
                    AppointmentTrackerView()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
