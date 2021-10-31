//
//  HistoryTableViewController.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 29.10.2021.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    // Getting search history from UserDefaults
    var searchHistory: [String] {
        return UserDefaults.standard.stringArray(forKey: Constants.historySearchKey) ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realoading data in case user switched to search tab and performed new search
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
            
            // Fetching albums for selected row and passing data to destination view controller
            NetworkService.shared.fetchAlbumsForTerm(searchTerm, alertViewController: self) { albumThumbnailInfo in
                searchVC.albumsInfo = albumThumbnailInfo
                searchVC.isSearching = false
            }
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            if var value = UserDefaults.standard.stringArray(forKey: Constants.historySearchKey),
               value.contains(searchHistory[indexPath.row]) {
                value.remove(at: indexPath.row)
                UserDefaults.standard.setValue(value, forKey: Constants.historySearchKey)
            }
            tableView.reloadData()
        }
    }
}
