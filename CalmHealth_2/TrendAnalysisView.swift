//
//  TrendAnalysisView.swift
//  HealthKitNoModify
//
//  Created by Copilot on 9/4/2026.
//

import SwiftUI

struct TrendAnalysisView: View {
    @ObservedObject var analyticsManager: HealthAnalyticsManager
    @State private var selectedMetric = "temperature"
    @Environment(\.presentationMode) var presentationMode
    
    let metrics = ["Temperature", "Oxygen", "Blood Pressure"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.92, green: 0.96, blue: 0.94), Color(red: 0.90, green: 0.94, blue: 0.92)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("Trend Analysis")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                        Text("7-Day Overview")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.70))
                }
                .padding()
                .background(Color.white.opacity(0.8))
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Metric Selection
                        VStack(spacing: 12) {
                            Text("Select Metric")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 8) {
                                ForEach(metrics, id: \.self) { metric in
                                    Button(action: { selectedMetric = metric.lowercased() }) {
                                        Text(metric)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(getMetricColor(metric).opacity(selectedMetric == metric.lowercased() ? 1 : 0.2))
                                            .foregroundColor(selectedMetric == metric.lowercased() ? .white : .gray)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Trend Chart
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("7-Day Trend")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Text(getTrendDescription())
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            
                            // Simple trend chart visualization
                            TrendChartView(metrics: getTrendMetrics())
                            
                            // Statistics
                            VStack(spacing: 12) {
                                StatRow(label: "Average", value: getAverageValue(), unit: getUnit())
                                StatRow(label: "Maximum", value: getMaxValue(), unit: getUnit())
                                StatRow(label: "Minimum", value: getMinValue(), unit: getUnit())
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.1), radius: 5)
                        .padding(.horizontal)
                        
                        // Health Status
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.3))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Health Status")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Text(getHealthStatus())
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.1), radius: 5)
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 20)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func getTrendMetrics() -> [Double] {
        let typeKey = selectedMetric.replacingOccurrences(of: "oxygen", with: "oxygen").replacingOccurrences(of: "bloodpressure", with: "systolic")
        let metrics = analyticsManager.metrics.filter { $0.type == typeKey }
        let last7 = Array(metrics.suffix(7)).sorted { $0.timestamp < $1.timestamp }
        return last7.map { $0.value }
    }
    
    private func getMetricColor(_ metric: String) -> Color {
        switch metric.lowercased() {
        case "temperature":
            return Color(red: 1.0, green: 0.5, blue: 0.2)
        case "oxygen":
            return Color(red: 0.2, green: 0.7, blue: 0.9)
        default:
            return Color(red: 0.8, green: 0.2, blue: 0.2)
        }
    }
    
    private func getTrendDescription() -> String {
        switch selectedMetric.lowercased() {
        case "temperature":
            return "Track your temperature changes over the past 7 days"
        case "oxygen":
            return "Monitor your SPO2 levels and oxygen saturation"
        default:
            return "View your blood pressure trends"
        }
    }
    
    private func getUnit() -> String {
        switch selectedMetric.lowercased() {
        case "temperature":
            return "°C"
        case "oxygen":
            return "%"
        default:
            return "mmHg"
        }
    }
    
    private func getAverageValue() -> String {
        let metrics = getTrendMetrics()
        let avg = metrics.isEmpty ? 0 : metrics.reduce(0, +) / Double(metrics.count)
        return String(format: "%.1f", avg)
    }
    
    private func getMaxValue() -> String {
        let max = getTrendMetrics().max() ?? 0
        return String(format: "%.1f", max)
    }
    
    private func getMinValue() -> String {
        let min = getTrendMetrics().min() ?? 0
        return String(format: "%.1f", min)
    }
    
    private func getHealthStatus() -> String {
        let avg = Double(getAverageValue()) ?? 0
        
        switch selectedMetric.lowercased() {
        case "temperature":
            if avg >= 36.1 && avg <= 37.2 { return "Normal - All readings within healthy range" }
            else if avg > 37.2 { return "Elevated - Monitor for fever symptoms" }
            else { return "Low - Consult healthcare provider if persistent" }
        case "oxygen":
            if avg >= 95 { return "Excellent - Oxygen saturation is healthy" }
            else if avg >= 90 { return "Good - Adequate oxygen levels" }
            else { return "Low - Seek medical attention" }
        default:
            if avg <= 120 { return "Normal - Blood pressure is healthy" }
            else if avg <= 139 { return "Elevated - Monitor regularly" }
            else { return "High - Consult healthcare provider" }
        }
    }
}

struct TrendChartView: View {
    let metrics: [Double]
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(0..<metrics.count, id: \.self) { index in
                    VStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(getColor(for: metrics[index]))
                            .frame(height: CGFloat(normalizeValue(metrics[index])) * 100)
                    }
                    .frame(height: 120)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("Day 1")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text("Day 7")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .frame(height: 160)
        .background(Color(red: 0.95, green: 0.98, blue: 0.95))
        .cornerRadius(8)
    }
    
    private func normalizeValue(_ value: Double) -> Double {
        let min = metrics.min() ?? 0
        let max = metrics.max() ?? 100
        let range = max - min
        
        if range == 0 { return 0.5 }
        return (value - min) / range
    }
    
    private func getColor(for value: Double) -> Color {
        if value > 98 {
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        } else if value > 95 {
            return Color(red: 1.0, green: 0.8, blue: 0.2)
        } else {
            return Color(red: 1.0, green: 0.5, blue: 0.2)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Text("\(value) \(unit)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.1, green: 0.5, blue: 0.4))
        }
    }
}

#Preview {
    TrendAnalysisView(analyticsManager: HealthAnalyticsManager())
}
