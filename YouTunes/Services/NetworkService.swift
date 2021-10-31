//
//  NetworkService.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 30.10.2021.
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
    
    func fetchAlbumsForTerm(_ searchTerm: String, alertViewController vc: UIViewController, completionHandler: @escaping (AlbumThumbnailInfo) -> Void) {
        let formattedSearchString = searchTerm
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "+")
        let searchURLString = "https://itunes.apple.com/search?term=" + formattedSearchString + "&media=music&entity=album"
        
        networkRequestFor(string: searchURLString, alertViewController: vc) { details, _ in
            guard let details = details, !(details.results?.count == 0) else {
                AlertService.shared.showAlertWith(messeage: "The server response is empty. Please try another search phrase.", inViewController: vc)
                return
            }
            completionHandler(details)
        }
    }
    
    // MARK: - Fetching album delails from iTunes API
    
    func fetchAlbumDetailsForAlbumID(_ albumID: Int, alertViewController vc: UIViewController, completionHandler: @escaping (AlbumDetails) -> Void) {
        let searchURLString = "https://itunes.apple.com/lookup?id=\(albumID)&entity=song"
        
        networkRequestFor(string: searchURLString, alertViewController: vc) { _, details in
            guard let details = details, !(details.results?.count == 0) else {
                AlertService.shared.showAlertWith(messeage: "The server response is empty", inViewController: vc)
                return
            }
            completionHandler(details)
        }
    }
    
    func networkRequestFor(string: String, alertViewController vc: UIViewController, completionHandler: @escaping (AlbumThumbnailInfo?, AlbumDetails?) -> Void){
        
        guard let url = URL(string: string) else { return }
        
        if !UIApplication.shared.canOpenURL(url) {
            AlertService.shared.showAlertWith(messeage: "Requested URL is unreachable. Please check your URL adress.", inViewController: vc)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                AlertService.shared.showAlertWith(messeage: error.localizedDescription, inViewController: vc)
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                
                let thumbnailsInfo = try? self?.decoder.decode(AlbumThumbnailInfo.self, from: data)
                let albumDetails = try? self?.decoder.decode(AlbumDetails.self, from: data)
                
                if thumbnailsInfo == nil && albumDetails == nil {
                    AlertService.shared.showAlertWith(messeage: "Can't decode JSON data", inViewController: vc)
                } else {
                    completionHandler(thumbnailsInfo, albumDetails)
                }
            }
        }.resume()
    }
}
