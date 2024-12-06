//
//  ContentView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0 // Track the selected tab index

    var body: some View {
        TabView(selection: $selectedTab) { // Bind to selectedTab
            WelcomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "location.magnifyingglass")
                    Text("Explore")
                }
                .tag(0) // Assign tag for this tab

            BucketListView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "globe.asia.australia.fill")
                    Text("Bucket List")
                }
                .tag(1) // Assign tag for this tab

            SettingsView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(2) // Assign tag for this tab
        }
    }
}

#Preview {
    ContentView()
}
