//
//  ThermometerDataChartView.swift
//  VibeCoding1
//
//  Created by chapman on 1/9/2025.
//

import SwiftUI
import Charts

struct ThermometerDataPoint: Identifiable, Codable {
    let id: UUID
    let time: Date
    let mode: String
    let temperature: Double
    
    init(date: Date, mode: String, temperature: Double) {
        self.id = UUID()
        self.time = date
        self.mode = mode
        self.temperature = temperature
    }
}

struct ThermometerDataChartView: View {
    @State private var dataPoints: [ThermometerDataPoint] = []
    @State private var isLoading = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            contentView
            Spacer()
        }
        .navigationTitle("Data History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadThermometerData()
        }
        
    }
    
    // Header section
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Thermometer Data History")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding(.top)
    }
    
    // Main content section
    private var contentView: some View {
        Group {
            if isLoading {
                Text("Loading thermometer data...")
            } else if dataPoints.isEmpty {
                Text("No data available")
            } else {
                chartContentView
            }
        }
    }

    
    // Temperature charts view
    private var chartContentView: some View {
        ScrollView {
            VStack(spacing: 30) {
                let modes = Set(dataPoints.map(\.mode)).sorted()
                ForEach(modes, id: \.self) { mode in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(mode) Mode")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        let modeData = dataPoints.filter { $0.mode == mode }
                        
                        Chart(Array(modeData.enumerated()), id: \.offset) { index, dataPoint in
                            LineMark(
                                x: .value("Index", index),
                                y: .value("Temperature", dataPoint.temperature)
                            )
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 2))

                            PointMark(
                                x: .value("Index", index),
                                y: .value("Temperature", dataPoint.temperature)
                            )
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let temp = value.as(Double.self) {
                                        Text(String(format: "%.1f°C", temp))
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom) { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let index = value.as(Int.self),
                                       index >= 0 && index < modeData.count {
                                        let dataPoint = modeData[index]
                                        Text(dataPoint.time, format: .dateTime.hour().minute())
                                            .font(.caption2)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    // Function to load thermometer data from API
    private func loadThermometerData() {
        isLoading = true
        
        let sheetName = "thermometer"
        let urlString = "\(Setting.shared.appScriptUrl)?sheetId=\(Setting.shared.sheetId)&sheetName=\(sheetName)&user=\(Setting.shared.username)"
        
        guard let url = URL(string: urlString) else {
            print("Failed to construct URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                let rawFormatter = DateFormatter()
                rawFormatter.locale = Locale(identifier: "en_US_POSIX")
                rawFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data)
                    
                    if let jsonDict = jsonObject as? [String: Any],
                       let dataArray = jsonDict["data"] as? [[String: Any]] {
                        
                        var parsedData: [ThermometerDataPoint] = []
                        
                        for row in dataArray {
                            guard let timeString = row["datetime"] as? String,
                                  let mode = row["mode"] as? String,
                                  let temperature = row["temperature"] as? Double,
                                  let date = rawFormatter.date(from: timeString) else {
                                continue
                            }
                            
                            let dataPoint = ThermometerDataPoint(
                                date: date,
                                mode: mode,
                                temperature: temperature
                            )
                            parsedData.append(dataPoint)
                        }
                        
                        self.dataPoints = parsedData.sorted { $0.time < $1.time }
                        
                    } else {
                        print("Invalid data format received")
                    }
                } catch {
                    print("Failed to parse data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

#Preview {
    ThermometerDataChartView()
}
