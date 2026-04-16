//
//  ChatBotView.swift
//  HealthKitNoModify
//
//  Created by Copilot on 10/4/2026.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatBotView: View {
    @State private var messages: [Message] = [
        Message(content: "Hello! I'm your health assistant. How can I help you today?", isUser: false, timestamp: Date())
    ]
    @State private var inputText: String = ""
    @State private var isLoading = false
    
    let apiKey = "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"
    
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
                VStack(spacing: 8) {
                    Text("Health Assistant")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                    Text("Ask me about your health")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.3))
                
                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            if messages.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                        .font(.system(size: 48))
                                        .foregroundColor(Color(red: 0.4, green: 0.65, blue: 0.65))
                                    
                                    Text("Start a Conversation")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    
                                    Text("Ask me about health tips, wellness advice, or any questions")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxHeight: .infinity)
                                .padding()
                            } else {
                                ForEach(messages) { message in
                                    ChatMessageBubble(message: message)
                                        .id(message.id)
                                }
                            }
                        }
                        .padding()
                        .onChange(of: messages.count) {
                            withAnimation {
                                proxy.scrollTo(messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        TextField("Ask your health question...", text: $inputText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxHeight: 40)
                        
                        Button(action: sendMessage) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                        .frame(width: 40, height: 40)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                }
            }
        }
    }
    
    private func sendMessage() {
        let userMessage = inputText.trimmingCharacters(in: .whitespaces)
        guard !userMessage.isEmpty else { return }
        
        // Add user message
        messages.append(Message(content: userMessage, isUser: true, timestamp: Date()))
        inputText = ""
        isLoading = true
        
        // Call API
        callChatAPI(userMessage)
    }
    
    private func callChatAPI(_ userMessage: String) {
        let url = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("HealthKitApp", forHTTPHeaderField: "HTTP-Referer")
        request.setValue("HealthKit", forHTTPHeaderField: "X-Title")
        
        let messages_for_api = messages.map { message -> [String: String] in
            return [
                "role": message.isUser ? "user" : "assistant",
                "content": message.content
            ]
        }
        
        let body: [String: Any] = [
            "model": "meta-llama/llama-2-7b-chat",
            "messages": messages_for_api,
            "temperature": 0.7,
            "max_tokens": 500
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Debug logging
        print("🔵 API Request URL: \(url)")
        print("🔵 API Key (last 20 chars): ...\(apiKey.suffix(20))")
        if let body = request.httpBody, let jsonString = String(data: body, encoding: .utf8) {
            print("🔵 Request Body: \(jsonString)")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                // Log response status
                if let httpResponse = response as? HTTPURLResponse {
                    print("🟢 HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                // Log raw response data
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("🟢 Response Data: \(responseString)")
                }
                
                if let error = error {
                    print("🔴 Network Error: \(error.localizedDescription)")
                    // Add mock response on error
                    messages.append(Message(
                        content: "I'm having trouble connecting to the server. Here's a sample response: Stay hydrated and get enough sleep for better health!",
                        isUser: false,
                        timestamp: Date()
                    ))
                    return
                }
                
                guard let data = data else {
                    print("🔴 No data received")
                    messages.append(Message(
                        content: "No response received. Please try again.",
                        isUser: false,
                        timestamp: Date()
                    ))
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        // Check for API error
                        if let error = jsonResponse["error"] as? [String: Any],
                           let errorMessage = error["message"] as? String {
                            print("🔴 API Error: \(errorMessage)")
                            messages.append(Message(
                                content: "API Error: \(errorMessage)",
                                isUser: false,
                                timestamp: Date()
                            ))
                            return
                        }
                        
                        // Parse successful response
                        if let choices = jsonResponse["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            
                            print("🟢 Got response: \(content)")
                            messages.append(Message(
                                content: content,
                                isUser: false,
                                timestamp: Date()
                            ))
                        } else {
                            // Log response structure for debugging
                            print("🔴 Could not parse response structure: \(jsonResponse)")
                            messages.append(Message(
                                content: "Unable to parse response format. Please try again.",
                                isUser: false,
                                timestamp: Date()
                            ))
                        }
                    }
                } catch {
                    print("🔴 JSON Parse Error: \(error.localizedDescription)")
                    messages.append(Message(
                        content: "Failed to process response: \(error.localizedDescription)",
                        isUser: false,
                        timestamp: Date()
                    ))
                }
            }
        }.resume()
    }
}

struct ChatMessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(spacing: 12) {
            if message.isUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.8), Color(red: 0.40, green: 0.65, blue: 0.65).opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: .trailing)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(.black)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: .leading)
                
                Spacer()
            }
        }
        .padding(.horizontal, 12)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ChatBotView()
}
