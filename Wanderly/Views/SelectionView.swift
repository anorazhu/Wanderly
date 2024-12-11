import SwiftUI

struct SelectionView: View {
    @Binding var selectedCountry: Country? // Pass the selected country to the parent view
    @Binding var selectedContinent: String // Pass the selected continent to the parent view
    @State var viewModel = CountryViewModel() // ViewModel for fetching and managing country data
    @State private var selectedOption: String = "Continent" // Track the active picker option (Continent/Country)

    private let options = ["Continent", "Country"] // Picker options

    var body: some View {
        VStack(spacing: 16) {
            // Unified Picker for Option Selection
            Picker("Select Input Type", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Render Input Based on Selection
            if selectedOption == "Continent" {
                VStack(spacing: 10) {
                    Text("Select Continent to Explore:")
                        .font(.headline)

                    Picker("Select a Continent", selection: $selectedContinent) {
                        Text("None").tag("")
                        ForEach(viewModel.continents, id: \.self) { continent in
                            Text(continent).tag(continent)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedContinent) { _ in
                        viewModel.selectedContinent = selectedContinent
                        selectedCountry = nil // Clear country selection
                    }

                    if selectedContinent.isEmpty {
                        Text("Please select a continent.")
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                }
                .padding()

            } else if selectedOption == "Country" {
                VStack(spacing: 10) {
                    Text("Select a Country to Explore:")
                        .font(.headline)

                    if viewModel.filteredCountries.isEmpty {
                        Text("No countries available. Select a continent first.")
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    } else {
                        Picker("Select Country", selection: $selectedCountry) {
                            Text("None").tag(nil as Country?)
                            ForEach(viewModel.filteredCountries) { country in
                                Text(country.name).tag(country as Country?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                .padding()
            }

            Spacer()

            // Display Selection Summary
            VStack {
                Text("Your Selection:")
                    .font(.headline)
                    .padding(.bottom, 5)

                if let country = selectedCountry {
                    Text("Country: \(country.name)")
                } else if !selectedContinent.isEmpty {
                    Text("Continent: \(selectedContinent)")
                } else {
                    Text("No selection yet.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .padding()
        .task {
            await viewModel.fetchCountries()
        }
    }
}

#Preview {
    SelectionView(selectedCountry: .constant(nil), selectedContinent: .constant(""))
}
