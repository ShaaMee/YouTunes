//
//  NetworkService.swift
//  YouTunes
//
//  Created by user on 30.10.2021.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
        
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    
    // MARK: - Fetching artist's albums from iTunes API
    
    func fetchAlbumsForTerm(_ searchTerm: String, completionHandler: @escaping (AlbumThumbnailInfo) -> Void) {
        let formattedSearchString = searchTerm
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "+")
        let searchURLString = "https://itunes.apple.com/search?term=" + formattedSearchString + "&media=music&entity=album"
        
        networkRequestFor(string: searchURLString) { details, _ in
            guard let details = details else {
                print("Data is nil")
                return
            }
            completionHandler(details)
        }
    }
    
    // MARK: - Fetching album delails from iTunes API
    
    func fetchAlbumDetailsForAlbumID(_ albumID: Int, completionHandler: @escaping (AlbumDetails) -> Void) {
        let searchURLString = "https://itunes.apple.com/lookup?id=\(albumID)&entity=song"
        
        networkRequestFor(string: searchURLString) { _, details in
            guard let details = details else {
                print("Data is nil")
                return
            }
            completionHandler(details)
        }
    }
    
    func networkRequestFor(string: String, completionHandler: @escaping (AlbumThumbnailInfo?, AlbumDetails?) -> Void){
        
        guard let url = URL(string: string) else { return }
        
        if !UIApplication.shared.canOpenURL(url) {
            print("Request URL is unreachable. Please check your internet connection.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                
                let thumbnailsInfo = try? self?.decoder.decode(AlbumThumbnailInfo.self, from: data)
                let albumDetails = try? self?.decoder.decode(AlbumDetails.self, from: data)
                
                completionHandler(thumbnailsInfo, albumDetails)
            }
        }.resume()
    }
}
