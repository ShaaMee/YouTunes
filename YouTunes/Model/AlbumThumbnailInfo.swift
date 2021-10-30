//
//  AlbumInfo.swift
//  YouTunes
//
//  Created by user on 29.10.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let albumInfo = try? newJSONDecoder().decode(AlbumInfo.self, from: jsonData)

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
