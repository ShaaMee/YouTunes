//
//  AlbumDetails.swift
//  YouTunes
//
//  Created by user on 30.10.2021.
//

import Foundation

// MARK: - AlbumDetails
struct AlbumDetails {
    var resultCount: Int?
    var results: [Result]?
}

// MARK: - Result
struct Result {
    var wrapperType: WrapperType?
    var collectionType: String?
    var artistName: String?
    var collectionName: String?
    var artistViewURL, collectionViewURL: String?
    var artworkUrl60, artworkUrl100: String?
    var collectionPrice: Double?
    var trackCount: Int?
    var copyright: String?
    var releaseDate: Date?
    var primaryGenreName: String?
    var trackID: Int?
    var trackName, trackCensoredName: String?
    var collectionArtistID: Int?
    var collectionArtistName: String?
    var collectionArtistViewURL, trackViewURL: String?
    var previewURL: String?
    var artworkUrl30: String?
    var trackPrice: Double?
    var discCount, discNumber, trackNumber, trackTimeMillis: Int?
    var isStreamable: Bool?
}

enum WrapperType {
    case collection
    case track
}
