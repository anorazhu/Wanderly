import SwiftUI
import Firebase
import FirebaseAuth

import SwiftUI
import Firebase
import FirebaseAuth

struct WelcomeView: View {
    @Binding var selectedTab: Int
    @State private var username = ""
    @State private var currentStep = 0 // Track the current step
    @State private var isHeaderExpanded = true // Track header size
    @State private var hasDestinationInMind: Bool? = nil // Track user selection (Yes/No)
    @State private var completedSteps: Set<Int> = [] // Track steps where "Next" has been clicked
    @State private var selectedMood: String = "Relaxed" // Picker for mood
    @State private var selectedBudget: String = "Moderate" // Picker for budget
    @State private var selectedDistance: Double = 50.0 // Slider for distance
    @State private var selectedCity: City? // Store selected city
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header Section
                    HeaderView(
                        username: $username,
                        isHeaderExpanded: $isHeaderExpanded,
                        geometry: geometry
                    )
                    
                    Divider()
                    
                    // Scrollable Steps
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 30) {
                                Step1View(
                                    hasDestinationInMind: $hasDestinationInMind,
                                    currentStep: $currentStep,
                                    isHeaderExpanded: $isHeaderExpanded,
                                    completedSteps: $completedSteps,
                                    proxy: proxy
                                )
                                
                                if hasDestinationInMind == true, currentStep >= 1 {
                                    Step2View(
                                        selectedCity: $selectedCity,
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 2 {
                                    Step3View(
                                        selectedMood: $selectedMood,
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 3 {
                                    Step4View(
                                        selectedBudget: $selectedBudget,
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 4 {
                                    Step5View(
                                        selectedTab: $selectedTab,
                                        hasDestinationInMind: hasDestinationInMind,
                                        selectedDistance: $selectedDistance,
                                        selectedMood: $selectedMood,
                                        selectedBudget: $selectedBudget,
                                        selectedCity: $selectedCity
                                    )
                                }
                            }
                        }
                        .onChange(of: currentStep) {
                            withAnimation {
                                proxy.scrollTo(currentStep, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .onAppear {
                fetchUsername()
            }
        }
    }
    
    func fetchUsername() {
        guard let user = Auth.auth().currentUser else {
            username = "Guest"
            return
        }
        username = user.displayName ?? "User"
    }
}

struct HeaderView: View {
    @Binding var username: String
    @Binding var isHeaderExpanded: Bool
    var geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 10) {
            if isHeaderExpanded {
                VStack {
                    Text("Welcome! ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
//                    + Text("\(username)!")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.blue)
                }
            }
            
            Text("Plan your next travel destination")
                .font(isHeaderExpanded ? .title2 : .headline)
                .foregroundColor(.black)
            
            Image("cloud") // Cloud Image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: geometry.size.width * 0.8, maxHeight: geometry.size.height * 0.3)
                .clipShape(RoundedRectangle(cornerRadius: 40)) // Rounded corners
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .frame(height: isHeaderExpanded ? geometry.size.height * 0.7 : geometry.size.height * 0.4)
        .animation(.easeInOut, value: isHeaderExpanded)
        .zIndex(1)
    }
}

struct Step1View: View {
    @Binding var hasDestinationInMind: Bool?
    @Binding var currentStep: Int
    @Binding var isHeaderExpanded: Bool
    @Binding var completedSteps: Set<Int> // Added binding for resetting
    let proxy: ScrollViewProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Do You Have a Destination in Mind?")
                .font(.headline)
            
            HStack {
                Button("Yes") {
                    withAnimation {
                        resetSteps()
                        hasDestinationInMind = true
                        currentStep = 1
                        isHeaderExpanded = false
                        proxy.scrollTo(1, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(hasDestinationInMind == true ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("No") {
                    withAnimation {
                        resetSteps()
                        hasDestinationInMind = false
                        currentStep = 2
                        isHeaderExpanded = false
                        proxy.scrollTo(2, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(hasDestinationInMind == false ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .id(0)
    }
    
    private func resetSteps() {
        currentStep = 0
        completedSteps.removeAll()
        isHeaderExpanded = true
    }
}

struct Step2View: View {
    @Binding var selectedCity: City?
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    @State private var cityName: String = "" // User input for city search
    @State private var cityViewModel = CityViewModel() // ViewModel for fetching cities

    var body: some View {
        VStack(spacing: 15) {
            Text("Select the City you want to explore!")
                .font(.headline)

            // Search Bar for City Input
            TextField("Enter city name...", text: $cityName, onCommit: {
                Task {
                    await cityViewModel.getData(for: cityName)
                }
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: cityName) { newValue in
                if newValue.isEmpty {
                    cityViewModel.cities = [] // Clear results if input is cleared
                }
            }

            // Display Search Results
            if cityViewModel.isLoading {
                ProgressView("Searching for cities...")
                    .padding()
            } else if cityViewModel.cities.isEmpty {
                Text("No cities found. Please try a different name.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(cityViewModel.cities, id: \.id) { city in
                            Button(action: {
                                selectCity(city)
                            }) {
                                HStack {
                                    Text(city.name)
                                    Spacer()
                                    if selectedCity == city {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(selectedCity == city ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Next Button
            Button("Next") {
                if selectedCity != nil {
                    withAnimation {
                        currentStep = 2
                        completedSteps.insert(1)
                        proxy.scrollTo(2, anchor: .bottom)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(selectedCity == nil ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(selectedCity == nil) // Disable if no city selected
        }
        .padding()
        .id(1)
    }

    // Save selected city to binding
    private func selectCity(_ city: City) {
        selectedCity = city
        print("Selected city: \(city.name), Latitude: \(city.latitude), Longitude: \(city.longitude)")
    }
}

struct Step3View: View {
    @Binding var selectedMood: String
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Would you like your trip to be...")
                .font(.headline)
            
            Picker("Mood", selection: $selectedMood) {
                Text("Relaxed").tag("Relaxed")
                Text("Adventurous").tag("Adventurous")
                Text("Cultural").tag("Cultural")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if !completedSteps.contains(2) {
                Button("Next") {
                    withAnimation {
                        currentStep = 3
                        completedSteps.insert(2)
                        proxy.scrollTo(3, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .id(2)
    }
}

struct Step4View: View {
    @Binding var selectedBudget: String
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What is your Budget?")
                .font(.headline)
            
            Picker("Budget", selection: $selectedBudget) {
                Text("Cheap").tag("Cheap")
                Text("Moderate").tag("Moderate")
                Text("Luxury").tag("Luxury")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if !completedSteps.contains(3) {
                Button("Next") {
                    withAnimation {
                        currentStep = 4
                        completedSteps.insert(3)
                        proxy.scrollTo(4, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .id(3)
    }
}

struct Step5View: View {
    @Binding var selectedTab: Int
    var hasDestinationInMind: Bool?
    @Binding var selectedDistance: Double
    @Binding var selectedMood: String
    @Binding var selectedBudget: String
    @Binding var selectedCity: City?

    var body: some View {
        VStack(spacing: 20) {
            if hasDestinationInMind == true {
                if let city = selectedCity {
                    Text("Explore Activities in \(city.name)!")
                        .font(.headline)
                } else {
                    Text("No city selected. Please select a city to explore activities.")
                        .foregroundColor(.red)
                        .font(.headline)
                }
            } else {
                Text("Explore cities within \(Int(selectedDistance)) km around your location")
                    .font(.headline)
            }
            
            if hasDestinationInMind == false {
                // Slider for radius when exploring nearby cities
                Slider(value: $selectedDistance, in: 1...100, step: 1) {
                    Text("Distance: \(Int(selectedDistance)) km")
                }
                .padding()
            }

            NavigationLink {
                if hasDestinationInMind == true, let city = selectedCity {
                    // Navigate to ActivityView for selected city
                    ActivityView(
                        destination: city.name,
                        latitude: city.latitude,
                        longitude: city.longitude,
                        mood: Mood(rawValue: selectedMood),
                        budget: selectedBudget,
                        radius: Int(selectedDistance),
                        selectedTab: $selectedTab
                    )
                } else {
                    // Navigate to DestinationView for nearby cities
                    DestinationView(
                        selectedTab: $selectedTab,
                        selectedMood: $selectedMood,
                        selectedBudget: $selectedBudget,
                        selectedDistance: $selectedDistance
                    )
                }
            } label: {
                Text(hasDestinationInMind == true ? "Explore Activities" : "Explore Cities")
            }
            .disabled(hasDestinationInMind == true && selectedCity == nil) // Disable button if no city is selected
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(hasDestinationInMind == true && selectedCity == nil ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}


#Preview {
    WelcomeView(selectedTab: .constant(0))
}
