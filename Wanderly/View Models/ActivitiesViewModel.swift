//
//  ActivitiesViewModel.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

@MainActor
@Observable
class ActivityViewModel {
    var activities: [Activity] = [] // All fetched activities
    var filteredActivities: [Activity] = [] // Activities after applying filters
    var isLoading: Bool = false

    private let baseURL = "https://test.api.amadeus.com/v1/shopping/activities"
    private let tokenManager = AccessTokenManager()

    func fetchActivities(latitude: Double, longitude: Double, radius: Int = 10, mood: Mood? = nil) async {
        isLoading = true
        defer { isLoading = false }

        do {
            print("📡 Fetching Access Token...")
            let accessToken = try await tokenManager.fetchAccessToken()
            print("✅ Access Token Fetched: \(accessToken)")

            let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)"
            print("🔗 API URL: \(urlString)")

            guard let url = URL(string: urlString) else {
                print("😡 ERROR: Invalid URL.")
                return
            }

            var request = URLRequest(url: url)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("📡 Sending API Request...")

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("🔍 HTTP Status Code: \(httpResponse.statusCode)")
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("😡 ERROR: Invalid response from server.")
                return
            }

            // Print raw JSON for debugging
            let jsonString = String(data: data, encoding: .utf8) ?? "No JSON String Available"
            print("📥 Raw JSON Response: \(jsonString)")

            // Decode JSON data
            let decoder = JSONDecoder()
            do {
                let activityResponse = try decoder.decode(ActivityResponse.self, from: data)
                print("✅ Successfully Decoded Activities")

                Task { @MainActor in
                    self.activities = activityResponse.data
                    self.filterActivities(by: mood)
                }
            } catch {
                print("😡 JSON Decoding Error: \(error)")
            }
        } catch {
            print("😡 ERROR: \(error.localizedDescription)")
        }
    }

    /// Filters activities based on the selected mood
    func filterActivities(by mood: Mood?) {
        guard let mood = mood else {
            filteredActivities = activities // No mood filter applied, show all activities
            return
        }

        // Filter activities by matching their shortDescription with mood keywords
        let keywords = mood.keywords
        filteredActivities = activities.filter { activity in
            guard let description = activity.shortDescription?.lowercased() else { return false }
            return keywords.contains { keyword in description.contains(keyword) }
        }

        print("🎯 Filtered \(filteredActivities.count) activities for mood: \(mood.rawValue)")
    }
}
