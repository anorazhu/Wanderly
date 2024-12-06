import MapKit
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
                                Text(activity.name)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                if let description = activity.description {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                
                                if let price = activity.price?.amount, let currency = activity.price?.currencyCode {
                                    Text("Price: \(price) \(currency)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                
                                if let rating = activity.rating {
                                    Text("Rating: \(String(format: "%.1f", rating))/5")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                
                                if let pictures = activity.pictures, let pictureURL = pictures.first {
                                    AsyncImage(url: URL(string: pictureURL)) { image in
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
                            .frame(maxWidth: .infinity) // Set the width of each card to fill the available space
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        }

                        NavigationLink(destination: ActivityView(destination: city, selectedTab: $selectedTab)) {
                            Text("Add More Activities?")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity) // Make button width the same
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                .frame(maxHeight: 200) // Make sure the scroll view uses all available space
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .frame(maxWidth: .infinity) // Ensures the expandable view fills the screen width
    }
}

#Preview {
    // Sample data for activities
    let city = "Paris"
    let sampleActivities = [
        Activity(
            id: "1",
            name: "Eiffel Tower",
            description: "Visit the iconic Eiffel Tower.",
            geoCode: Activity.GeoCode(latitude: 48.8584, longitude: 2.2945),
            price: Activity.Price(amount: "25", currencyCode: "EUR"),
            rating: 4.8,
            pictures: ["https://example.com/eiffel.jpg"]
        ),
        Activity(
            id: "2",
            name: "Louvre Museum",
            description: "Explore the world's largest art museum.",
            geoCode: Activity.GeoCode(latitude: 48.8606, longitude: 2.3376),
            price: Activity.Price(amount: "15", currencyCode: "EUR"),
            rating: 4.7,
            pictures: ["https://example.com/louvre.jpg"]
        ),
        Activity(
            id: "3",
            name: "Seine River Cruise",
            description: "Take a relaxing cruise along the Seine.",
            geoCode: Activity.GeoCode(latitude: 48.8566, longitude: 2.3522),
            price: nil,
            rating: 4.5,
            pictures: nil
        )
    ]

    // Use a Binding for `isExpanded`
    @State var isExpanded = true

    // Return the preview
    ExpandableActivitiesView(activities: sampleActivities, city: city, selectedTab: .constant(1), isExpanded: $isExpanded)
}
