//
//  DashboardView.swift
//  HealthKitNoModify
//
//  Created by Copilot on 9/4/2026.
//

import SwiftUI
import iREdFramework

struct DashboardView: View {
    @StateObject var ble = iREdBluetooth.shared
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Health Dashboard")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                        Text("Your Daily Health Summary")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Last Updated
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                            Text("Last Updated")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(getCurrentTime())
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Thermometer Card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "thermometer.sun.fill")
                                        .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                                    Text("Temperature")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                                
                                if let temperature = ble.iredDeviceData.thermometerData.data.temperature {
                                    Text("\(String(format: "%.1f", temperature))°C")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                                } else {
                                    Text("No Data")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                
                                if let mode = ble.iredDeviceData.thermometerData.data.modeDescription {
                                    Text(mode)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 4) {
                                Circle()
                                    .fill(ble.iredDeviceData.thermometerData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                                    .frame(width: 12, height: 12)
                                Text(ble.iredDeviceData.thermometerData.state.isConnected ? "Connected" : "Offline")
                                    .font(.caption2)
                                    .foregroundColor(ble.iredDeviceData.thermometerData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                    .padding(.horizontal)
                    
                    // Oximeter Card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.9))
                                    Text("Oxygen & Heart Rate")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("SPO2")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        if let spo2 = ble.iredDeviceData.oximeterData.data.spo2 {
                                            Text("\(spo2)%")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(Color(red: 0.1, green: 0.7, blue: 0.5))
                                        } else {
                                            Text("--")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("BPM")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        if let pulse = ble.iredDeviceData.oximeterData.data.pulse {
                                            Text("\(pulse)")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.3))
                                        } else {
                                            Text("--")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 4) {
                                Circle()
                                    .fill(ble.iredDeviceData.oximeterData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                                    .frame(width: 12, height: 12)
                                Text(ble.iredDeviceData.oximeterData.state.isConnected ? "Connected" : "Offline")
                                    .font(.caption2)
                                    .foregroundColor(ble.iredDeviceData.oximeterData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                    .padding(.horizontal)
                    
                    // Blood Pressure Card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "waveform.circle.fill")
                                        .foregroundColor(Color(red: 0.8, green: 0.2, blue: 0.2))
                                    Text("Blood Pressure")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Systolic")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        if let systolic = ble.iredDeviceData.sphygmometerData.data.systolic {
                                            Text("\(systolic)")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.3))
                                        } else {
                                            Text("--")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Diastolic")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        if let diastolic = ble.iredDeviceData.sphygmometerData.data.diastolic {
                                            Text("\(diastolic)")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(Color(red: 0.8, green: 0.2, blue: 0.2))
                                        } else {
                                            Text("--")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 4) {
                                Circle()
                                    .fill(ble.iredDeviceData.sphygmometerData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                                    .frame(width: 12, height: 12)
                                Text(ble.iredDeviceData.sphygmometerData.state.isConnected ? "Connected" : "Offline")
                                    .font(.caption2)
                                    .foregroundColor(ble.iredDeviceData.sphygmometerData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                    .padding(.horizontal)
                    
                    // Health Tips
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.9, blue: 0.2))
                            Text("Health Tips")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        VStack(spacing: 8) {
                            Text("Monitor your readings regularly for better health insights.")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Stay hydrated and maintain a consistent sleep schedule.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(red: 1.0, green: 0.9, blue: 0.2).opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

#Preview {
    DashboardView()
}
