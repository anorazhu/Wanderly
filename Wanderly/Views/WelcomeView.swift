import SwiftUI
import Firebase
import FirebaseAuth

struct WelcomeView: View {
    @Binding var selectedTab: Int
    @State private var username = ""
    @State private var currentStep = 1 // Start at step 1
    @State private var isHeaderExpanded = true // Track header size
    @State private var completedSteps: Set<Int> = [] // Track steps where "Next" has been clicked
    @State private var selectedMood: String = "Relaxed" // Picker for mood
    @State private var selectedBudget: String = "Moderate" // Picker for budget
    @State private var selectedCity: City?
    
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
                                    currentStep: $currentStep,
                                    isHeaderExpanded: $isHeaderExpanded,
                                    completedSteps: $completedSteps,
                                    proxy: proxy
                                )
                                
                                if currentStep >= 2 {
                                    Step2View(
                                        selectedCity: $selectedCity,
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 3 {
                                    Step3View(
                                        selectedMood: $selectedMood,
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        proxy: proxy
                                    )
                                }
                                
                                if currentStep >= 4 {
                                    Step4View(
                                        selectedBudget: $selectedBudget,
                                        currentStep: $currentStep,
                                        completedSteps: $completedSteps,
                                        selectedCity: $selectedCity,
                                        selectedMood: $selectedMood,
                                        selectedTab: $selectedTab,
                                        proxy: proxy
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
        }
    }
}

struct HeaderView: View {
    @Binding var username: String
    @Binding var isHeaderExpanded: Bool
    var geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 10) {
            if isHeaderExpanded {
                Text("Welcome! Let's Explore")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            
            Text("Plan your next travel destination")
                .font(isHeaderExpanded ? .title2 : .headline)
                .foregroundStyle(.black)
            
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
    @Binding var currentStep: Int
    @Binding var isHeaderExpanded: Bool
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Let's explore a city you have in mind!")
                .font(.headline)
                .padding()
            
            Button("Start") {
                withAnimation {
                    currentStep = 2
                    completedSteps.insert(1)
                    isHeaderExpanded = false
                    proxy.scrollTo(2, anchor: .bottom)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(.button)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .padding()
        .id(1)
    }
}

struct Step2View: View {
    @Binding var selectedCity: City?
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    
    @State private var enteredCityName = ""
    @State var cityViewModel = CityViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Enter a city to explore:")
                .font(.headline)
            
            TextField("City name", text: $enteredCityName, onCommit: {
                Task {
                    await cityViewModel.getData(for: enteredCityName)
                }
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if cityViewModel.isLoading {
                ProgressView("Loading cities...")
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(cityViewModel.cities, id: \.id) { city in

                            Button {
                                selectedCity = city
                            } label: {
                                HStack {
                                    Text(city.name)
                                    Spacer()
                                    if selectedCity == city {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding()
                                .background(selectedCity == city ? .button.opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            if !completedSteps.contains(2) {
                Button("Next") {
                    withAnimation {
                        currentStep = 3
                        completedSteps.insert(2)
                        proxy.scrollTo(3, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(selectedCity == nil ? .button.opacity(0.4) : .button)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .disabled(selectedCity == nil)
            }
        }
        .padding()
        .id(2)
    }
}

struct Step3View: View {
    @Binding var selectedMood: String
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    let proxy: ScrollViewProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What kind of trip are you looking for?")
                .font(.headline)
            
            Picker("Mood", selection: $selectedMood) {
                Text("Relaxed").tag("Relaxed")
                Text("Adventurous").tag("Adventurous")
                Text("Cultural").tag("Cultural")
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
                .background(.button)
                .foregroundStyle(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .id(3)
    }
}

struct Step4View: View {
    @Binding var selectedBudget: String
    @Binding var currentStep: Int
    @Binding var completedSteps: Set<Int>
    @Binding var selectedCity: City?
    @Binding var selectedMood: String
    @Binding var selectedTab: Int // Pass `selectedTab` for bucket list navigation
    let proxy: ScrollViewProxy

    @State private var navigateToActivities = false // State to handle navigation

    var body: some View {
        VStack(spacing: 20) {
            Text("What is your budget?")
                .font(.headline)
            
            Picker("Budget", selection: $selectedBudget) {
                Text("Cheap").tag("Cheap")
                Text("Moderate").tag("Moderate")
                Text("Luxury").tag("Luxury")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            // NavigationLink to ActivityView
            NavigationLink {
                ActivityView(
                   destination: selectedCity?.name ?? "Unknown",
                   latitude: selectedCity?.latitude ?? 0,
                   longitude: selectedCity?.longitude ?? 0,
                   mood: Mood(rawValue: selectedMood),
                   budget: selectedBudget,
                   selectedTab: $selectedTab // Pass selectedTab binding
               )
                .onAppear {
                    resetToInitialState() // Reset the WelcomeView state in the background
                }
            } label: {
                Text("Plan Activities")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background((selectedCity == nil) ? .button.opacity(0.4) : .button) // Disable if no city selected
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding()
            }
            .disabled(selectedCity == nil)

        }
        .padding()
        .id(4)
    }
    
    private func resetToInitialState() {
        currentStep = 1
        completedSteps.removeAll()
        selectedCity = nil
        selectedMood = "Relaxed"
        selectedBudget = "Moderate"
    }
}

#Preview {
    WelcomeView(selectedTab: .constant(0))
}
