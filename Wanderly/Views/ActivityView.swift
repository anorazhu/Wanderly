
import SwiftUI

struct ActivityView: View {
    var destination: String
    var latitude: Double
    var longitude: Double
    var mood: Mood? // Accept mood
    var budget: String // Accept budget
    var radius: Int // Accept radius (converted from distance)
    @Binding var selectedTab: Int
    @State private var selectedActivities: Set<String> = [] // Track selected activities
    @State private var viewModel = ActivityViewModel() // Dynamically fetch activities

    var body: some View {
        NavigationStack {
            VStack {
                // Similar UI code here...

                if viewModel.isLoading {
                    ProgressView("Loading Activities...")
                } else if viewModel.filteredActivities.isEmpty {
                    Text("No activities available.")
                        .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                            ForEach(viewModel.filteredActivities, id: \.id) { activity in
                                ActivityCard(activity: activity, selectedActivities: $selectedActivities)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 300)
                }

                Spacer()
            }
            .task {
                await viewModel.fetchActivities(latitude: latitude, longitude: longitude, radius: radius, mood: mood)
            }
        }
    }
}


struct BucketListView: View {
    @Binding var selectedTab: Int

    var body: some View {
        Text("Bucket List View")
            .font(.title)
            .padding()
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
