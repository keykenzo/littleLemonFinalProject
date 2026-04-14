import SwiftUI

struct Profile: View {
     
    @AppStorage("firstName")  var storedFirstName = ""
    @AppStorage("lastName")   var storedLastName  = ""
    @AppStorage("email")      var storedEmail     = ""
    @AppStorage("isLoggedIn") var isLoggedIn      = false

     
    @State private var firstName      = ""
    @State private var lastName       = ""
    @State private var email          = ""
    @State private var showSavedAlert = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                 
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .foregroundColor(Color("Primary1"))
                    .padding(.top, 20)

                Text("\(storedFirstName) \(storedLastName)")
                    .font(.title3.bold())

                 
                VStack(alignment: .leading, spacing: 16) {
                    fieldView(label: "First Name", text: $firstName)

                    fieldView(label: "Last Name", text: $lastName)

                    fieldView(
                        label: "E-mail",
                        text: $email,
                        keyboardType: .emailAddress
                    )
                }
                .padding(.horizontal, 20)

                 
                VStack(spacing: 12) {
                     
                    Button {
                        saveChanges()
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Primary1"))
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(12)
                    }

                     
                    Button {
                        logout()
                    } label: {
                        Text("Log out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Primary2"))
                            .foregroundColor(.black)
                            .font(.headline)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadStoredData)
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your informations has been updated.")
        }
    }

     

    @ViewBuilder
    func fieldView(
        label: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            TextField(label, text: text)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .autocorrectionDisabled()
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }

    

    func loadStoredData() {
        firstName = storedFirstName
        lastName  = storedLastName
        email     = storedEmail
    }

    func saveChanges() {
        storedFirstName = firstName.trimmingCharacters(in: .whitespaces)
        storedLastName  = lastName.trimmingCharacters(in: .whitespaces)
        storedEmail     = email.trimmingCharacters(in: .whitespaces)
        showSavedAlert  = true
    }

    func logout() {
         
        storedFirstName = ""
        storedLastName  = ""
        storedEmail     = ""
        isLoggedIn      = false
    }
}

#Preview {
    NavigationStack {
        Profile()
    }
}
