//
//  Activity.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation

struct ActivityResponse: Codable {
    let data: [Activity]
}

struct Activity: Identifiable, Codable {
    let id: String?
    let name: String
    let description: String?
    let geoCode: GeoCode
    let price: Price?
    let rating: Double?
    let pictures: [String]?

    struct GeoCode: Codable {
        let latitude: Double
        let longitude: Double
    }

    struct Price: Codable {
        let amount: String?
        let currencyCode: String?
    }
}

extension Activity {
    static var sampleActivities: [Activity] {
        return [
                    Activity(id: "1", name: "Eiffel Tower Visit", description: "Explore the iconic Eiffel Tower", geoCode: Activity.GeoCode(latitude: 48.8584, longitude: 2.2945), price: nil, rating: 4.8, pictures: nil),
                    Activity(id: "2", name: "Louvre Museum Tour", description: "See world-class art at the Louvre Museum", geoCode: Activity.GeoCode(latitude: 48.8606, longitude: 2.3376), price: nil, rating: 4.7, pictures: nil),
                    Activity(id: "3", name: "Seine River Cruise", description: "Take a relaxing cruise along the Seine", geoCode: Activity.GeoCode(latitude: 48.8566, longitude: 2.3522), price: nil, rating: 4.5, pictures: nil),
                    Activity(id: "4", name: "Montmartre Walking Tour", description: "Explore the artistic district of Montmartre", geoCode: Activity.GeoCode(latitude: 48.8867, longitude: 2.3431), price: nil, rating: 4.5, pictures: nil),
                    Activity(id: "5", name: "Notre-Dame Cathedral", description: "Visit the world-renowned Gothic cathedral", geoCode: Activity.GeoCode(latitude: 48.852968, longitude: 2.349902), price: nil, rating: 4.6, pictures: nil),
                    Activity(id: "6", name: "Sainte-Chapelle", description: "Admire the stunning stained-glass windows of Sainte-Chapelle", geoCode: Activity.GeoCode(latitude: 48.8554, longitude: 2.3450), price: nil, rating: 4.7, pictures: nil),
                    Activity(id: "7", name: "Musée d'Orsay", description: "Discover impressionist art at Musée d'Orsay", geoCode: Activity.GeoCode(latitude: 48.8600, longitude: 2.3250), price: nil, rating: 4.8, pictures: nil),
                    Activity(id: "8", name: "Champs-Élysées", description: "Stroll along the famous avenue of Champs-Élysées", geoCode: Activity.GeoCode(latitude: 48.8698, longitude: 2.3074), price: nil, rating: 4.5, pictures: nil),
                    Activity(id: "9", name: "Luxembourg Gardens", description: "Relax in the beautiful Luxembourg Gardens", geoCode: Activity.GeoCode(latitude: 48.8462, longitude: 2.3375), price: nil, rating: 4.7, pictures: nil),
                    Activity(id: "10", name: "Arc de Triomphe", description: "Climb to the top of the Arc de Triomphe for stunning views", geoCode: Activity.GeoCode(latitude: 48.8738, longitude: 2.2950), price: nil, rating: 4.7, pictures: nil)
                ]
    }
}
