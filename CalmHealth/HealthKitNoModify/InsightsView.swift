//
//  InsightsView.swift
//  HealthKitNoModify
//
//  Created by Copilot on 9/4/2026.
//

import SwiftUI

struct InsightsView: View {
    @StateObject private var analyticsManager = HealthAnalyticsManager()
    
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
                        Text("Health Insights")
                            .font(.largeTitle).fontWeight(.heavy)
                            .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                        Text("AI-Powered Health Analysis")
                            .font(.title3).italic()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Health Score Card
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Overall Health Score")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text(analyticsManager.healthScore.status)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 4) {
                                Text(String(format: "%.0f", analyticsManager.healthScore.overall))
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(scoreColor(analyticsManager.healthScore.overall))
                                Text("/ 100")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Score breakdown
                        VStack(spacing: 12) {
                            ScoreBreakdownRow(label: "Temperature", score: analyticsManager.healthScore.temperature, color: Color(red: 0.1, green: 0.4, blue: 0.8))
                            ScoreBreakdownRow(label: "Oxygen Level", score: analyticsManager.healthScore.oxygen, color: Color(red: 0.2, green: 0.5, blue: 0.9))
                            ScoreBreakdownRow(label: "Blood Pressure", score: analyticsManager.healthScore.bloodPressure, color: Color(red: 0.3, green: 0.6, blue: 0.95))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                    .padding(.horizontal)
                    

                    
                    // Trend Analysis
                    NavigationLink(destination: TrendAnalysisView(analyticsManager: analyticsManager)) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))
                            Text("View Trend Analysis")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.2, green: 0.5, blue: 0.9))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
    }
    
    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 80...100:
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        case 60..<80:
            return Color(red: 1.0, green: 0.8, blue: 0.2)
        case 40..<60:
            return Color(red: 1.0, green: 0.5, blue: 0.2)
        default:
            return Color(red: 1.0, green: 0.3, blue: 0.3)
        }
    }
}

struct ScoreBreakdownRow: View {
    let label: String
    let score: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: "%.0f", score))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            ProgressView(value: score / 100)
                .tint(color)
        }
    }
}

struct InsightCard: View {
    let insight: HealthInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image(systemName: insightIcon)
                    .font(.title)
                    .foregroundColor(insightColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(insight.title)
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(.black)
                    Text(insight.description)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(3)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.1), radius: 3)
    }
    
    var insightIcon: String {
        switch insight.type {
        case .trend:
            return "chart.line.uptrend"
        case .alert:
            return "exclamationmark.circle"
        case .recommendation:
            return "lightbulb"
        case .statistic:
            return "doc.text"
        }
    }
    
    var insightColor: Color {
        switch insight.severity {
        case .info:
            return Color(red: 0.2, green: 0.7, blue: 0.9)
        case .warning:
            return Color(red: 1.0, green: 0.8, blue: 0.2)
        case .critical:
            return Color(red: 1.0, green: 0.3, blue: 0.3)
        }
    }
}

#Preview {
    InsightsView()
}
