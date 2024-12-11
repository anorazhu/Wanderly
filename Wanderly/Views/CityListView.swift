import SwiftUI

struct CityListView: View {
    @Binding var selectedCity: City?
    @State var cityViewModel = CityViewModel()
    @State private var cityName: String = "" // User input for city name

    var body: some View {
        VStack {
            // Search Bar
            TextField("Enter city name...", text: $cityName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: cityName) {
                    handleSearch(cityName)
                }

            if cityViewModel.isLoading {
                ProgressView("Loading cities...")
                    .padding()
            } else if cityViewModel.cities.isEmpty && !cityName.isEmpty {
                Text("No cities found.")
                    .foregroundStyle(.gray)
                    .padding()
            } else {
                // City List
                List(cityViewModel.cities) { city in
                    Button(action: {
                        selectCity(city)
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.headline)
                                Text("\(city.country) • Population: \(city.population)")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            if selectedCity == city {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding()
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding()
    }

    // Handle city search
    private func handleSearch(_ query: String) {
        guard !query.isEmpty else {
            cityViewModel.cities = [] // Clear results if input is empty
            return
        }

        Task {
            await cityViewModel.getData(for: query)
        }
    }

    // Handle city selection
    private func selectCity(_ city: City) {
        selectedCity = city
        print("Selected city: \(city.name), Latitude: \(city.latitude), Longitude: \(city.longitude)")
    }
}

#Preview {
    @State var selectedCity: City? = nil // Bind the selected city to preview

    CityListView(selectedCity: $selectedCity) // Pass the binding to CityListView
}
