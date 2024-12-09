//
//  AccessTokenManager.swift
//  APICall
//
//  Created by Anora Zhu on 12/8/24.
//

import Foundation

class AccessTokenManager {
    private let clientId = "dbfyTZ9mJsTIzimAvti1W0nAVtFb8GEo" // Replace with your Amadeus client ID
    private let clientSecret = "WYq16mVM1fBiHHYU" // Replace with your Amadeus client secret
    private let authURL = "https://test.api.amadeus.com/v1/security/oauth2/token"

    private var token: String?
    private var tokenExpirationDate: Date?

    func fetchAccessToken() async throws -> String {
        // Use cached token if valid
        if let token = token, let expirationDate = tokenExpirationDate, expirationDate > Date() {
            return token
        }

        // Prepare the request
        guard let url = URL(string: authURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
        request.httpBody = body.data(using: .utf8)

        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Decode response
        let decodedResponse = try JSONDecoder().decode(AccessTokenResponse.self, from: data)

        // Cache token and expiration date
        token = decodedResponse.access_token
        tokenExpirationDate = Date().addingTimeInterval(TimeInterval(decodedResponse.expires_in))

        return token!
    }
}

struct AccessTokenResponse: Codable {
    let access_token: String
    let expires_in: Int
    let token_type: String
}
