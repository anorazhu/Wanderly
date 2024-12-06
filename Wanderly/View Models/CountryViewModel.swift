//
//  CountryViewModel.swift
//  Country
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

@MainActor
@Observable
class CountryViewModel {
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    var searchQuery: String = ""
    var selectedContinent: String = "All" // Default continent selection
    
    let continents = ["All", "Africa", "Asia", "Europe", "North America", "Oceania", "South America"] // List of continents
    
    // Fetch countries from API
    func fetchCountries() {
        guard let url = URL(string: "https://api.first.org/data/v1/countries?limit=250") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Clean and sort country data
                        self.countries = decodedResponse.data
                            .map { Country(code: $0.key, name: self.cleanCountryName($0.value.country), region: $0.value.region) }
                            .sorted(by: { $0.name < $1.name }) // Sort alphabetically
                        
                        self.filteredCountries = self.countries
                        print("Total number of countries: \(self.countries.count)")
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }.resume()
    }
    
    // Filter countries based on search query and selected continent
    func filterCountries() {
        filteredCountries = countries.filter { country in
            let matchesSearch = searchQuery.isEmpty || country.name.lowercased().contains(searchQuery.lowercased())
            let matchesContinent = selectedContinent == "All" || country.region == selectedContinent
            return matchesSearch && matchesContinent
        }
    }
    
    // Clean country names (e.g., remove "The")
    func cleanCountryName(_ name: String) -> String {
        var cleanedName = name
        if cleanedName.lowercased().hasSuffix("(the)") {
            cleanedName = String(cleanedName.dropLast(5))
            cleanedName = cleanedName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return cleanedName
    }
}
