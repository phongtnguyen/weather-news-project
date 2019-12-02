//
//  ItunesModel.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/27/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation

struct JSONModel<T: Codable> {
    let model: T.Type
}

struct ItunesModel: Codable {
    let resultCount: Int
    let results: [ItunesTrackModel]
}

struct ItunesTrackModel: Codable {
    let artistName: String
    let trackName: String
    let previewUrl: String
    let collectionName: String
    let artistViewUrl: String
    let collectionViewUrl: String
    let trackViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Float
    let trackPrice: Float
    let releaseDate: String
    let primaryGenreName: String
    let country: String
    let trackTimeMillis: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? "NO ARTIST INFO"
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? "NO TRACK INFO"
        previewUrl = try container.decodeIfPresent(String.self, forKey: .previewUrl) ?? ""
        collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
        artistViewUrl = try container.decodeIfPresent(String.self, forKey: .artistViewUrl) ?? ""
        collectionViewUrl = try container.decodeIfPresent(String.self, forKey: .collectionViewUrl) ?? ""
        trackViewUrl = try container.decodeIfPresent(String.self, forKey: .trackViewUrl) ?? ""
        artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60) ?? ""
        artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
        collectionPrice = try container.decodeIfPresent(Float.self, forKey: .collectionPrice) ?? -1.0
        trackPrice = try container.decodeIfPresent(Float.self, forKey: .trackPrice) ?? -1.0
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? ""
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        trackTimeMillis = try container.decodeIfPresent(Int.self, forKey: .trackTimeMillis) ?? 0
    }
}
