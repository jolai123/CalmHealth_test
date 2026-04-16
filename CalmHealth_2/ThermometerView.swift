//
//  ThermometerView.swift
//  VibeCoding1
//
//  Created by chapman on 1/9/2025.
//

import SwiftUI
import iREdFramework

struct ThermometerView: View {
    @StateObject var ble = iREdBluetooth.shared
    @State private var isSaving = false
    @State private var saveMessage = ""
    @State private var showAlert = false
    @State private var showChartView = false

    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Thermometer")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                
                // Temperature Display
                VStack(spacing: 15) {
                    VStack(spacing: 10) {
                        Text("Temperature Reading")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        if let temperature = ble.iredDeviceData.thermometerData.data.temperature {
                            Text("\(temperature, specifier: "%.1f")°C")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                        } else {
                            Text("--.-°C")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    
                    // Device Mode and Battery Info
                    VStack(spacing: 8) {
                        if let mode = ble.iredDeviceData.thermometerData.data.modeDescription {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                                Text("Mode: \(mode)")
                                Spacer()
                            }
                        }
                        
                        if let battery = ble.iredDeviceData.thermometerData.data.battery {
                            HStack {
                                Image(systemName: "battery.100")
                                    .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
                                Text("Battery: \(battery)")
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Connection Status
                VStack(spacing: 8) {
                    HStack {
                        Circle()
                            .fill(ble.iredDeviceData.thermometerData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                            .frame(width: 10, height: 10)
                        Text(ble.iredDeviceData.thermometerData.state.isConnected ? "Connected" : "Disconnected")
                            .foregroundColor(ble.iredDeviceData.thermometerData.state.isConnected ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.gray)
                        Spacer()
                    }
                    
                    if ble.iredDeviceData.thermometerData.state.isPairing {
                        Text("Pairing...")
                            .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                    } else if ble.iredDeviceData.thermometerData.state.isPaired {
                        Text("Paired")
                            .foregroundColor(Color(red: 0.40, green: 0.65, blue: 0.65))
                    } else {
                        Text("Not Paired")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Control Buttons
                VStack(spacing: 12) {
                    // Pairing Button
                    Button(action: {
                        if ble.iredDeviceData.thermometerData.state.isPairing {
                            ble.stopPairing()
                        } else {
                            ble.startPairing(to: .thermometer)
                        }
                    }) {
                        HStack {
                            Text(ble.iredDeviceData.thermometerData.state.isPairing ? "Stop Pairing" : "Start Pairing")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.70, green: 0.65, blue: 0.55).opacity(0.8), Color(red: 0.70, green: 0.65, blue: 0.55).opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                    }
                    
                    // Connect Button
                    Button(action: {
                        if ble.iredDeviceData.thermometerData.state.isConnected {
                            ble.disconnect(from: .thermometer)
                        } else {
                            ble.connect(from: .thermometer)
                        }
                    }) {
                        HStack {
                            Image(systemName: ble.iredDeviceData.thermometerData.state.isConnected ? "link.badge.plus" : "link")
                            Text(ble.iredDeviceData.thermometerData.state.isConnected ? "Disconnect" : "Connect")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                    }
                    
                    // Save Data Button
                    Button(action: {
                        saveThermometerData()
                    }) {
                        HStack {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "square.and.arrow.up")
                            }
                            Text(isSaving ? "Saving..." : "Save Data")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                    }
                    
                    NavigationLink(destination: ThermometerDataChartView()) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("View Chart")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.2, green: 0.5, blue: 0.9))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    // Function to save thermometer data to Google Sheets
    private func saveThermometerData() {
        guard let temperature = ble.iredDeviceData.thermometerData.data.temperature else {
            saveMessage = "No temperature data available"
            showAlert = true
            return
        }
        
        isSaving = true
        
        // Use custom date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        // Get mode description or use default
        let mode = ble.iredDeviceData.thermometerData.data.modeDescription ?? "Adult forehead"
        
        // Construct the API URL (aligned with data chart + tests)
        let sheetName = "thermometer"
        
        var urlComponents = URLComponents(string: Setting.shared.appScriptUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "sheetId", value: Setting.shared.sheetId),
            URLQueryItem(name: "sheetName", value: sheetName),
            URLQueryItem(name: "datetime", value: timestamp),
            URLQueryItem(name: "mode", value: mode),
            URLQueryItem(name: "temperature", value: String(format: "%.1f", temperature)),
            URLQueryItem(name: "user", value: Setting.shared.username)
        ]
        
        guard let url = urlComponents.url else {
            saveMessage = "Failed to construct URL"
            showAlert = true
            isSaving = false
            return
        }
        
        // Make the HTTP GET request
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSaving = false
                
                if let error = error {
                    saveMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        saveMessage = "Data saved successfully!\nTemperature: \(String(format: "%.1f", temperature))°C\nMode: \(mode)\nTime: \(timestamp)"
                    } else {
                        saveMessage = "Server returned status code: \(httpResponse.statusCode)"
                    }
                } else {
                    saveMessage = "Invalid response received"
                }
                
                showAlert = true
            }
        }.resume()
    }

}

#Preview {
    NavigationView {
        ThermometerView()
    }
}
