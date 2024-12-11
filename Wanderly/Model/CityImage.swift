//
//  CityImage.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/11/24.
//

import Foundation

struct PexelsResponse: Codable {
    let photos: [PexelsPhoto]
}

struct PexelsPhoto: Codable {
    let src: PexelsPhotoSource
}

struct PexelsPhotoSource: Codable {
    let large: String
}
