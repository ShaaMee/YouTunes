//
//  HistoryTableViewController.swift
//  YouTunes
//
//  Created by user on 29.10.2021.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyCellIdentifier, for: indexPath)
        guard searchHistory.indices.contains(indexPath.row) else { return cell}
        cell.textLabel?.text = searchHistory[indexPath.row]

        return cell
    }



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == Constants.searchHistoryToResultsSegueIdetifier, let searchVC = segue.destination as? SearchResultsCollectionViewController, let cell = sender as? UITableViewCell else { return }
        if let searchTerm = cell.textLabel?.text {
            searchVC.isSearching = true
            NetworkService.shared.fetchAlbumsForTerm(searchTerm) { albumThumbnailInfo in
                searchVC.albumsInfo = albumThumbnailInfo
                searchVC.isSearching = false
            }
        }
        
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
