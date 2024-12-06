//
//  SelectionView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import SwiftUI

struct SelectionView: View {
    @State private var viewModel = CountryViewModel()
    @State private var cityViewModel = CityViewModel()
    @State private var selectedOption: String = "Continent" // Track which picker is active
    @State private var selectedContinent: String = ""
    @State private var selectedCountry: Country? = nil
    @State private var selectedCity: City? = nil
    
    private let options = ["Continent", "Country", "City"] // Picker options
    
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
            
            // Dynamically Render Input Based on Selection
            if selectedOption == "Continent" {
                // Continent Picker
                VStack {
                    Text("Select Continent:")
                        .font(.headline)
                    Picker("Select Continent", selection: $selectedContinent) {
                        Text("None").tag("")
                        ForEach(viewModel.continents, id: \.self) { continent in
                            Text(continent).tag(continent)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedContinent) {
                        viewModel.filterCountries()
                        selectedCountry = nil // Reset dependent selections
                        selectedCity = nil
                    }
                }
                .padding()
                
            } else if selectedOption == "Country" {
                // Country Picker
                VStack {
                    Text("Select Country:")
                        .font(.headline)
                    Picker("Select Country", selection: $selectedCountry) {
                        Text("None").tag(nil as Country?)
                        ForEach(viewModel.filteredCountries) { country in
                            Text(country.name).tag(country as Country?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedCountry) {
                        selectedCity = nil // Reset city selection
                    }
                }
                .padding()
                
            } else if selectedOption == "City" {
                // City Search Bar and Picker
                
                CityListView()
                
            }
            
            
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.fetchCountries()
        }
    }
}

#Preview {
    SelectionView()
}
