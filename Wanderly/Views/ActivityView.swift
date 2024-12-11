import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ActivityView: View {
    var destination: String
    var latitude: Double
    var longitude: Double
    var mood: Mood? // Accept mood
    var budget: String // Accept budget
    @Binding var selectedTab: Int
    @State private var selectedActivities: Set<Activity> = [] // Track selected activities
    @State private var viewModel = ActivityViewModel() // Dynamically fetch activities
    @State private var isSaving = false // Track saving state
    @State private var navigateToBucketList = false // Navigation state
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                Text("Explore Activities in \(destination)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Divider()
                
                // Activity Filters Display
                HStack {
                    VStack(alignment: .leading) {
                        Text("Mood: \(mood?.rawValue ?? "N/A")")
                            .font(.subheadline)
                        Text("Budget: \(budget)")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Activities List
                if viewModel.isLoading {
                    ProgressView("Loading Activities...")
                        .padding()
                } else if viewModel.filteredActivities.isEmpty {
                    Text("No activities available.")
                        .foregroundStyle(.gray)
                        .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                            ForEach(viewModel.filteredActivities, id: \.id) { activity in
                                ActivityCard(
                                    activity: activity,
                                    selectedActivities: $selectedActivities,
                                    destination: destination,
                                    mood: mood,
                                    budget: budget
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Navigation Link for Bucket List
                NavigationLink {
                    BucketListView(selectedTab: $selectedTab)
                        .onAppear {
                                    selectedTab = 1 // Change the tab to Bucket List (tab 1)
                                }
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.gray)
                            .cornerRadius(10)
                    } else {
                        Text("Save!")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(selectedActivities.isEmpty ? .button.opacity(0.4) : .button)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                    }
                }
                .disabled(selectedActivities.isEmpty || isSaving) // Disable button during saving or when no activities are selected
                .onTapGesture {
                    if !isSaving && !selectedActivities.isEmpty {
                        saveToBucketList() // Save the bucket list and navigate after
                    }
                }

            }
            
        }
        .padding()
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchActivities(latitude: latitude, longitude: longitude, mood: mood)
        }
    }
    private func saveToBucketList() {
        guard !selectedActivities.isEmpty else { return }
        isSaving = true
        
        let city = BucketListCity(
            name: destination,
            image: "default_image", // Placeholder image
            description: "Selected activities in \(destination).",
            latitude: latitude,
            longitude: longitude,
            activities: Array(selectedActivities)
        )
        
        Task {
            await BucketListViewModel.saveCity(city: city)
            isSaving = false
            navigateToBucketList = true // Navigate to Bucket List view
        }
    }
}


#Preview {
    ActivityView(
        destination: "Paris",
        latitude: 48.8578,
        longitude: 2.3569,
        mood: .relaxed, // Example Mood
        budget: "Moderate", // Example Budget
        
        selectedTab: .constant(1)
    )
}
