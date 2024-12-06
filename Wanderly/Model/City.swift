//
//  City.swift
//  Country
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

struct City: Identifiable, Codable, Hashable {
    let id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let population: Int
    let is_capital: Bool
}
