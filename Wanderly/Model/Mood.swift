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
                "relax", "calm", "peaceful", "serene", "tranquil",
                "spa", "retreat", "wellness", "meditation", "yoga",
                "beach", "nature", "scenic", "quiet", "garden"
            ]
        case .adventurous:
            return [
                "adventure", "exciting", "thrill", "fun", "entertainment",
                "party", "hiking", "climbing", "rafting", "extreme", "wild",
                "outdoor", "exploration", "biking", "zipline", "off-road",
                "paragliding", "safari", "diving", "kayaking"
            ]
        case .cultural:
            return [
                "culture", "historical", "museum", "art", "heritage",
                "architecture", "landmark", "gallery", "tradition", "local",
                "craft", "exhibit", "archaeology", "performance", "festival",
                "theater", "opera", "classical", "historic", "monument"
            ]
        }
    }
}
