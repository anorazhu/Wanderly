import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    enum Field {
        case email, password, confirmPassword
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationView { // Wrap in NavigationView
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .overlayBox, radius: 5, x: 4, y: 10)

                    VStack {
                        // Header
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.header)
                            .padding(.bottom, 40)

                        // Email, Password, and Confirm Password Fields
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .submitLabel(.next)
                                .focused($focusField, equals: .email)
                                .onSubmit {
                                    focusField = .password
                                }
                                .onChange(of: email) {
                                    enableButtons()
                                }
                            
                            SecureField("Password", text: $password)
                                .submitLabel(.next)
                                .focused($focusField, equals: .password)
                                .onSubmit {
                                    focusField = .confirmPassword
                                }
                                .onChange(of: password) {
                                    enableButtons()
                                }

                            SecureField("Confirm Password", text: $confirmPassword)
                                .submitLabel(.done)
                                .focused($focusField, equals: .confirmPassword)
                                .onSubmit {
                                    focusField = nil
                                }
                                .onChange(of: confirmPassword) {
                                    enableButtons()
                                }
                        }
                        .padding()
                        .background(Color.overlayTextField.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.button, lineWidth: 1)
                        )
                        .padding(.horizontal)

                        // Sign Up Button
                        Button("Sign Up") {
                            register()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.button)
                        .cornerRadius(30)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .disabled(buttonDisabled)
                    }
                    .padding()
                }
                .frame(maxWidth: 300, maxHeight: 400)

                // Already have an account? Login Link
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.header)
                        .font(.footnote)
                    
                    NavigationLink {
                        LoginView() // Navigate back to LoginView
                    } label: {
                        Text("Log In")
                            .foregroundColor(.links)
                            .font(.footnote)
                            .bold()
                    }
                }
                .padding(.top, 20)
                .alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
    }

    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        let passwordsMatch = password == confirmPassword
        buttonDisabled = !(emailIsGood && passwordIsGood && passwordsMatch)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 Sign Up ERROR: \(error.localizedDescription)")
                alertMessage = "😡 Sign Up ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😃 Registration success!")
                // If registration is successful, log the user in automatically or show a success message
                alertMessage = "Registration successful! You're now logged in."
                showingAlert = true
            }
        }
    }
}

#Preview {
    SignUpView()
}
