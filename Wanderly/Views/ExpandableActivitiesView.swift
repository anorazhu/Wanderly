import SwiftUI

struct ExpandableActivitiesView: View {
    let activities: [Activity]
    let city: String
    @Binding var selectedTab: Int
    @Binding var isExpanded: Bool

    var body: some View {
        VStack {
            if isExpanded {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(activities, id: \.id) { activity in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(activity.name ?? "Unknown Activity")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                if let description = activity.shortDescription {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .lineLimit(2)
                                }
                                
                                if let price = activity.price?.amount, let currency = activity.price?.currencyCode {
                                    Text("Price: \(price) \(currency)")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                                
                                if let pictures = activity.pictures, let pictureURL = pictures.first, let url = URL(string: pictureURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 300) // Ensure the scroll view fits well
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .frame(maxWidth: .infinity)
    }
}

// Preview for ExpandableActivitiesView
#Preview {
    let sampleActivities = Activity.sampleActivities
    @State var isExpanded = true
    ExpandableActivitiesView(activities: sampleActivities, city: "Paris", selectedTab: .constant(1), isExpanded: $isExpanded)
}
