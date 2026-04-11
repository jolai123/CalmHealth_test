import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var currentUser: User?
    @State private var username = ""
    @State private var password = ""
    @State private var showSignup = false
    @AppStorage("users") private var usersData: Data = Data()
    @State private var error: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Login")
                .font(.largeTitle).fontWeight(.bold)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if let error = error {
                Text(error).foregroundColor(.red).font(.caption)
            }
            Button("Login") {
                login()
            }
            .buttonStyle(.borderedProminent)
            Button("Don't have an account? Sign Up") {
                showSignup = true
            }
            .font(.footnote)
        }
        .padding()
        .sheet(isPresented: $showSignup) {
            SignupView(isPresented: $showSignup)
        }
    }
    
    func login() {
        let users = loadUsers()
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            currentUser = user
            isLoggedIn = true
        } else {
            error = "Invalid username or password"
        }
    }
    
    func loadUsers() -> [User] {
        if let loaded = try? JSONDecoder().decode([User].self, from: usersData) {
            return loaded
        }
        return []
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false), currentUser: .constant(nil))
    }
}
