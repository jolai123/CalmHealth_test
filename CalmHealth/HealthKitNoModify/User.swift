import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let username: String
    let password: String // For demo only; use secure storage in production
    
    init(username: String, password: String) {
        self.id = UUID()
        self.username = username
        self.password = password
    }
}
