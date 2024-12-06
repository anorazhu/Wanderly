//
//  BucketListCity.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation
import FirebaseFirestore

struct BucketListCity: Identifiable, Codable {
    @DocumentID var id: String? // Firestore auto-generates an ID
    let name: String
    let image: String
    let description: String
    let latitude: Double
    let longitude: Double
    var activities: [Activity]?
}

extension BucketListCity {
    static var preview: BucketListCity {
        return BucketListCity(
            id: nil, // Leave `id` as `nil` for preview purposes
            name: "Paris",
            image: "Paris", // Replace with your actual image asset name
            description: "City of Love",
            latitude: 48.8566,
            longitude: 2.3522,
            activities: [
                Activity(
                    id: nil,
                    name: "Eiffel Tower Visit",
                    description: "Explore the iconic Eiffel Tower",
                    geoCode: Activity.GeoCode(latitude: 48.8584, longitude: 2.2945),
                    price: nil,
                    rating: 4.8,
                    pictures: nil
                ),
                Activity(
                    id: nil,
                    name: "Louvre Museum Tour",
                    description: "See world-class art at the Louvre Museum",
                    geoCode: Activity.GeoCode(latitude: 48.8606, longitude: 2.3376),
                    price: nil,
                    rating: 4.7,
                    pictures: nil
                )
            ]
        )
    }
}
