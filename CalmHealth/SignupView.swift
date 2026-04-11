import SwiftUI

struct SignupView: View {
    @Binding var isPresented: Bool
    @AppStorage("users") private var usersData: Data = Data()
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var error: String?
    @State private var success: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Sign Up")
                .font(.largeTitle).fontWeight(.bold)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if let error = error {
                Text(error).foregroundColor(.red).font(.caption)
            }
            if success {
                Text("Account created! You can now log in.").foregroundColor(.green).font(.caption)
            }
            Button("Sign Up") {
                signup()
            }
            .buttonStyle(.borderedProminent)
            Button("Cancel") {
                isPresented = false
            }
            .font(.footnote)
        }
        .padding()
    }
    
    func signup() {
        guard !username.isEmpty, !password.isEmpty else {
            error = "All fields are required"
            return
        }
        guard password == confirmPassword else {
            error = "Passwords do not match"
            return
        }
        var users = loadUsers()
        if users.contains(where: { $0.username == username }) {
            error = "Username already exists"
            return
        }
        let user = User(username: username, password: password)
        users.append(user)
        if let data = try? JSONEncoder().encode(users) {
            usersData = data
            success = true
            error = nil
        } else {
            error = "Failed to save user"
        }
    }
    
    func loadUsers() -> [User] {
        if let loaded = try? JSONDecoder().decode([User].self, from: usersData) {
            return loaded
        }
        return []
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(isPresented: .constant(true))
    }
}
