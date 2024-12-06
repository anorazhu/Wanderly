import SwiftUI
import MapKit

struct BucketListDetailView: View {
    let city: BucketListCity
    @Binding var selectedTab: Int
    @State private var activities: [Activity] = [] // Activities fetched dynamically
    @State private var region: MKCoordinateRegion
    @State private var isActivitiesExpanded: Bool = false

    init(city: BucketListCity, selectedTab: Binding<Int>) {
        self.city = city
        self._selectedTab = selectedTab
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Map Section
            Map(coordinateRegion: $region, annotationItems: activities) { activity in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: activity.geoCode.latitude, longitude: activity.geoCode.longitude)) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                        Text(activity.name)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            // Overlay: Activities and Details Section
            VStack(spacing: 0) {
                // Top Section with City Name
                VStack {
                    Text("Travel Destination")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    HStack {
                        Text("City: \(city.name)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()

                        // Collapsible Activities Container
                        Button(action: {
                            withAnimation {
                                isActivitiesExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text("Activities: \(activities.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Image(systemName: isActivitiesExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
                .background(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

                // Activities List (only shown when expanded)
                if isActivitiesExpanded {
                    ExpandableActivitiesView(
                        activities: activities,
                        city: city.name,
                        selectedTab: $selectedTab,
                        isExpanded: $isActivitiesExpanded
                    )
                    .transition(.slide)
                    .frame(maxWidth: 300) // Set the width of the expanded view
                    .background(Color.white.opacity(0.5)) // Set the background color with opacity
                    .cornerRadius(10)
                    .offset(x: 100) // Move the view to the right-hand side
                    .padding() // Optional: adjust the padding as needed
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6))
        .task {
            loadMockActivities(for: city)
        }
    }

    // Instead of fetching from an API, use mock data
    private func loadMockActivities(for city: BucketListCity) {
        // Mock data for activities
        let mockActivities = [
            Activity(id: "1", name: "Eiffel Tower Visit", description: "Visit the iconic Eiffel Tower", geoCode: Activity.GeoCode(latitude: 48.8584, longitude: 2.2945), price: nil, rating: 4.8, pictures: nil),
            Activity(id: "2", name: "Louvre Museum", description: "Explore the world-famous museum", geoCode: Activity.GeoCode(latitude: 48.8606, longitude: 2.3376), price: nil, rating: 4.7, pictures: nil),
            Activity(id: "3", name: "Seine River Cruise", description: "Take a relaxing cruise on the Seine River", geoCode: Activity.GeoCode(latitude: 48.8566, longitude: 2.3522), price: nil, rating: 4.6, pictures: nil),
            Activity(id: "4", name: "Montmartre Walking Tour", description: "Explore the artistic district of Montmartre", geoCode: Activity.GeoCode(latitude: 48.8867, longitude: 2.3431), price: nil, rating: 4.5, pictures: nil)
        ]
        
        // Update the activities array with the mock data
        self.activities = mockActivities
    }
}




// Example Usage in Preview
#Preview {
    BucketListDetailView(
        city: BucketListCity(name: "Paris", image: "paris", description: "The city of love and lights.", latitude: 48.8566, longitude: 2.3522),
        selectedTab: .constant(1)
    )
}
