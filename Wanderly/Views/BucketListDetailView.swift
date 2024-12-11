import SwiftUI
import MapKit

struct BucketListDetailView: View {
    let city: BucketListCity
    @Binding var selectedTab: Int
    @State private var activities: [Activity] = []
    @State private var region: MKCoordinateRegion
    @State private var selectedActivity: Activity? // Tracks the currently selected activity for the popup
    @State private var showPopup: Bool = false // Tracks whether the popup is visible

    init(city: BucketListCity, selectedTab: Binding<Int>) {
        self.city = city
        self._selectedTab = selectedTab
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
        self._activities = State(initialValue: city.activities ?? [])
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Panel
            HStack(alignment: .bottom) {
                Text(city.name)
                    .font(.title3)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                
                Spacer()

                Text("Activities: \(activities.count)")
                    .font(.subheadline)
                    .foregroundStyle(.button)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.white.opacity(0.6))
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

            ZStack {
                // Map Section
                Map(coordinateRegion: $region, annotationItems: activities) { activity in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: activity.geoCode.latitude, longitude: activity.geoCode.longitude)) {
                        Button {
                            selectedActivity = activity
                            withAnimation {
                                showPopup = true
                            }
                        } label: {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.red)
                                    .frame(width: 30, height: 30)
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)

                // Popup for Activity Details
                if showPopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showPopup = false
                                }
                            }

                        VStack(spacing: 20) {
                            if let pictureURL = selectedActivity?.pictures?.first, let url = URL(string: pictureURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 200)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            }

                            Text(selectedActivity?.name ?? "Unknown Activity")
                                .font(.headline)
                                .fontWeight(.bold)

                            Text(selectedActivity?.shortDescription ?? "No description available.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)

                            if let price = selectedActivity?.price {
                                Text("Price: \(price.amount ?? "N/A") \(price.currencyCode ?? "")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }

                            Button {
                                withAnimation {
                                    showPopup = false
                                }
                            } label: {
                                Text("Close")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.button)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(maxWidth: 300) // Limit the popup width
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color(.systemGray6))
        }
    }
}

// Preview for BucketListDetailView
#Preview {
    BucketListDetailView(
        city: BucketListCity(
            id: "123", name: "Paris",
            image: "paris",
            description: "The city of love and lights.",
            latitude: 48.8566,
            longitude: 2.3522,
            activities: [
                Activity(id: "1", name: "Eiffel Tower", shortDescription: "Visit the iconic Eiffel Tower.", geoCode: GeoCode(latitude: 48.8584, longitude: 2.2945), price: Price(amount: "25.00", currencyCode: "EUR"), pictures: ["https://example.com/eiffel_tower.jpg"], bookingLink: nil, minimumDuration: nil),
                Activity(id: "2", name: "Louvre Museum", shortDescription: "Explore the world's largest art museum.", geoCode: GeoCode(latitude: 48.8606, longitude: 2.3376), price: Price(amount: "15.00", currencyCode: "EUR"), pictures: ["https://example.com/louvre.jpg"], bookingLink: nil, minimumDuration: nil)
            ]
        ),
        selectedTab: .constant(1)
    )
}
