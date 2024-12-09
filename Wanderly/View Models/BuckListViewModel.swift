//
//  BucketListViewModel.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/6/24.
//

import Foundation
import FirebaseFirestore
import Firebase

@Observable
class BucketListViewModel {
    var suggestedCities: [BucketListCity] = []
    
    func fetchDestinations(for input: String, inputType: String) async {
        let db = Firestore.firestore()
        do {
            var query: Query
            switch inputType.lowercased() {
            case "city":
                query = db.collection("cities").whereField("name", isEqualTo: input)
            case "country":
                query = db.collection("cities").whereField("country", isEqualTo: input)
            case "continent":
                query = db.collection("cities").whereField("continent", isEqualTo: input)
            default:
                print("❌ Invalid input type")
                return
            }

            let snapshot = try await query.getDocuments()
            let cities = snapshot.documents.compactMap { document in
                try? document.data(as: BucketListCity.self)
            }
            await MainActor.run {
                self.suggestedCities = cities
            }
        } catch {
            print("❌ Error fetching destinations: \(error.localizedDescription)")
        }
    }
    
    static func saveCity(city: BucketListCity) async -> String? {
        let db = Firestore.firestore()
        
        if let id = city.id {
            // Update existing city
            do {
                try db.collection("cities").document(id).setData(from: city)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 Could not update data in 'cities': \(error.localizedDescription)")
                return id
            }
        } else {
            // Create new city
            do {
                let docRef = try db.collection("cities").addDocument(from: city)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 Could not create a new 'city': \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func deleteCity(city: BucketListCity) async {
        let db = Firestore.firestore()
        guard let id = city.id else {
            print("No city.id")
            return
        }
        do {
            try await db.collection("cities").document(id).delete()
            print("✅ City deleted successfully.")
        } catch {
            print("😡 ERROR: Could not delete document \(id): \(error.localizedDescription)")
        }
    }
}
