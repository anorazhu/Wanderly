//
//  CityImageViewModel.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/11/24.
//

import Foundation

@MainActor
@Observable
class CityImageViewModel {
    var photoURL: String? = nil
    var isLoading = false
    var errorMessage: String? = nil
    private let apiKey = "02vWRY0Xln94CwyQOrnv41Era4AyYnakNAkB3K0AJFbjYMGl948Mdbqd" 
    private let baseURL = "https://api.pexels.com/v1/search"
    
    /// Fetch a photo for a specific city
    func fetchPhoto(for city: String) async {
        guard !city.isEmpty else {
            errorMessage = "City name cannot be empty."
            return
        }

        isLoading = true
        errorMessage = nil

        guard var urlComponents = URLComponents(string: baseURL) else {
            errorMessage = "Invalid API URL."
            isLoading = false
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: "\(city) city"),
            URLQueryItem(name: "per_page", value: "1") // Fetch only 1 photo
        ]

        guard let url = urlComponents.url else {
            errorMessage = "Failed to construct API URL."
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decodedResponse = try JSONDecoder().decode(PexelsResponse.self, from: data)
                if let photo = decodedResponse.photos.first {
                    photoURL = photo.src.large // Get the large-sized photo URL
                } else {
                    errorMessage = "No photos found for \(city)."
                }
            } else {
                errorMessage = "Failed to fetch photo. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
            }
        } catch {
            errorMessage = "Error fetching photo: \(error.localizedDescription)"
        }

        isLoading = false
    }
}



