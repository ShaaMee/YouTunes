//
//  AlbumInfo.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 29.10.2021.
//

import Foundation

// MARK: - AlbumThumbnailInfo
struct AlbumThumbnailInfo: Codable {
    var results: [ThumbnailResult]?
}

// MARK: - Result
struct ThumbnailResult: Codable {
    var collectionId: Int?
    var artistName, collectionName: String?
    var artworkUrl100: String?
}
