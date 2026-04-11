//
//  OximeterView.swift
//  VibeCoding1
//
//  Created by chapman on 1/9/2025.
//

import SwiftUI
import iREdFramework

struct OximeterView: View {
    @StateObject var ble = iREdBluetooth.shared
    @State private var isSaving = false
    @State private var saveMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Oximeter")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.70))
                
                // Connection Status
                VStack(spacing: 8) {
                    HStack {
                        Circle()
                            .fill(connectionStatusColor)
                            .frame(width: 10, height: 10)
                        Text("Connection Status")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    HStack {
                        Text(connectionStatusText)
                            .fontWeight(.medium)
                            .foregroundColor(connectionStatusColor)
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Measurement Data
                VStack(spacing: 12) {
                    Text("Measurement Data")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    // SPO2 Card
                    VStack(spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Oxygen Level (SPO2)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(spo2Text)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                            }
                            Spacer()
                            Image(systemName: "lungs.fill")
                                .font(.title)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.8))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    HStack(spacing: 12) {
                        // Heart Rate Card
                        VStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Heart Rate")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(heartRateText)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        // PI Card
                        VStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Perfusion Index")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(piText)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    // Battery Level
                    if let battery = ble.iredDeviceData.oximeterData.data.battery {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Battery Level")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(battery)%")
                                    .fontWeight(.semibold)
                                    .foregroundColor(batteryColor(battery))
                            }
                            ProgressView(value: Double(battery) / 100)
                                .tint(batteryColor(battery))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Control Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        ble.startPairing(to: .oximeter)
                    }) {
                        HStack {
                            Image(systemName: "link")
                            Text("Pairing")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 1.0, green: 0.5, blue: 0.2))
                        .cornerRadius(10)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            ble.connect(from: .oximeter)
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Connect")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            ble.disconnect(from: .oximeter)
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("Disconnect")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 0.9, green: 0.3, blue: 0.3))
                            .cornerRadius(10)
                        }
                    }
                    
                    // Save Data Button
                    Button(action: {
                        saveOximeterData()
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
                        .background(Color(red: 0.2, green: 0.7, blue: 0.9))
                        .cornerRadius(10)
                    }
                    
                    // View Charts Button
                    NavigationLink(destination: OximeterDataChartView()) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("View Data Charts")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }

    
    // MARK: - Computed Properties
    
    private var hasValidData: Bool {
        return ble.iredDeviceData.oximeterData.data.spo2 != nil &&
               ble.iredDeviceData.oximeterData.data.pulse != nil &&
               ble.iredDeviceData.oximeterData.data.pi != nil
    }
    
    private var connectionStatusColor: Color {
        if ble.iredDeviceData.oximeterData.state.isConnected {
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        } else if ble.iredDeviceData.oximeterData.state.isPairing {
            return Color(red: 1.0, green: 0.5, blue: 0.2)
        } else if ble.iredDeviceData.oximeterData.state.isPaired {
            return Color(red: 0.2, green: 0.7, blue: 0.9)
        } else {
            return .gray
        }
    }
    
    private var connectionStatusText: String {
        if ble.iredDeviceData.oximeterData.state.isConnected {
            return "Connected"
        } else if ble.iredDeviceData.oximeterData.state.isPairing {
            return "Pairing..."
        } else if ble.iredDeviceData.oximeterData.state.isPaired {
            return "Paired (Disconnected)"
        } else {
            return "Not Paired"
        }
    }
    
    private var spo2Text: String {
        if let spo2 = ble.iredDeviceData.oximeterData.data.spo2 {
            return "\(spo2)%"
        } else {
            return "--"
        }
    }
    
    private var heartRateText: String {
        if let pulse = ble.iredDeviceData.oximeterData.data.pulse {
            return "\(pulse) BPM"
        } else {
            return "--"
        }
    }
    
    private var piText: String {
        if let pi = ble.iredDeviceData.oximeterData.data.pi {
            return String(format: "%.2f", pi)
        } else {
            return "--"
        }
    }
    
    private func batteryColor(_ level: Int) -> Color {
        if level > 50 {
            return .green
        } else if level > 20 {
            return .orange
        } else {
            return .red
        }
    }
    
    // MARK: - Data Saving Functions
    
    private func saveOximeterData() {
        guard let spo2 = ble.iredDeviceData.oximeterData.data.spo2,
              let heartRate = ble.iredDeviceData.oximeterData.data.pulse,
              let pi = ble.iredDeviceData.oximeterData.data.pi else {
            saveMessage = "Invalid data. Please ensure all measurements are available."
            showAlert = true
            return
        }
        
        isSaving = true
        
        // Use custom date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        let sheetName = "oximeter"
        
        var urlComponents = URLComponents(string: Setting.shared.appScriptUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "sheetId", value: Setting.shared.sheetId),
            URLQueryItem(name: "sheetName", value: sheetName),
            URLQueryItem(name: "datetime", value: timestamp),
            URLQueryItem(name: "spo2", value: String(spo2)),
            URLQueryItem(name: "heart_rate", value: String(heartRate)),
            URLQueryItem(name: "pi", value: String(format: "%.2f", pi)),
            URLQueryItem(name: "user", value: Setting.shared.username)
        ]
        
        guard let url = urlComponents.url else {
            isSaving = false
            saveMessage = "Failed to create request URL."
            showAlert = true
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isSaving = false
                
                if let error = error {
                    saveMessage = "Failed to save data: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        saveMessage = "Oximeter data saved successfully!"
                    } else {
                        saveMessage = "Failed to save data. Server responded with status code: \(httpResponse.statusCode)"
                    }
                } else {
                    saveMessage = "Unexpected response from server."
                }
                
                showAlert = true
            }
        }
        
        task.resume()
    }
}

#Preview {
    NavigationView {
        OximeterView()
    }
}
