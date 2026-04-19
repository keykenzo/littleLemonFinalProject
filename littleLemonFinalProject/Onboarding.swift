import SwiftUI

struct Onboarding: View {
    
    @AppStorage("firstName")  var storedFirstName = ""
    @AppStorage("lastName")   var storedLastName  = ""
    @AppStorage("email")      var storedEmail     = ""
    @AppStorage("isLoggedIn") var isLoggedIn      = false

    // Estado local enquanto o usuário preenche
    @State private var currentPage   = 0
    @State private var firstName     = ""
    @State private var lastName      = ""
    @State private var email         = ""
    @State private var showError     = false
    @State private var errorMessage  = ""

    var body: some View {
        VStack(spacing: 0) {
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .padding(.top, 16)

            
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == currentPage ? Color("Primary1") : Color.gray.opacity(0.35))
                        .frame(width: 10, height: 10)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.vertical, 20)

            
            TabView(selection: $currentPage) {
                pagePrimeiro.tag(0)
                pageSegundo.tag(1)
                pageTerceiro.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 340)
            .animation(.easeInOut, value: currentPage)

            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
                    .transition(.opacity)
            }

            
            Button(action: handleButton) {
                Text(currentPage < 2 ? "Next" : "Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Primary1"))
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()
        }
        .background(Color(.systemBackground))
    }

    
    var pagePrimeiro: some View {
        VStack(spacing: 16) {
            Text("Welcome to\nLittle Lemon 🍋")
                .font(.largeTitle).bold()
                .multilineTextAlignment(.center)

            Text("Lets create your profile. Whats is your name?")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("First name", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)
                .autocorrectionDisabled()
        }
        .padding()
    }

   
    var pageSegundo: some View {
        VStack(spacing: 16) {
            Text("Almost There!")
                .font(.largeTitle).bold()

            Text("What is your last name?")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField("Last Name", text: $lastName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)
                .autocorrectionDisabled()
        }
        .padding()
    }

  
    var pageTerceiro: some View {
        VStack(spacing: 16) {
            Text("Last step!")
                .font(.largeTitle).bold()

            Text("Please provide your e-mail so we can finish.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("E-mail", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.horizontal, 24)
        }
        .padding()
    }

   
    func handleButton() {
        showError = false

        if currentPage == 0 {
            guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
                showError(message: "Please, provide your first name.")
                return
            }
            withAnimation { currentPage = 1 }

        } else if currentPage == 1 {
            guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
                showError(message: "Please, provide your last name.")
                return
            }
            withAnimation { currentPage = 2 }

        } else {
            guard isValidEmail(email) else {
                showError(message: "Please, provide your e-mail.")
                return
            }
            // Salva no UserDefaults e navega para Home
            storedFirstName = firstName.trimmingCharacters(in: .whitespaces)
            storedLastName  = lastName.trimmingCharacters(in: .whitespaces)
            storedEmail     = email.trimmingCharacters(in: .whitespaces)
            isLoggedIn      = true
        }
    }

    func showError(message: String) {
        errorMessage = message
        withAnimation { showError = true }
    }

    func isValidEmail(_ value: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value)
    }
}

#Preview {
    Onboarding()
}
