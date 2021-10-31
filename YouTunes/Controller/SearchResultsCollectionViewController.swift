//
//  SearchResultsCollectionViewController.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 29.10.2021.
//

import UIKit

class SearchResultsCollectionViewController: UICollectionViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var backgroundTextLabel: UILabel!
    private let activityIndicator = UIActivityIndicatorView()
    
    var showLabel = true
    
    // MARK: - All data from API request
    
    var albumsInfo: AlbumThumbnailInfo?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    var isSearching = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch self.isSearching {
                
                // showing and running activity indicator
                case true:
                    if let view = self.view {
                        view.addSubview(self.activityIndicator)
                    }
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                // hiding and stopping activity indicator
                case false:
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Albums data sorted by album name
    
    private var albums: [ThumbnailResult]? {
        return albumsInfo?.results?.sorted { album1, album2 in
            guard let name1 = album1.collectionName,
                  let name2 = album2.collectionName
            else { return false }
            return name1.lowercased() < name2.lowercased()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating and seting up a UISearchController
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(activityIndicator)
        backgroundTextLabel.isHidden = !showLabel
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.detailsSegueIdentifier,
              let destinationVC = segue.destination as? DetailsViewController,
              let item = sender as? SearchResultsCollectionViewCell,
              let albumID = item.albumID
        else { return }
        
        // Fetching album details and passing it to destination view controller
        NetworkService.shared.fetchAlbumDetailsForAlbumID(albumID, alertViewController: self) { albumDetails in
            destinationVC.albumDetails = albumDetails
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let albums = albums else { return 0 }
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellIdentifier, for: indexPath)
        guard let searchCell = cell as? SearchResultsCollectionViewCell else { return cell }
        guard let albums = albums else { return cell }
        
        // Setting up the cell outlets (including dummy image)
        searchCell.artistName.text = albums[indexPath.row].artistName
        searchCell.albumName.text = albums[indexPath.row].collectionName
        searchCell.albumID = albums[indexPath.row].collectionId
        searchCell.albumArtwork.image = UIImage(systemName: Constants.albumNoImageSystemName)
        searchCell.albumArtwork.tintColor = .systemGray6
        
        // Fetching album image in background queue
        DispatchQueue.global(qos: .utility).async {
            if let artWorkURL = albums[indexPath.row].artworkUrl100 {
                guard let url = URL(string: artWorkURL),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async {
                    searchCell.albumArtwork.image = image
                    searchCell.layoutIfNeeded()
                }
            }
        }
        return searchCell
    }
}

extension SearchResultsCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        guard let searchText = searchBar.text else { return }
        
        // Checking if search request is already saved, otherwise save it to UserDefaults
        if var searchHistory: Array<String> = UserDefaults.standard.stringArray(forKey: Constants.historySearchKey) {
            if !searchHistory.contains(searchText) {
                searchHistory.append(searchText)
                UserDefaults.standard.setValue(searchHistory, forKey: Constants.historySearchKey)
            }
        } else {
            UserDefaults.standard.setValue([searchText], forKey: Constants.historySearchKey)
        }

        albumsInfo = nil
        isSearching = true
        backgroundTextLabel.isHidden = true
        
        // Fetching albums for current search request
        NetworkService.shared.fetchAlbumsForTerm(searchText, alertViewController: self) { [weak self] albumThumbnailInfo in
            self?.albumsInfo = albumThumbnailInfo
                DispatchQueue.main.async {
                    self?.isSearching = false
                }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        albumsInfo = nil
        backgroundTextLabel.isHidden = false
    }
}
