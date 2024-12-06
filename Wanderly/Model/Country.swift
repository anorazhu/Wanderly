//
//  Country.swift
//  Country
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

// Country Model
struct Country: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let region: String
}

// API Response Model
struct APIResponse: Decodable {
    let data: [String: CountryData]
}

struct CountryData: Decodable {
    let country: String
    let region: String
}
