import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ActivityCard: View {
    let activity: Activity
    @Binding var selectedActivities: Set<Activity>
    var destination: String
    var mood: Mood?
    var budget: String

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                // Activity Image
                if let imageURL = activity.pictures?.first, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 150)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 120, height: 150)
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                }

                // Activity Name
                Text(activity.name ?? "Unknown Activity")
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                // Activity Description
                Text(activity.shortDescription ?? "No description available.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)

            // Toggle Button
            Button(action: {
                toggleSelection(for: activity)
            }) {
                Image(systemName: selectedActivities.contains(activity) ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(selectedActivities.contains(activity) ? .questionButton : .gray)
                    .padding()
            }
        }
    }

    // Toggle selection logic
    private func toggleSelection(for activity: Activity) {
        if selectedActivities.contains(activity) {
            selectedActivities.remove(activity)
            removeFromDatabase(activity)
        } else {
            selectedActivities.insert(activity)
            saveToDatabase(activity)
        }
    }

    // Save activity to Firestore
    private func saveToDatabase(_ activity: Activity) {
        Task {
            let db = Firestore.firestore()
            let userId = Auth.auth().currentUser?.uid ?? "guest"
            let userRef = db.collection("users").document(userId)

            let activityData: [String: Any] = [
                "id": activity.id,
                "name": activity.name,
                "description": activity.shortDescription ?? "",
                "destination": destination,
                "latitude": activity.geoCode.latitude,
                "longitude": activity.geoCode.longitude,
                "mood": mood?.rawValue ?? "",
                "budget": budget,
                "timestamp": Timestamp()
            ]

            do {
                try await userRef.collection("plannedActivities").addDocument(data: activityData)
            } catch {
                print("Error saving activity: \(error.localizedDescription)")
            }
        }
    }

    // Remove activity from Firestore
    private func removeFromDatabase(_ activity: Activity) {
        Task {
            let db = Firestore.firestore()
            let userId = Auth.auth().currentUser?.uid ?? "guest"
            let userRef = db.collection("users").document(userId)

            let query = userRef.collection("plannedActivities").whereField("id", isEqualTo: activity.id)
            do {
                let snapshot = try await query.getDocuments()
                for document in snapshot.documents {
                    try await document.reference.delete()
                }
            } catch {
                print("Error removing activity: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    @State var selectedActivities: Set<Activity> = [] // State for tracking selected activities

    ActivityCard(
        activity: Activity.sampleActivities[0], // Provide a sample activity from the mock data
        selectedActivities: $selectedActivities, // Pass the state as a binding
        destination: "Paris", // Mock destination
        mood: .relaxed, // Mock mood
        budget: "Moderate" // Mock budget
    )
}
