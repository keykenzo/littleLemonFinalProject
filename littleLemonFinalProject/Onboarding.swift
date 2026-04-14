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
            Text("Bem-vindo ao\nLittle Lemon 🍋")
                .font(.largeTitle).bold()
                .multilineTextAlignment(.center)

            Text("Vamos criar seu perfil. Qual é o seu primeiro nome?")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("Primeiro nome", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)
                .autocorrectionDisabled()
        }
        .padding()
    }

   
    var pageSegundo: some View {
        VStack(spacing: 16) {
            Text("Quase lá!")
                .font(.largeTitle).bold()

            Text("Qual é o seu sobrenome?")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField("Sobrenome", text: $lastName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)
                .autocorrectionDisabled()
        }
        .padding()
    }

  
    var pageTerceiro: some View {
        VStack(spacing: 16) {
            Text("Último passo!")
                .font(.largeTitle).bold()

            Text("Informe seu e-mail para finalizar o cadastro.")
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
                showError(message: "Por favor, informe seu primeiro nome.")
                return
            }
            withAnimation { currentPage = 1 }

        } else if currentPage == 1 {
            guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
                showError(message: "Por favor, informe seu sobrenome.")
                return
            }
            withAnimation { currentPage = 2 }

        } else {
            guard isValidEmail(email) else {
                showError(message: "Por favor, informe um e-mail válido.")
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
