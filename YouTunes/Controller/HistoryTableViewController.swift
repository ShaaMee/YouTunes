//
//  HistoryTableViewController.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 29.10.2021.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var searchHistory: [String] {
        return UserDefaults.standard.stringArray(forKey: Constants.historySearchKey) ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyCellIdentifier, for: indexPath)
        guard searchHistory.indices.contains(indexPath.row) else { return cell}
        cell.textLabel?.text = searchHistory[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == Constants.searchHistoryToResultsSegueIdetifier,
              let searchVC = segue.destination as? SearchResultsCollectionViewController,
              let cell = sender as? UITableViewCell
        else { return }
        
        searchVC.showLabel = false
        
        if let searchTerm = cell.textLabel?.text {
            searchVC.isSearching = true
            NetworkService.shared.fetchAlbumsForTerm(searchTerm, alertViewController: self) { albumThumbnailInfo in
                searchVC.albumsInfo = albumThumbnailInfo
                searchVC.isSearching = false
            }
        }
    }
}
