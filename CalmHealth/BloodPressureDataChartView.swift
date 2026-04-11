//
//  BloodPressureDataChartView.swift
//  VibeCoding1
//
//  Created by chapman on 1/9/2025.
//

import SwiftUI
import Charts

struct BloodPressureDataChartView: View {
    @State private var bloodPressureData: [BloodPressureReading] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                Text("Loading blood pressure data...")
            } else if bloodPressureData.isEmpty {
                Text("No Data Available")
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Blood Pressure Chart
                        bloodPressureChartView

                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Blood Pressure History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchBloodPressureData()
        }
    }

    // MARK: - Blood Pressure Chart View
    
    private var bloodPressureChartView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Blood Pressure Trend")
                .font(.headline)
            
            Chart(bloodPressureData) { reading in
                LineMark(
                    x: .value("Time", reading.time),
                    y: .value("Value", reading.systolic)
                )
                .foregroundStyle(by: .value("Type", "Systolic"))
                .symbol(.circle)
                
                LineMark(
                    x: .value("Time", reading.time),
                    y: .value("Value", reading.diastolic)
                )
                .foregroundStyle(by: .value("Type", "Diastolic"))
                .symbol(.square)
                
                LineMark(
                    x: .value("Time", reading.time),
                    y: .value("Value", reading.pulseRate)
                )
                .foregroundStyle(by: .value("Type", "Pulse Rate"))
                .symbol(.triangle)
            }
            .frame(height: 200)
            .chartForegroundStyleScale([
                "Systolic": Color(red: 0.2, green: 0.5, blue: 0.9),
                "Diastolic": Color(red: 0.3, green: 0.6, blue: 0.95),
                "Pulse Rate": Color(red: 0.1, green: 0.4, blue: 0.8)
            ])
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .chartLegend(position: .bottom)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    

    
    // MARK: - Helper Methods
    
    private func fetchBloodPressureData() {
        isLoading = true
        let sheetName = "blood_pressure_meter"
        
        // 直接使用字符串拼接 URL
        let urlString = "\(Setting.shared.appScriptUrl)?sheetId=\(Setting.shared.sheetId)&sheetName=\(sheetName)&user=\(Setting.shared.username)"
        guard let url = URL(string: urlString) else {
            isLoading = false
            print("Failed to create API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Invalid data format received")
                        return
                    }
                    
                    if let code = jsonObject["code"] as? Int, code != 200 {
                        let serverMessage = jsonObject["message"] as? String ?? "Unknown server error."
                        print("Server error: \(serverMessage)")
                        return
                    }
                    
                    guard let dataArray = jsonObject["data"] as? [[String: Any]] else {
                        print("Invalid data payload received")
                        return
                    }
                    
                    parseBloodPressureData(from: dataArray)
                } catch {
                    print("Error parsing data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func parseBloodPressureData(from dataArray: [[String: Any]]) {
        var readings: [BloodPressureReading] = []
        
        let rawFormatter = DateFormatter()
        rawFormatter.locale = Locale(identifier: "en_US_POSIX")
        rawFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        for (_, entry) in dataArray.enumerated() {
            guard let datetimeString = entry["datetime"] as? String,
                  let diastolicValue = entry["diastolic"] as? Int,
                  let systolicValue = entry["systolic"] as? Int,
                  let pulseRateValue = entry["pulse_rate"] as? Int,
                  let time = rawFormatter.date(from: datetimeString) else {
                continue
            }
            
            let reading = BloodPressureReading(
                time: time,
                diastolic: diastolicValue,
                systolic: systolicValue,
                pulseRate: pulseRateValue
            )
            
            readings.append(reading)
        }
        
        self.bloodPressureData = readings.sorted { $0.time < $1.time }
    }
    
}

// MARK: - Data Models

struct BloodPressureReading: Identifiable {
    let id = UUID()
    let time: Date
    let diastolic: Int
    let systolic: Int
    let pulseRate: Int
}


#Preview {
    NavigationView {
        BloodPressureDataChartView()
    }
}
