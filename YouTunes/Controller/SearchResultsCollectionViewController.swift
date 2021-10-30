//
//  SearchResultsCollectionViewController.swift
//  YouTunes
//
//  Created by user on 29.10.2021.
//

import UIKit

private let reuseIdentifier = "albumCell"

class SearchResultsCollectionViewController: UICollectionViewController, UISearchControllerDelegate {
    
    var albumsInfo: AlbumThumbnailInfo?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.collectionView.layoutSubviews()
            }
        }
    }
        
    private var albums: [ThumbnailResult]? {
        return albumsInfo?.results
    }
    
    private let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        activityIndicator.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        guard let albums = albums else { return 0 }
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let searchCell = cell as? SearchResultsCollectionViewCell else { return cell }
        guard let albums = albums else { return cell }
        
        searchCell.artistName.text = albums[indexPath.row].artistName
        searchCell.albumName.text = albums[indexPath.row].collectionName
        searchCell.albumArtwork.image = UIImage(systemName: "photo")
        searchCell.albumArtwork.tintColor = .systemGray6
        
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension SearchResultsCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        guard let searchText = searchBar.text else { return }
        
        if var searchHistory: Array<String> = UserDefaults.standard.stringArray(forKey: Constants.historySearchKey) {
            if !searchHistory.contains(searchText) {
                searchHistory.append(searchText)
                UserDefaults.standard.setValue(searchHistory, forKey: Constants.historySearchKey)
            }
        } else {
            UserDefaults.standard.setValue([searchText], forKey: Constants.historySearchKey)
        }

        albumsInfo = nil
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NetworkService.shared.fetchAlbumsForTerm(searchText) { [weak self] albumThumbnailInfo in
            self?.albumsInfo = albumThumbnailInfo
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        albumsInfo = nil
    }
}

