import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var showLogoutConfirmation = false // State to show logout confirmation
    @State private var navigateToLogin = false // State to navigate to LoginView
    @Binding var selectedTab: Int // Binding to handle tab selection reset

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .overlayBox, radius: 5, x: 4, y: 10)

                    VStack(spacing: 30) {
                        // Header
                        Text("Log Out")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.header)
                            .padding(.top, 20)

                        // Message
                        Text("Are you sure you want to log out?")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                            .padding(.horizontal)

                        // Buttons
                        VStack(spacing: 15) {
                            Button("Yes, Log Out") {
                                showLogoutConfirmation = true
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(30)

                            Button("Cancel") {
                                // Navigate back to the previous tab
                                selectedTab = 0 // Reset to the "Explore" tab
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(.button)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.overlayTextField.opacity(0.1))
                            .cornerRadius(30)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                .frame(maxWidth: 300, maxHeight: 300)

                Spacer()

                // Navigation to LoginView after logout
                NavigationLink(
                    destination: LoginView(),
                    isActive: $navigateToLogin
                ) {
                    EmptyView()
                }
                .hidden() // Hide the NavigationLink
            }
            .background(.white)
            .navigationTitle("Log Out")
            .alert("Log Out Confirmation", isPresented: $showLogoutConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Log Out", role: .destructive) {
                    logOut()
                }
            } message: {
                Text("This will log you out of your account.")
            }
        }
    }

    // Log out function
    private func logOut() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully.")
            navigateToLogin = true // Navigate to LoginView
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView(selectedTab: .constant(2))
}
