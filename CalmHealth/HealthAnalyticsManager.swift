//
//  HealthAnalyticsManager.swift
//  HealthKitNoModify
//
//  Created by Copilot on 9/4/2026.
//

import Foundation
import Combine

struct HealthMetric {
    let value: Double
    let timestamp: Date
    let type: String
}

struct HealthScore {
    let overall: Double
    let temperature: Double
    let oxygen: Double
    let bloodPressure: Double
    let status: String
}

struct HealthInsight {
    let title: String
    let description: String
    let type: InsightType
    let severity: Severity
}

enum InsightType {
    case trend
    case alert
    case recommendation
    case statistic
}

enum Severity {
    case info
    case warning
    case critical
}

class HealthAnalyticsManager: ObservableObject {
    @Published var healthScore: HealthScore = HealthScore(overall: 0, temperature: 0, oxygen: 0, bloodPressure: 0, status: "No Data")
    @Published var insights: [HealthInsight] = []
    @Published var metrics: [HealthMetric] = []
    
    // Normal ranges
    private let tempMin = 36.1
    private let tempMax = 37.2
    private let spo2Min = 95.0
    private let spo2Max = 100.0
    private let bpSystolicMax = 120.0
    private let bpDiastolicMax = 80.0
    
    init() {
        generateMockData()
        updateAnalytics()
    }
    
    func addMetric(value: Double, type: String) {
        let metric = HealthMetric(value: value, timestamp: Date(), type: type)
        metrics.append(metric)
        updateAnalytics()
    }
    
    func updateAnalytics() {
        calculateHealthScore()
        generateInsights()
    }
    
    private func calculateHealthScore() {
        let tempScore = calculateTemperatureScore()
        let oxygenScore = calculateOxygenScore()
        let bpScore = calculateBloodPressureScore()
        
        let overall = (tempScore * 0.30) + (oxygenScore * 0.35) + (bpScore * 0.35)
        
        let status = getHealthStatus(overall)
        
        healthScore = HealthScore(
            overall: overall,
            temperature: tempScore,
            oxygen: oxygenScore,
            bloodPressure: bpScore,
            status: status
        )
    }
    
    private func calculateTemperatureScore() -> Double {
        let recentTemp = getRecentMetrics(type: "temperature", days: 7).average
        
        if recentTemp == 0 { return 0 }
        
        if recentTemp >= tempMin && recentTemp <= tempMax {
            return 100
        } else if (recentTemp > 37.2 && recentTemp <= 37.5) || (recentTemp >= 35.8 && recentTemp < 36.1) {
            return 80
        } else if (recentTemp > 37.5 && recentTemp <= 38.5) || (recentTemp >= 35.0 && recentTemp < 35.8) {
            return 60
        } else {
            return 40
        }
    }
    
    private func calculateOxygenScore() -> Double {
        let recentOxygen = getRecentMetrics(type: "oxygen", days: 7).average
        
        if recentOxygen == 0 { return 0 }
        
        if recentOxygen >= spo2Min && recentOxygen <= spo2Max {
            return 100
        } else if recentOxygen >= 93 && recentOxygen < spo2Min {
            return 80
        } else if recentOxygen >= 90 && recentOxygen < 93 {
            return 60
        } else {
            return 40
        }
    }
    
    private func calculateBloodPressureScore() -> Double {
        let recentMetrics = getRecentMetrics(type: "systolic", days: 7)
        let recentSystolic = recentMetrics.average
        
        if recentSystolic == 0 { return 0 }
        
        if recentSystolic <= bpSystolicMax {
            return 100
        } else if recentSystolic <= 130 {
            return 80
        } else if recentSystolic <= 140 {
            return 60
        } else {
            return 40
        }
    }
    
    private func getHealthStatus(_ score: Double) -> String {
        switch score {
        case 80...100:
            return "Excellent"
        case 60..<80:
            return "Good"
        case 40..<60:
            return "Fair"
        case 0..<40:
            return "Poor"
        default:
            return "No Data"
        }
    }
    
    private func generateInsights() {
        insights = []
        
        // Trend insights
        generateTrendInsights()
        
        // Alert insights
        generateAlertInsights()
        
        // Recommendation insights
        generateRecommendations()
        
        // Statistical insights
        generateStatisticalInsights()
    }
    
    private func generateTrendInsights() {
        let tempTrend = calculateTrend(type: "temperature")
        let oxygenTrend = calculateTrend(type: "oxygen")
        let bpTrend = calculateTrend(type: "systolic")
        
        if tempTrend > 0.1 {
            insights.append(HealthInsight(
                title: "Temperature Rising",
                description: "Your temperature has been increasing gradually. Monitor for fever symptoms.",
                type: .trend,
                severity: .warning
            ))
        }
        
        if oxygenTrend < -0.5 {
            insights.append(HealthInsight(
                title: "Oxygen Level Declining",
                description: "Your SPO2 levels show a downward trend. Ensure adequate rest and ventilation.",
                type: .trend,
                severity: .warning
            ))
        }
        
        if bpTrend > 0.2 {
            insights.append(HealthInsight(
                title: "Blood Pressure Increasing",
                description: "Your systolic blood pressure is trending upward. Consider stress reduction.",
                type: .trend,
                severity: .warning
            ))
        }
    }
    
    private func generateAlertInsights() {
        let recentMetrics = getRecentMetrics(type: "temperature", days: 1)
        
        if recentMetrics.max > 37.5 {
            insights.append(HealthInsight(
                title: "Fever Detected",
                description: "Your temperature is elevated. Stay hydrated and monitor symptoms.",
                type: .alert,
                severity: .critical
            ))
        }
        
        let oxygenMetrics = getRecentMetrics(type: "oxygen", days: 1)
        if oxygenMetrics.min < 95 && oxygenMetrics.min > 0 {
            insights.append(HealthInsight(
                title: "Low Oxygen Level",
                description: "Your SPO2 has dropped below safe levels. Ensure proper ventilation.",
                type: .alert,
                severity: .critical
            ))
        }
        
        let bpMetrics = getRecentMetrics(type: "systolic", days: 1)
        if bpMetrics.max > 140 {
            insights.append(HealthInsight(
                title: "High Blood Pressure",
                description: "Your systolic BP is elevated. Consult a healthcare provider if persistent.",
                type: .alert,
                severity: .critical
            ))
        }
    }
    
    private func generateRecommendations() {
        let tempScore = healthScore.temperature
        let oxygenScore = healthScore.oxygen
        let bpScore = healthScore.bloodPressure
        
        if tempScore < 70 {
            insights.append(HealthInsight(
                title: "Monitor Temperature",
                description: "Keep track of your temperature daily and consult a doctor if abnormality persists.",
                type: .recommendation,
                severity: .info
            ))
        }
        
        if oxygenScore < 75 {
            insights.append(HealthInsight(
                title: "Improve Oxygen Levels",
                description: "Try deep breathing exercises, get adequate sleep, and ensure proper room ventilation.",
                type: .recommendation,
                severity: .info
            ))
        }
        
        if bpScore < 75 {
            insights.append(HealthInsight(
                title: "Manage Blood Pressure",
                description: "Reduce sodium intake, exercise regularly, manage stress, and limit caffeine.",
                type: .recommendation,
                severity: .info
            ))
        } else {
            insights.append(HealthInsight(
                title: "Maintain Good Health",
                description: "Your vital signs are healthy. Continue regular monitoring and healthy lifestyle.",
                type: .recommendation,
                severity: .info
            ))
        }
    }
    
    private func generateStatisticalInsights() {
        let tempMetrics = getRecentMetrics(type: "temperature", days: 7)
        let oxygenMetrics = getRecentMetrics(type: "oxygen", days: 7)
        
        if tempMetrics.average > 0 {
            insights.append(HealthInsight(
                title: "7-Day Temperature Average",
                description: String(format: "Your average temperature is %.1f°C", tempMetrics.average),
                type: .statistic,
                severity: .info
            ))
        }
        
        if oxygenMetrics.average > 0 {
            insights.append(HealthInsight(
                title: "7-Day Oxygen Average",
                description: String(format: "Your average SPO2 is %.1f%%", oxygenMetrics.average),
                type: .statistic,
                severity: .info
            ))
        }
    }
    
    private func calculateTrend(type: String) -> Double {
        let metrics = getRecentMetrics(type: type, days: 7).metrics.sorted { $0.timestamp < $1.timestamp }
        
        if metrics.count < 2 { return 0 }
        
        let firstHalf = metrics.prefix(metrics.count / 2).map { $0.value }.average
        let secondHalf = metrics.suffix(metrics.count / 2).map { $0.value }.average
        
        return secondHalf - firstHalf
    }
    
    private func getRecentMetrics(type: String, days: Int) -> (average: Double, min: Double, max: Double, metrics: [HealthMetric]) {
        let cutoffDate = Date().addingTimeInterval(-Double(days) * 86400)
        let recentMetrics = metrics.filter { $0.type == type && $0.timestamp >= cutoffDate }
        
        let values = recentMetrics.map { $0.value }
        
        if values.isEmpty {
            return (0, 0, 0, [])
        }
        
        return (
            values.average,
            values.min() ?? 0,
            values.max() ?? 0,
            recentMetrics
        )
    }
    
    private func generateMockData() {
        let now = Date()
        
        // Mock temperature data
        for i in 0..<30 {
            let date = now.addingTimeInterval(-Double(i) * 86400)
            let temp = 36.8 + Double.random(in: -0.5...0.5)
            metrics.append(HealthMetric(value: temp, timestamp: date, type: "temperature"))
        }
        
        // Mock oxygen data
        for i in 0..<30 {
            let date = now.addingTimeInterval(-Double(i) * 86400)
            let oxygen = 97.0 + Double.random(in: -2...2)
            metrics.append(HealthMetric(value: oxygen, timestamp: date, type: "oxygen"))
        }
        
        // Mock BP systolic data
        for i in 0..<30 {
            let date = now.addingTimeInterval(-Double(i) * 86400)
            let systolic = 118.0 + Double.random(in: -5...5)
            metrics.append(HealthMetric(value: systolic, timestamp: date, type: "systolic"))
        }
    }
}

extension Array where Element == Double {
    var average: Double {
        isEmpty ? 0 : reduce(0, +) / Double(count)
    }
}
