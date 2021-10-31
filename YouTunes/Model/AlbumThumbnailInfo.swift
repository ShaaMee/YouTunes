//
//  AlbumInfo.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 29.10.2021.
//

import Foundation

// MARK: - Data received from JSON

struct AlbumThumbnailInfo: Codable {
    var results: [ThumbnailResult]?
}

// MARK: - Short info for CollectionView display

struct ThumbnailResult: Codable {
    var collectionId: Int?
    var artistName, collectionName: String?
    var artworkUrl100: String?
}
