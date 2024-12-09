import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    @Binding var selectedActivities: Set<String>

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(activity.name ?? "Unnamed Activity")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .padding(.top)

                    Text(activity.shortDescription ?? "No description available")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(3)

                    if let price = activity.price {
                        Text("Price: \(price.amount ?? "N/A") \(price.currencyCode ?? "")")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

                // Select/Deselect Button
                Button(action: { toggleSelection(for: activity.id) }) {
                    Image(systemName: selectedActivities.contains(activity.id) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.blue)
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

// Preview for ActivityCard
#Preview {
    let sampleActivity = Activity.sampleActivities[0]
    @State var selectedActivities: Set<String> = []
    ActivityCard(activity: sampleActivity, selectedActivities: $selectedActivities)
}
