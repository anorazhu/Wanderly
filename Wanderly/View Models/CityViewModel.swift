import Foundation
import Combine


@Observable
class CityViewModel {
    private struct Returned: Codable {
        let results: [City]
    }

    var cities: [City] = [] // List of cities
    var isLoading: Bool = false // Loading state

    private let apiKey = "el+O/XWmPnht4SutCiyuKw==WS9rgr3jNqsKgjrW" // Replace with your actual API key
    private let baseURL = "https://api.api-ninjas.com/v1/city"

    struct APIError: Codable, Error {
        let error: String
    }

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
   }
