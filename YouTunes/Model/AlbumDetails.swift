//
//  AlbumDetails.swift
//  YouTunes
//
//  Created by user on 30.10.2021.
//

import Foundation

// MARK: - AlbumDetails
struct AlbumDetails: Codable {
    var resultCount: Int?
    var results: [AlbumInfo]?
}

// MARK: - Result
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
    var trackNumber: Int?
}
