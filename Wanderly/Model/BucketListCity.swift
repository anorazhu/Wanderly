import Foundation
import Firebase
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
