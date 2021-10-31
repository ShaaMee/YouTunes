//
//  DetailsViewController.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 29.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genreAndYear: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    var albumDetails: AlbumDetails? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.extractDataFromAlbumDetails()
            }
        }
    }
    
    // List of song names
    private var tracks = [String]() {
        didSet {
            songsTableView.reloadData()
            
            //setting the hight of tableView to fit inside scrollView
            tableViewHeight.constant = CGFloat(Constants.songsListRowHeight * Double(tracks.count))
        }
    }
    
    // Setting the dateFormatter to get the album's year of release
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the dummy until image from server is available
        albumCover.image = UIImage(systemName: Constants.albumNoImageSystemName)
        albumCover.tintColor = .systemGray6
        
        songsTableView.delegate = self
        songsTableView.dataSource = self
    }
    
    // MARK: - Getting album info from received data and setting outlets
    
    private func extractDataFromAlbumDetails() {
        
        guard let albumDetails = albumDetails,
              let resultCount = albumDetails.resultCount,
              resultCount > 0
        else { return }
        
        var genreYear = ""
        let genre = albumDetails.results?.first?.primaryGenreName
        genreYear += genre ?? ""
        
        if let date = albumDetails.results?.first?.releaseDate {
            let year = dateFormatter.string(from: date)
            genreYear += "・\(year)"
        }
        
        genreAndYear.text = genreYear
        albumName.text = albumDetails.results?.first?.collectionName
        artistName.text = albumDetails.results?.first?.artistName
        
        // Fetching album cover image in background
        DispatchQueue.global().async { [weak self] in
            guard let coverURL = albumDetails.results?.first?.artworkUrl240,
                  let url = URL(string: coverURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self?.albumCover.image = image
                self?.loadSongs()
            }
        }
    }
    
    // MARK: - Getting songs names from data and putting result into array
    
    private func loadSongs(){
        
        guard let results = albumDetails?.results else { return }
        var allTracks = [String]()
        for index in 1..<results.count {
            if let track = results[index].trackName {
                allTracks.append(track)
            }
        }
        tracks = allTracks
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.songCellIdentifier, for: indexPath)
        if tracks.indices.contains(indexPath.row) {
            cell.textLabel?.text = "\(indexPath.row + 1). " + tracks[indexPath.row]
        }
        return cell
    }
}
