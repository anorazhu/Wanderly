import SwiftUI

struct BucketListView: View {
    @Binding var selectedTab: Int
    @State private var bucketList: [BucketListCity] = [
            BucketListCity(name: "Paris", image: "paris", description: "The city of love and lights.", latitude: 48.8566, longitude: 2.3522),
            BucketListCity(name: "New York", image: "new_york", description: "The Big Apple.", latitude: 40.7128, longitude: -74.0060),
            BucketListCity(name: "Tokyo", image: "tokyo", description: "Explore the vibrant culture.", latitude: 35.6762, longitude: 139.6503),
            BucketListCity(name: "Sydney", image: "sydney", description: "Home of the iconic Opera House.", latitude: -33.8688, longitude: 151.2093),
            BucketListCity(name: "Cape Town", image: "cape_town", description: "A stunning coastal city.", latitude: -33.9249, longitude: 18.4241),
            BucketListCity(name: "Rome", image: "rome", description: "The eternal city full of history.", latitude: 41.9028, longitude: 12.4964)
        ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Travel Bucket List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)

                Divider()

                // Bucket List Grid
                ScrollView {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                                        ForEach(bucketList) { city in
                                            NavigationLink {
                                                BucketListDetailView(city: city, selectedTab: $selectedTab)
                                            } label: {
                                                BucketListCard(city: city)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                }
            }
            .navigationBarBackButtonHidden()
            .background(Color(.systemBackground))
        }
    }
}

// City Card
struct BucketListCard: View {
    let city: BucketListCity

    var body: some View {
        VStack {
            // City Image
            Image("Paris")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
                .clipped()
                .cornerRadius(10)
                .padding(.horizontal, 5)

            // City Name
            Text(city.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(1)

            // City Description
            Text(city.description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 5)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    BucketListView(selectedTab: .constant(1))
}
