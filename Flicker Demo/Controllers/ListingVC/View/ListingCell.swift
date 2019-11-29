//
//  ListingCell.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit
import Kingfisher

final class ListingCell: UICollectionViewCell {
    
    // MARK:- Outlets
    @IBOutlet private weak var imgvPost     : UIImageView!
    @IBOutlet private weak var lblTitle     : UILabel!
    
    // MARK:- Variables
    var strIndex = "-"
    var photoData: FlickrPhoto? {
        didSet{
            setUpData()
        }
    }
    
    // MARK:- Default Methods
    override func awakeFromNib() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        imgvPost.layer.cornerRadius = 5
        imgvPost.layer.masksToBounds = true
        imgvPost.clipsToBounds =  true
        imgvPost.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        imgvPost.image = nil
        lblTitle.text = ""
    }
    
    private func setUpData() {
        guard let obj = photoData else { return }
        lblTitle.text = "\(strIndex) " + (obj.title ?? "").capitalized
        imgvPost.setImage(obj.urlM)
    }
    
    func stopDownloadImage() {
        imgvPost.kf.cancelDownloadTask()
    }
    
} //class


// MARK :- Extensio For - UIImageView
extension UIImageView {
    func setImage(_ _strURL: String?, _size: CGSize? = nil) {
        guard let strURL = _strURL, !strURL.isEmpty, let url = URL(string: strURL) else { return }
        let resizeProcess = ResizingImageProcessor(referenceSize: _size ?? self.frame.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: nil, options: [!NetworkHelper.sharedInstance.isNetworkAvailable ? .onlyFromCache : .fromMemoryCacheOrRefresh, .processor(resizeProcess)], progressBlock: nil)
    }
} //extension
