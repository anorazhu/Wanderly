import SwiftUI
import FirebaseFirestore

struct ActivityView: View {
    var destination: String
    @Binding var selectedTab: Int
    @State private var activities: [Activity] = [] // Activities fetched dynamically
    @State private var selectedActivities: Set<String> = [] // Track selected activities
    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            VStack {
                // Destination Name
                Text(destination)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top], 20)

                // City Image Placeholder
                Image("Paris")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding([.horizontal], 20)
                    .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)

                // Activities Header
                Text("Activities")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 20)

                // Activities Grid
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                        ForEach(activities, id: \.id) { activity in
                            ActivityCard(activity: activity, selectedActivities: $selectedActivities)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 300)

                Spacer()

                // Navigation Button to Bucket List
                NavigationLink(destination: BucketListView(selectedTab: $selectedTab)) {
                    Text("Plan Activities!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding([.horizontal, .bottom], 20)
            }
            .background(Color(.systemBackground))
            .task {
                await fetchActivities(for: destination)
            }
        }
    }

    // Fetch activities from the API or hardcoded data
    private func fetchActivities(for destination: String) async {
        // Simulate API call - replace this with your actual API logic or database fetching
        let sampleActivities = Activity.sampleActivities

        // Filter the activities based on the destination
        let filteredActivities = sampleActivities.filter { activity in
            activity.name.lowercased().contains(destination.lowercased()) // Simple filtering
        }

        // Update activities list
        await MainActor.run {
            activities = filteredActivities.isEmpty ? sampleActivities : filteredActivities
        }
    }

    // Save selected activities to Firestore
    private func saveActivitiesToFirestore() {
        for activity in activities {
            let data: [String: Any] = [
                "name": activity.name,
                "description": activity.description ?? "",
                "latitude": activity.geoCode.latitude,
                "longitude": activity.geoCode.longitude,
                "destination": destination
            ]
            db.collection("activities").addDocument(data: data) { error in
                if let error = error {
                    print("❌ Error saving activity: \(error.localizedDescription)")
                } else {
                    print("✅ Activity saved successfully.")
                }
            }
        }
    }
}

// Activity Card View
struct ActivityCard: View {
    let activity: Activity
    @Binding var selectedActivities: Set<String> // Pass selectedActivities binding

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(activity.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .frame(width:150, height: 80)

                    // Safely unwrap the optional description
                    Text(activity.description ?? "No description available")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                .padding(.top)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

                // Checkbox (or Button)
                Button(action: {
                    toggleSelection(for: activity.id ?? "")
                }) {
                    Image(systemName: selectedActivities.contains(activity.id ?? "") ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 30)
                        .padding(10)
                    
                }
                
            }
        }
    }

    private func toggleSelection(for activityId: String) {
        if selectedActivities.contains(activityId) {
            selectedActivities.remove(activityId)
        } else {
            selectedActivities.insert(activityId)
        }
    }
}


// Preview
#Preview {
    ActivityView(destination: "Paris", selectedTab: .constant(1))
}
