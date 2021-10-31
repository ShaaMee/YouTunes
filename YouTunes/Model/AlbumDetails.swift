//
//  AlbumDetails.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 30.10.2021.
//

import Foundation

// MARK: - Data received from JSON

struct AlbumDetails: Codable {
    var resultCount: Int?
    var results: [AlbumInfo]?
}

// MARK: - Current album details (for the first element) and list of songs (for further elements)

struct AlbumInfo: Codable {
    var artistName: String?
    var collectionName: String?
    var artworkUrl100: String?
    var artworkUrl240: String? {
        return artworkUrl100?.replacingOccurrences(of: "100x100", with: "240x240")
    }
    var releaseDate: Date?
    var primaryGenreName: String?
    var trackName: String?
}
