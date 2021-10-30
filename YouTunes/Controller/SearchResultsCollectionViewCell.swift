//
//  SearchResultsCollectionViewCell.swift
//  YouTunes
//
//  Created by user on 29.10.2021.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    var albumID: Int?
}
