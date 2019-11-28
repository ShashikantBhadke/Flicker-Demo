//
//  ListingVC+CollectionView.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

// MARK :- Extensio For - UICollectionViewDelegate
extension ListingVC: UICollectionViewDelegate {
    
} //extension

// MARK :- Extensio For -
extension ListingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListingCell.self), for: indexPath) as? ListingCell else { fatalError("Unable to load collection view cell (Listingcell)") }
        if indexPath.item < arrPhoto.count {
            cell.photoData = arrPhoto[indexPath.item]
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListingCell else { return }
        cell.stopDownloadImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !isLoding, (arrPhoto.count - 3) <= indexPath.item else { return }
        callWebService()
    }
    
} //extension

// MARK :- Extensio For - UICollectionViewDelegateFlowLayout
extension ListingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let mainWidth = self.view.frame.width - 30
        return CGSize(width: mainWidth, height: mainWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
} //extension

