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
            print("✅ Successfully fetched \(self.suggestedCities.count) destinations for input '\(input)'")
        } catch {
            print("❌ Error fetching destinations: \(error.localizedDescription)")
        }
    }

    static func saveCity(city: BucketListCity) async -> String? {
        let db = Firestore.firestore()

        do {
            // Check if the city already exists
            let query = db.collection("cities")
                .whereField("name", isEqualTo: city.name)
                .whereField("latitude", isEqualTo: city.latitude)
                .whereField("longitude", isEqualTo: city.longitude)

            let snapshot = try await query.getDocuments()

            if let document = snapshot.documents.first {
                // Update the existing city
                try db.collection("cities").document(document.documentID).setData(from: city)
                print("✅ City updated successfully!")
                return document.documentID
            } else {
                // Add a new city
                let docRef = try db.collection("cities").addDocument(from: city)
                print("🐣 New city added successfully!")
                return docRef.documentID
            }
        } catch {
            print("😡 Error saving city: \(error.localizedDescription)")
            return nil
        }
    }

    static func deleteCity(city: BucketListCity) async {
        let db = Firestore.firestore()
        guard let id = city.id else {
            print("😡 ERROR: No city ID found to delete.")
            return
        }
        do {
            try await db.collection("cities").document(id).delete()
            print("✅ City deleted successfully.")
        } catch {
            print("😡 ERROR: Could not delete city with ID \(id): \(error.localizedDescription)")
        }
    }
}
