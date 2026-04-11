//
//  BloodPressureMeterView.swift
//  VibeCoding1
//
//  Created by chapman on 1/9/2025.
//

import SwiftUI
import iREdFramework

struct BloodPressureMeterView: View {
    @StateObject var ble = iREdBluetooth.shared
    @State private var isSaving = false
    @State private var saveMessage = ""
    @State private var showSaveAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Blood Pressure Meter")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.70, green: 0.65, blue: 0.55))
                
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
                    Text("Blood Pressure Reading")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    // Systolic Card
                    VStack(spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Systolic")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(systolicText)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                            }
                            Spacer()
                            Image(systemName: "heart.fill")
                                .font(.title)
                                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    HStack(spacing: 12) {
                        // Diastolic Card
                        VStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Diastolic")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(diastolicText)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        // Pulse Card
                        VStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Pulse")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(pulseText)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    // Measurement Status
                    if ble.iredDeviceData.sphygmometerData.state.isConnected {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Measurement Status")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(measurementStatusText)
                                    .fontWeight(.semibold)
                                    .foregroundColor(measurementStatusColor)
                            }
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
                        ble.startPairing(to: .sphygmometer)
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
                            ble.connect(from: .sphygmometer)
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
                            ble.disconnect(from: .sphygmometer)
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
                        saveBloodPressureData()
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
                        .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                        .cornerRadius(10)
                    }
                    
                    // View Chart Button
                    NavigationLink(destination: BloodPressureDataChartView()) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("View Chart")
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
    
    // MARK: - Helper Methods
    
    private func saveBloodPressureData() {
        guard let systolic = ble.iredDeviceData.sphygmometerData.data.systolic,
              let diastolic = ble.iredDeviceData.sphygmometerData.data.diastolic,
              let pulseRate = ble.iredDeviceData.sphygmometerData.data.pulse else {
            saveMessage = "No valid data to save"
            showSaveAlert = true
            return
        }
        
        isSaving = true
        
        // Use custom date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        
        // Construct the API URL
        let sheetName = "blood_pressure_meter"
        
        // 使用字符串拼接 URL，并携带 user 参数
        let urlString = "\(Setting.shared.appScriptUrl)?sheetId=\(Setting.shared.sheetId)&sheetName=\(sheetName)&datetime=\(timestamp)&diastolic=\(diastolic)&systolic=\(systolic)&pulse_rate=\(pulseRate)&user=\(Setting.shared.username)"
        
        guard let url = URL(string: urlString) else {
            isSaving = false
            saveMessage = "Failed to create API URL"
            showSaveAlert = true
            return
        }
        
        // Make the API request
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isSaving = false
                
                if let error = error {
                    self.saveMessage = "Error saving data: \(error.localizedDescription)"
                    self.showSaveAlert = true
                    return
                }
                
                guard let data = data else {
                    self.saveMessage = "No response data received from server"
                    self.showSaveAlert = true
                    return
                }
                
                // 优先按统一的 {code, message, data} 结构解析
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let code = jsonObject["code"] as? Int ?? 0
                        let message = jsonObject["message"] as? String
                        
                        if code == 200 {
                            self.saveMessage = message ?? "Blood pressure data saved successfully!"
                        } else {
                            self.saveMessage = message ?? "Failed to save data. Code: \(code)"
                        }
                    } else {
                        // fallback to HTTP status handling
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 200 {
                                self.saveMessage = "Blood pressure data saved successfully!"
                            } else {
                                self.saveMessage = "Failed to save data. Status code: \(httpResponse.statusCode)"
                            }
                        } else {
                            self.saveMessage = "Unknown response received"
                        }
                    }
                } catch {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            self.saveMessage = "Blood pressure data saved successfully!"
                        } else {
                            self.saveMessage = "Failed to save data. Status code: \(httpResponse.statusCode)"
                        }
                    } else {
                        self.saveMessage = "Unknown response received"
                    }
                }
                
                self.showSaveAlert = true
            }
        }.resume()
    }
    
    // MARK: - Computed Properties
    
    private var hasValidData: Bool {
        return ble.iredDeviceData.sphygmometerData.data.systolic != nil &&
        ble.iredDeviceData.sphygmometerData.data.diastolic != nil &&
        ble.iredDeviceData.sphygmometerData.data.pulse != nil
    }
    
    // MARK: - Computed Properties
    
    private var connectionStatusColor: Color {
        if ble.iredDeviceData.sphygmometerData.state.isConnected {
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        } else if ble.iredDeviceData.sphygmometerData.state.isPairing {
            return Color(red: 1.0, green: 0.5, blue: 0.2)
        } else if ble.iredDeviceData.sphygmometerData.state.isPaired {
            return Color(red: 0.2, green: 0.7, blue: 0.9)
        } else {
            return .gray
        }
    }
    
    private var connectionStatusText: String {
        if ble.iredDeviceData.sphygmometerData.state.isConnected {
            return "Connected"
        } else if ble.iredDeviceData.sphygmometerData.state.isPairing {
            return "Pairing..."
        } else if ble.iredDeviceData.sphygmometerData.state.isPaired {
            return "Paired (Disconnected)"
        } else {
            return "Not Paired"
        }
    }
    
    private var systolicText: String {
        if let systolic = ble.iredDeviceData.sphygmometerData.data.systolic {
            return "\(systolic)"
        } else {
            return "--"
        }
    }
    
    private var diastolicText: String {
        if let diastolic = ble.iredDeviceData.sphygmometerData.data.diastolic {
            return "\(diastolic)"
        } else {
            return "--"
        }
    }
    
    private var pulseText: String {
        if let pulse = ble.iredDeviceData.sphygmometerData.data.pulse {
            return "\(pulse) BPM"
        } else {
            return "--"
        }
    }
    
    private var pressureText: String {
        if let pressure = ble.iredDeviceData.sphygmometerData.data.pressure {
            return "\(pressure) mmHg"
        } else {
            return "--"
        }
    }
    
    private var measurementStatusText: String {
        if ble.iredDeviceData.sphygmometerData.state.isMeasurementCompleted {
            return "Measurement Complete"
        } else if ble.iredDeviceData.sphygmometerData.state.isConnected {
            return "Ready to Measure"
        } else {
            return "Not Connected"
        }
    }
    
    private var measurementStatusColor: Color {
        if ble.iredDeviceData.sphygmometerData.state.isMeasurementCompleted {
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        } else if ble.iredDeviceData.sphygmometerData.state.isConnected {
            return Color(red: 0.2, green: 0.7, blue: 0.9)
        } else {
            return .gray
        }
    }
}

#Preview {
    NavigationView {
        BloodPressureMeterView()
    }
}
