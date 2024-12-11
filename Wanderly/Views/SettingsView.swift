//
//  SettingsView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/4/24.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Binding var selectedTab: Int
    @State private var navigateToLogin = false

    var body: some View {
        VStack(spacing: 20) {
            // Display settings options
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            // Placeholder for settings content
            Text("Your app settings go here.")
                .font(.headline)
                .padding()

        
            NavigationLink {
                LoginView()
            } label: {
                Button {
                    logOut()
                } label: {
                    Text("Log Out")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .padding([.horizontal, .top], 20)

            }

            
            Spacer()
        }
        .navigationTitle("Settings")
        .background(Color(.systemBackground))
    }

    // Log out function
    private func logOut() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully.")
            navigateToLogin = true // Set flag to navigate to LoginView
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView(selectedTab: .constant(1))
}
