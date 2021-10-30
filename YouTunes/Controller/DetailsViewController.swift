//
//  DetailsViewController.swift
//  YouTunes
//
//  Created by user on 29.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var albumDetails: AlbumDetails? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.extractDataFromAlbumDetails()
            }
        }
    }
    var tracks = [String]()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genreAndYear: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songsTableView.delegate = self
        songsTableView.dataSource = self

    }
    
    func extractDataFromAlbumDetails() {
        guard let albumDetails = albumDetails,
              let resultCount = albumDetails.resultCount,
              resultCount > 0
        else { return }
        albumName.text = albumDetails.results?.first?.collectionName
        artistName.text = albumDetails.results?.first?.artistName
        var genreYear = ""
        let genre = albumDetails.results?.first?.primaryGenreName
        genreYear += genre ?? ""
        
        if let date = albumDetails.results?.first?.releaseDate {
            let year = dateFormatter.string(from: date)
            genreYear += "・\(year)"
        }
        genreAndYear.text = genreYear
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.songCellIdentifier, for: indexPath)
        if tracks.indices.contains(indexPath.row) {
            cell.textLabel?.text = tracks[indexPath.row]
        }
        return cell
    }
    
    
}
