//
//  NetworkService.swift
//  YouTunes
//
//  Created by user on 30.10.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
        
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    
    // MARK: - Fetching artist's albums from iTunes API
    
    func fetchAlbumsForTerm(_ searchTerm: String, completionHadler: @escaping (AlbumThumbnailInfo) -> Void) {
        let formattedSearchString = searchTerm
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "+")
        let searchURLString = "https://itunes.apple.com/search?term=" + formattedSearchString + "&media=music&entity=album"
        
        guard let url = URL(string: searchURLString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error{
                print(error.localizedDescription)
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                print("I got data: \(data)")
                
                do {
                    if let albumThimbnailInfo = try self?.decoder.decode(AlbumThumbnailInfo.self, from: data) {
                        completionHadler(albumThimbnailInfo)
                    }
                } catch {
                    print("Can't decode JSON")
                }
            }
        }.resume()
        return
    }
    
    // MARK: - Fetching album delails from iTunes API
    
    func fetchAlbumDetailsForAlbumID(_ albumID: Int) -> AlbumDetails? {
        
        //URL for album details
        //https://itunes.apple.com/lookup?id=211192863&entity=song
        
        return nil
    }
}
