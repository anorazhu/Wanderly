import SwiftUI
import FirebaseFirestore

struct BucketListView: View {
    @Binding var selectedTab: Int
    @State private var bucketList: [BucketListCity] = [] // Store cities fetched from Firestore
    @State private var isLoading = true // Loading state

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Travel Bucket List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Divider()

                if isLoading {
                    ProgressView("Loading Bucket List...")
                        .padding()
                } else if bucketList.isEmpty {
                    Text("Your bucket list is empty.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
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
                    }
                }
            }
            .background(Color(.systemBackground))
            .onAppear(perform: fetchBucketList) // Fetch data when the view appears
        }
    }

    private func fetchBucketList() {
        let db = Firestore.firestore()
        db.collection("cities")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("😡 Error fetching bucket list: \(error.localizedDescription)")
                    isLoading = false
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No data found in bucket list.")
                    isLoading = false
                    return
                }

                self.bucketList = documents.compactMap { doc in
                    try? doc.data(as: BucketListCity.self)
                }
                print("✅ Successfully fetched \(self.bucketList.count) cities.")
                isLoading = false
            }
    }
}

// City Card
struct BucketListCard: View {
    let city: BucketListCity
    
    var body: some View {
        VStack {
            // City Image
            CityImageView(cityName: city.name)
                .frame(height: 150)
                .cornerRadius(10)
            
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


// Preview
#Preview {
    BucketListView(selectedTab: .constant(1))
}
