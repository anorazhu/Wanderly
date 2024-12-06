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
                                    completedSteps: $completedSteps, // Pass completed steps
                                    proxy: proxy
                                )
                                
                                if hasDestinationInMind == true, currentStep >= 1 {
                                    Step2View(
                                         // Pass ViewModel
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 2 {
                                    Step3View(
                                        selectedMood: $selectedMood, // Bind to state
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 3 {
                                    Step4View(
                                        selectedBudget: $selectedBudget, // Bind to state
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 4 {
                                    Step5View(
                                        selectedTab: $selectedTab,
                                        hasDestinationInMind: hasDestinationInMind,
                                        selectedDistance: $selectedDistance // Bind to state
                                    )
                                }
                            }
                        }
                        .onChange(of: currentStep) { newStep in
                            withAnimation {
                                proxy.scrollTo(newStep, anchor: .bottom)
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
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    
    @State private var cityInput = "" // Track city input
    @State private var countryInput = "" // Track country input
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Select a Continent, Country or City you want to explore!")
                .font(.headline)
            
            SelectionView()
            
            if !completedSteps.contains(1) {
                Button("Next") {
                    withAnimation {
                        currentStep = 2
                        completedSteps.insert(1)
                        proxy.scrollTo(2, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
//        .task {
//            await destinationViewModel.fetchCityByName(namePrefix: cityInput)
//        }
        .id(1)
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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How far are you willing to travel?")
                .font(.headline)
            
            Slider(value: $selectedDistance, in: 1...100, step: 1) {
                Text("Distance: \(Int(selectedDistance)) km")
            }
            .padding()
            
            NavigationLink {
                if hasDestinationInMind == true {
                    ActivityView(destination: "", selectedTab: $selectedTab)
                } else {
                    DestinationView(selectedTab: $selectedTab)
                }
            } label: {
                Text("Explore!")
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .id(4)
    }
}

#Preview {
    WelcomeView(selectedTab: .constant(0))
}
