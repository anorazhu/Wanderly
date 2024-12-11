import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var selectedTab: Int = 0 // Track the selected tab index
    @State private var showLogoutPopup: Bool = false // Track if the logout popup is shown
    @State private var showLoginView: Bool = false // Track if the LoginView should be shown

    var body: some View {
        TabView(selection: $selectedTab) {
            WelcomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "location.magnifyingglass")
                    Text("Explore")
                }
                .tag(0)

            BucketListView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "globe.asia.australia.fill")
                    Text("Bucket List")
                }
                .tag(1)

            // Settings tab that shows only the logout popup
            Color.clear // Invisible view
                .tabItem {
                    Image(systemName: "arrow.backward.circle")
                    Text("Logout")
                }
                .tag(2)
                .onAppear {
                    showLogoutPopup = true // Trigger the logout alert when the tab is selected
                }
        }
        .alert("Log Out", isPresented: $showLogoutPopup, actions: {
            Button("Cancel", role: .cancel) {
                selectedTab = 0 // Reset to the Explore tab if canceled
            }
            Button("Log Out", role: .destructive) {
                logOut()
            }
        }, message: {
            Text("Are you sure you want to log out?")
        })
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        }
    }

    // Log out function
    private func logOut() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully.")
            showLoginView = true // Show the LoginView after logout
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
