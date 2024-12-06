//
//  CityListView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

//
//  CityListView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import SwiftUI

struct CityListView: View {
    @State var cityViewModel = CityViewModel()
    @State private var cityName: String = "" // User input for city name

    var body: some View {
        VStack {
            // Search Bar
            TextField("Enter city name...", text: $cityName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: cityName) { newValue in
                    handleSearch(newValue)
                }

            // City List
            if cityViewModel.isLoading {
                ProgressView("Loading cities...")
                    .padding()
            } else {
                List(cityViewModel.cities) { city in
                    VStack(alignment: .leading) {
                        Text(city.name.capitalized)
                            .font(.headline)
                        Text("Country: \(city.country)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Population: \(city.population)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding()
    }

    private func handleSearch(_ query: String) {
        guard !query.isEmpty else {
            cityViewModel.cities = [] // Clear results if input is empty
            return
        }

        Task {
            await cityViewModel.getData(for: query)
        }
    }
}

#Preview {
    CityListView()
}
