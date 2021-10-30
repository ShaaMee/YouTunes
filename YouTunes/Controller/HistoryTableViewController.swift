//
//  HistoryTableViewController.swift
//  YouTunes
//
//  Created by user on 29.10.2021.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var searchHistory = [String]()
    
//    private var albumThumbnailInfo: AlbumThumbnailInfo? {
//        didSet {
//            guard let allAlbums = albumThumbnailInfo?.results else { return }
//            searchHistory = []
//
//            for album in allAlbums {
//                guard let albumName = album.collectionName else { return }
//                searchHistory.append(albumName)
//            }
//
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        albumThumbnailInfo = NetworkService.shared.fetchAlbumsForTerm("Sting") { [weak self] albumThumbnailInfo in
//            self?.albumThumbnailInfo = albumThumbnailInfo
//        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        guard searchHistory.indices.contains(indexPath.row) else { return cell}
        cell.textLabel?.text = searchHistory[indexPath.row]

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
