//import SwiftUI
//import MapKit
//
//struct BucketListDetailView: View {
//    let city: BucketListCity
//    @Binding var selectedTab: Int
//    @State private var activities: [Activity] = []
//    @State private var region: MKCoordinateRegion
//    @State private var isActivitiesExpanded: Bool = false
//
//    init(city: BucketListCity, selectedTab: Binding<Int>) {
//        self.city = city
//        self._selectedTab = selectedTab
//        self._region = State(initialValue: MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        ))
//    }
//
//    var body: some View {
//        ZStack(alignment: .top) {
//            // Map Section
//            Map(coordinateRegion: $region, annotationItems: activities) { activity in
//                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: activity.geoCode.latitude, longitude: activity.geoCode.longitude)) {
//                    VStack {
//                        Image(systemName: "mappin.circle.fill")
//                            .resizable()
//                            .foregroundColor(.red)
//                            .frame(width: 30, height: 30)
//                        Text(activity.name ?? "Unknown")
//                            .font(.caption)
//                            .foregroundColor(.black)
//                            .padding(5)
//                            .background(Color.white)
//                            .cornerRadius(5)
//                            .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
//                    }
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//
//            // Overlay
//            VStack(spacing: 0) {
//                VStack {
//                    Text("Travel Destination")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .padding(.top, 10)
//                    
//                    HStack {
//                        Text("City: \(city.name)")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        Spacer()
//
//                        Button(action: {
//                            withAnimation { isActivitiesExpanded.toggle() }
//                        }) {
//                            HStack {
//                                Text("Activities: \(activities.count)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                                Image(systemName: isActivitiesExpanded ? "chevron.up" : "chevron.down")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    Divider()
//                }
//                .background(Color.white)
//                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
//
//                // Activities List
//                if isActivitiesExpanded {
//                    ExpandableActivitiesView(
//                        activities: activities,
//                        city: city.name,
//                        selectedTab: $selectedTab,
//                        isExpanded: $isActivitiesExpanded
//                    )
//                    .transition(.slide)
//                    .frame(maxWidth: 300)
//                    .background(Color.white.opacity(0.5))
//                    .cornerRadius(10)
//                    .padding()
//                }
//                Spacer()
//            }
//        }
//        .background(Color(.systemGray6))
//        .task {
//            loadMockActivities(for: city)
//        }
//    }
//
//    private func loadMockActivities(for city: BucketListCity) {
//        let filteredActivities = Activity.sampleActivities.filter { activity in
//            guard let name = activity.name else { return false }
//            return name.contains(city.name)
//        }
//        self.activities = filteredActivities.isEmpty ? Activity.sampleActivities : filteredActivities
//    }
//}
//
//// Preview for BucketListDetailView
//#Preview {
//    BucketListDetailView(
//        city: BucketListCity(
//            id: "123", name: "Paris",
//            image: "paris",
//            description: "The city of love and lights.",
//            latitude: 48.8566,
//            longitude: 2.3522
//        ),
//        selectedTab: .constant(1)
//    )
//}
