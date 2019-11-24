//
//  ListingVC+SearchControllerDelegate.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 24/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

// MARK :- Extensio For - UISearchResultsUpdating
extension ListingVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        arrPhoto.removeAll()
        collectionView.reloadData()
        intPage = 1
        callWebService(strSearch: text)
    }
} //extension
