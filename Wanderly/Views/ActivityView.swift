import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ActivityView: View {
    var destination: String
    var latitude: Double
    var longitude: Double
    var mood: Mood? // Accept mood
    var budget: String // Accept budget
    var radius: Int // Accept radius (converted from distance)
    @Binding var selectedTab: Int
    @State private var selectedActivities: Set<Activity> = [] // Track selected activities
    @State private var viewModel = ActivityViewModel() // Dynamically fetch activities
    @State private var isSaving = false // Track saving state
    @State private var navigateToBucketList = false // Navigation state

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                Text("Explore Activities in \(destination)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Divider()

                // Activity Filters Display
                HStack {
                    VStack(alignment: .leading) {
                        Text("Mood: \(mood?.rawValue ?? "N/A")")
                            .font(.subheadline)
                        Text("Budget: \(budget)")
                            .font(.subheadline)
                        Text("Radius: \(radius) km")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Divider()

                // Activities List
                if viewModel.isLoading {
                    ProgressView("Loading Activities...")
                        .padding()
                } else if viewModel.filteredActivities.isEmpty {
                    Text("No activities available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                            ForEach(viewModel.filteredActivities, id: \.id) { activity in
                                ActivityCard(
                                                                                                   activity: activity,
                                                                                                   selectedActivities: $selectedActivities,
                                                                                                   destination: destination,
                                                                                                   mood: mood,
                                                                                                   budget: budget,
                                                                                                   radius: radius
                                                                                               )
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()

                // Navigation Link for Bucket List
                NavigationLink(destination: BucketListView(selectedTab: $selectedTab), isActive: $navigateToBucketList) {
                    EmptyView()
                }

                // Button to Save and Navigate
                Button {
                    saveToBucketList()
                } label: {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Go to Bucket List")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(selectedActivities.isEmpty ? Color.gray : Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
                .disabled(selectedActivities.isEmpty || isSaving)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Activities")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchActivities(latitude: latitude, longitude: longitude, radius: radius, mood: mood)
            }
        }
    }

    /// Save the current destination and activities to the Bucket List
    private func saveToBucketList() {
        guard !selectedActivities.isEmpty else { return }
        isSaving = true

        let city = BucketListCity(
            name: destination,
            image: "default_image", // Placeholder image
            description: "Selected activities in \(destination).",
            latitude: latitude,
            longitude: longitude,
            activities: Array(selectedActivities)
        )

        Task {
            await BucketListViewModel.saveCity(city: city)
            isSaving = false
            navigateToBucketList = true // Navigate to Bucket List view
        }
    }
}

#Preview {
    ActivityView(
        destination: "Paris",
        latitude: 48.8578,
        longitude: 2.3569,
        mood: .relaxed, // Example Mood
        budget: "Moderate", // Example Budget
        radius: 50, // Example Radius in kilometers
        selectedTab: .constant(1)
    )
}
