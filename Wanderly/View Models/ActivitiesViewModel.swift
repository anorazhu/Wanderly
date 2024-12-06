//
//  ActivitiesViewModel.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

@MainActor
class ActivitiesViewModel: ObservableObject {
    @Published var activities: [Activity] = [] // List of activities
    @Published var isLoading: Bool = false // Loading state

    private let amadeusAccessToken = "<YOUR_ACCESS_TOKEN>"
    private let baseURL = "https://test.api.amadeus.com/v1/shopping/activities"

    func fetchActivities(latitude: Double, longitude: Double, radius: Int = 10) async {
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)"
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Invalid URL for Amadeus API.")
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(amadeusAccessToken)", forHTTPHeaderField: "Authorization")
        isLoading = true

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            // Debug: Print raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }

            // Decode JSON data
            let decodedResponse = try JSONDecoder().decode(ActivityResponse.self, from: data)
            activities = decodedResponse.data
        } catch {
            print("😡 JSON ERROR: \(error.localizedDescription)")
            activities = [] // Clear list on error
        }

        isLoading = false
    }
}
