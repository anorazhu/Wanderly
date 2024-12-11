import Foundation
import Combine

@Observable
class CityViewModel {
    private struct Returned: Codable {
        let results: [City]
    }
    
    var cities: [City] = [] // List of cities
    var isLoading: Bool = false // Loading state
    var selectedCity: City?
    
    private let apiKey = "el+O/XWmPnht4SutCiyuKw==WS9rgr3jNqsKgjrW" // Replace with your actual API key
    private let baseURL = "https://api.api-ninjas.com/v1/city"
    
    struct APIError: Codable, Error {
        let error: String
    }
    
    /// Fetches city data for a given name.
    func getData(for name: String) async {
        guard !name.isEmpty else {
            print("😡 ERROR: City name cannot be empty.")
            self.cities = []
            return
        }
        
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "name", value: name)
        ]
        
        guard let url = urlComponents.url else {
            print("😡 ERROR: Could not construct URL from \(urlComponents)")
            return
        }
        
        print("🕸️ Accessing URL: \(url)")
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        isLoading = true
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Debug: Print raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            // Decode JSON data
            let returnedCities = try JSONDecoder().decode([City].self, from: data)
            print("🟢 Successfully decoded \(returnedCities.count) cities.")
            
            Task { @MainActor in
                self.cities = returnedCities // Update the cities list
            }
            
        } catch {
            print("😡 JSON ERROR: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// Searches for a city by name.
    func searchCity(by name: String) -> City? {
        return cities.first(where: { $0.name.localizedCaseInsensitiveContains(name) })
    }
    
    /// Recommends cities based on mood and budget.
    func recommendCities(for mood: String, budget: String) -> [City] {
        return cities.filter { city in
            let inferredMood = inferMood(for: city)
            let inferredBudget = inferBudget(for: city)
            return inferredMood.contains(mood) && inferredBudget == budget
        }
    }
    
    /// Infers mood tags based on city attributes.
    private func inferMood(for city: City) -> [String] {
        var moods: [String] = []
        
        if city.is_capital {
            moods.append("Cultural")
        }
        if city.population > 1_000_000 {
            moods.append("Adventurous")
        }
        if city.population < 50_000 {
            moods.append("Relaxed")
        }
        return moods
    }
    
    /// Infers budget level based on population.
    private func inferBudget(for city: City) -> String {
        switch city.population {
        case 0..<100_000:
            return "Cheap"
        case 100_000..<1_000_000:
            return "Moderate"
        default:
            return "Luxury"
        }
    }
}
