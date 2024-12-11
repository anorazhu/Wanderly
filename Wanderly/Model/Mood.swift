//
//  Mood.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/9/24.
//

import Foundation

enum Mood: String, CaseIterable {
    case relaxed = "Relaxed"
    case adventurous = "Adventurous"
    case cultural = "Cultural"
    
    /// Provides keywords for filtering activities
    var keywords: [String] {
        switch self {
        case .relaxed:
            return [
                "relax", "calm", "peaceful", "serene", "tranquil", "spa", "retreat", "wellness", "meditation", "yoga", "beach", "nature", "scenic", "quiet", "garden", "resort", "lagoon", "sunset", "river cruise", "island", "sanctuary", "zen", "oasis", "picnic", "coastal", "park", "lighthouse", "sailing", "lake", "chalet", "hot springs", "vineyard"
            ]
        case .adventurous:
            return [
                "adventure", "exciting", "thrill", "fun", "entertainment", "party", "hiking", "climbing", "rafting", "extreme", "wild", "outdoor", "exploration", "biking", "zipline", "off-road", "paragliding", "safari", "diving", "kayaking", "surfing", "bungee", "skydiving", "mountaineering", "canyoning", "ATV", "adrenaline", "snorkeling", "rock climbing", "wildlife", "volcano", "expedition", "trekking", "off-grid", "water sports", "sandboarding", "dune buggy", "glamping"
            ]
        case .cultural:
            return [
                "culture", "historical", "museum", "art", "heritage", "architecture", "landmark", "gallery", "tradition", "local", "craft", "exhibit", "archaeology", "performance", "festival", "theater", "opera", "classical", "historic", "monument", "cathedral", "palace", "castle", "church", "temple", "ancient", "religious", "folklore", "cuisine", "handicraft", "historical walk", "cultural tour", "village", "marketplace", "storytelling", "music", "dance", "parade", "ceremony"
            ]
        }
    }
}
