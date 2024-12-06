//
//  DestinationSuggestionsView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/4/24.
//

import SwiftUI

struct DestinationView: View {
    @Binding var selectedTab: Int
    @State private var selectedMood: String = "Relaxed"
    @State private var selectedBudget: String = "Moderate"
    @State private var selectedDistance: Double = 50.0
    @State private var isEditing: Bool = false // Toggle edit sheet

    // Mock data for cities
    let mockDestinations: [DestinationProfile] = [
        DestinationProfile(name: "Paris", image: "Paris", description: "The city of love and art. Enjoy the Eiffel Tower and Louvre."),
        DestinationProfile(name: "New York", image: "nyc", description: "The city that never sleeps. Visit Central Park and Times Square."),
        DestinationProfile(name: "Tokyo", image: "tokyo", description: "A bustling metropolis with amazing food and culture."),
        DestinationProfile(name: "Rome", image: "rome", description: "Step back in time with Rome’s rich history and architecture."),
        DestinationProfile(name: "Sydney", image: "sydney", description: "Famous for its opera house and beautiful beaches.")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title Section
                
                HStack {
                    // Destination Title
                    DestinationTitle()

                    Spacer() // Pushes the title to the left

                    // Edit Button
                    EditButton(isEditing: $isEditing)
                        .padding(.vertical, 5) // Adjust the padding as needed
                        .frame(width: 100) // You can set a fixed width for the button if needed
                }

                Divider()

                // Destination Profiles
                DestinationProfiles(selectedTab: $selectedTab, destinations: mockDestinations)
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden()
            .background(Color(.systemBackground))
            .sheet(isPresented: $isEditing) {
                EditPreferencesView(
                    selectedMood: $selectedMood,
                    selectedBudget: $selectedBudget,
                    selectedDistance: $selectedDistance
                )
            }
        }
    }
}

struct DestinationTitle: View {
    var body: some View {
        Text("Destination Suggestions")
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
}

struct EditButton: View {
    @Binding var isEditing: Bool

    var body: some View {
        Button {
            withAnimation {
                isEditing.toggle() // Toggle editing preferences
            }

        } label: {
            Text("Edit")
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct DestinationProfiles: View {
    @Binding var selectedTab: Int
    let destinations: [DestinationProfile] // Receiving the mock data here

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(destinations, id: \.name) { destination in
                    NavigationLink(
                        destination: ActivityView(destination: destination.name, selectedTab: $selectedTab)
                    ) {
                        DestinationProfileCard(profile: destination)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

struct EditPreferencesView: View {
    @Binding var selectedMood: String
    @Binding var selectedBudget: String
    @Binding var selectedDistance: Double

    let moods = ["Relaxed", "Adventurous", "Cultural"]
    let budgets = ["Cheap", "Moderate", "Luxury"]

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Edit Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Divider()

                // Mood Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mood")
                        .font(.headline)
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood).tag(mood)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)

                // Budget Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Budget")
                        .font(.headline)
                    Picker("Budget", selection: $selectedBudget) {
                        ForEach(budgets, id: \.self) { budget in
                            Text(budget).tag(budget)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)

                // Distance Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Distance")
                        .font(.headline)
                    Slider(value: $selectedDistance, in: 10...500, step: 10) {
                        Text("Distance: \(Int(selectedDistance)) km")
                    }
                    Text("\(Int(selectedDistance)) km")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                Spacer()

                // Done Button
                Button(action: {
                    // Dismiss the sheet
                }) {
                    Text("Done")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

struct DestinationProfileCard: View {
    let profile: DestinationProfile

    var body: some View {
        VStack(alignment: .leading) {
            // Image
            Image(profile.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipped()
                .cornerRadius(15)

            // Details
            VStack(alignment: .leading, spacing: 5) {
                Text(profile.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(profile.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(15)
    }
}


#Preview {
    NavigationStack {
        DestinationView(selectedTab: .constant(1))
    }
}

