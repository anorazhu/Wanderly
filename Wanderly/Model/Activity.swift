//
//  Activity.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

struct ActivityResponse: Codable {
    let data: [Activity]
    let meta: Meta
}

struct Meta: Codable {
    let count: Int
    let links: Links
}

struct Links: Codable {
    let selfLink: String
    private enum CodingKeys: String, CodingKey {
        case selfLink = "self"
    }
}

struct Activity: Codable, Identifiable {
    let id: String
    let name: String?
    let shortDescription: String?
    let geoCode: GeoCode
    let price: Price?
    let pictures: [String]?
    let bookingLink: String?
    let minimumDuration: String?
}

struct GeoCode: Codable {
    let latitude: Double
    let longitude: Double
}

struct Price: Codable {
    let amount: String?
    let currencyCode: String?
}

extension Activity {
    static var sampleActivities: [Activity] {
        [
            Activity(
                id: "1",
                name: "Eiffel Tower Visit",
                shortDescription: "Enjoy a breathtaking view of Paris from the Eiffel Tower.",
                geoCode: GeoCode(latitude: 48.8584, longitude: 2.2945),
                price: Price(amount: "25.00", currencyCode: "EUR"),
                pictures: ["https://example.com/eiffel_tower.jpg"],
                bookingLink: "https://example.com/eiffel_tower",
                minimumDuration: "2 hours"
            ),
            Activity(
                id: "2",
                name: "Louvre Museum Tour",
                shortDescription: "Discover timeless art and artifacts at the Louvre.",
                geoCode: GeoCode(latitude: 48.8606, longitude: 2.3376),
                price: Price(amount: "15.00", currencyCode: "EUR"),
                pictures: ["https://example.com/louvre.jpg"],
                bookingLink: "https://example.com/louvre",
                minimumDuration: "3 hours"
            )
        ]
    }
}
