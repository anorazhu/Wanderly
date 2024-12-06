import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentSheet = false
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
                        Text("Sign In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.header)
                            .padding(.bottom, 40)

                        // Email and Password Fields
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
                                .submitLabel(.done)
                                .focused($focusField, equals: .password)
                                .onSubmit {
                                    focusField = nil
                                }
                                .onChange(of: password) {
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

                        // Forgot Password Button
                        Button("Forgot Password") {
                            // Handle forgot password action
                        }
                        .foregroundColor(.links)
                        .font(.footnote)
                        .padding(.top, 5)

                        // Sign In Button
                        Button("Sign In") {
                            login()
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
                
                // Navigation to Sign Up View
                HStack {
                    Text("New to App?")
                        .foregroundColor(.header)
                        .font(.footnote)
                    
                    NavigationLink {
                        SignUpView() // Navigate to SignUpView when pressed
                    } label: {
                        Text("Join Now")
                            .foregroundColor(.links)
                            .font(.footnote)
                            .bold()
                    }
                }
                .padding(.top, 20)
                .alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                }
                .onAppear(){
                    if Auth.auth().currentUser != nil { // if we're logged in ..
                        print("🪵 Log in succesful")
                        presentSheet = true
                    }
                }
                .fullScreenCover(isPresented: $presentSheet) {
                    ContentView() // This would be the landing page after login
                }
            }
        }
    }

    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 Sign Up ERROR: \(error.localizedDescription)")
                alertMessage = "😡 Sign Up ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😃 Registration success!")
                presentSheet = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "😡 LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login success!")
                presentSheet = true
            }
        }
    }
}

#Preview {
    LoginView()
}
