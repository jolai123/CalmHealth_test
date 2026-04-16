//
//  OximeterDataChartView.swift
//  VibeCoding1
//
//  Created by chapman on 1/9/2025.
//

import SwiftUI
import Charts

struct OximeterDataPoint: Identifiable {
    let id = UUID()
    let time: Date
    let spo2: Int
    let heartRate: Int
    let pi: Double
}

struct OximeterDataChartView: View {
    @State private var dataPoints: [OximeterDataPoint] = []
    @State private var isLoading = false

    
    var body: some View {
        VStack(spacing: 20) {
            // Loading indicator
            if isLoading {
                ProgressView("Loading data...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if dataPoints.isEmpty {
                Text("No data available")
            } else {
                // Chart View
                ScrollView {
                    VStack(spacing: 20) {
                        // SpO2 & Heart Rate Chart
                        VStack(alignment: .leading, spacing: 10) {
                            Text("SpO2 & Heart Rate")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            Chart {
                                ForEach(dataPoints) { dataPoint in
                                    // SpO2 Line
                                    LineMark(
                                        x: .value("Time", dataPoint.time),
                                        y: .value("Value", dataPoint.spo2)
                                    )
                                    .foregroundStyle(.blue)
                                    .interpolationMethod(.catmullRom)
                                    .symbol(by: .value("Type", "SpO2"))
                                    
                                    // Heart Rate Line
                                    LineMark(
                                        x: .value("Time", dataPoint.time),
                                        y: .value("Value", dataPoint.heartRate)
                                    )
                                    .foregroundStyle(.blue)
                                    .interpolationMethod(.catmullRom)
                                    .symbol(by: .value("Type", "Heart Rate"))
                            }
                        }
                        .chartForegroundStyleScale([
                            "SpO2": Color(red: 0.2, green: 0.5, blue: 0.9),
                            "Heart Rate": Color(red: 0.3, green: 0.6, blue: 0.95)
                            ])
                            .frame(height: 250)
                            .chartYAxisLabel("Value", position: .leading)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.month().day())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Perfusion Index (PI) Chart
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Perfusion Index (PI)")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            Chart {
                                ForEach(dataPoints) { dataPoint in
                                    // PI Line
                                    LineMark(
                                        x: .value("Time", dataPoint.time),
                                        y: .value("Value", dataPoint.pi)
                                    )
                                    .foregroundStyle(Color(red: 0.2, green: 0.5, blue: 0.9))
                                    .interpolationMethod(.catmullRom)
                                    .symbol(by: .value("Type", "PI"))
                                }
                            }
                            .chartForegroundStyleScale([
                                "PI": .purple
                            ])
                            .frame(height: 250)
                            .chartYAxisLabel("PI Value", position: .leading)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.month().day())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Oximeter Data Charts")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchOximeterData()
        }
    }
    
    // MARK: - Data Fetching
    
    private func fetchOximeterData() {
        isLoading = true
        
        let sheetName = "oximeter"
        
        var urlComponents = URLComponents(string: Setting.shared.appScriptUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "sheetId", value: Setting.shared.sheetId),
            URLQueryItem(name: "sheetName", value: sheetName),
            URLQueryItem(name: "user", value: Setting.shared.username)
        ]
        
        guard let url = urlComponents.url else {
            isLoading = false
            print("Failed to create request URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    print("Failed to fetch data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received from server.")
                    return
                }
                
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Invalid data format received.")
                        return
                    }
                    
                    if let code = jsonObject["code"] as? Int, code != 200 {
                        let serverMessage = jsonObject["message"] as? String ?? "Unknown server error."
                        print("serverMessage: \(serverMessage)")
                        return
                    }
                    
                    guard let dataArray = jsonObject["data"] as? [[String: Any]] else {
                        print("Invalid data payload received.")
                        return
                    }
                    
                    parseOximeterData(from: dataArray)
                    
                } catch {
                    print("Failed to parse data: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    private func parseOximeterData(from dataArray: [[String: Any]]) {
        print("dataArray: \(dataArray)")
        var newDataPoints: [OximeterDataPoint] = []
        
        let rawFormatter = DateFormatter()
        rawFormatter.locale = Locale(identifier: "en_US_POSIX")
        rawFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        for (_, item) in dataArray.enumerated() {
            guard let timeString = item["datetime"] as? String,
                  let validTime = rawFormatter.date(from: timeString),
                  let spo2 = item["spo2"] as? Int,
                  let heartRate = item["heart_rate"] as? Int,
                  let pi = item["pi"] as? Double else {
                continue
            }
            
            let dataPoint = OximeterDataPoint(
                time: validTime,
                spo2: spo2,
                heartRate: heartRate,
                pi: pi
            )
            newDataPoints.append(dataPoint)
        }
        
        // 按时间排序
        dataPoints = newDataPoints.sorted { $0.time < $1.time }
    }
}


#Preview {
    NavigationView {
        OximeterDataChartView()
    }
}
