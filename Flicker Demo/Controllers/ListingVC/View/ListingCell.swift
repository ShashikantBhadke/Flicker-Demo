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
    @IBOutlet private weak var viewBG       : UIView!
    @IBOutlet private weak var imgvPost     : UIImageView!
    @IBOutlet private weak var imgvNewPost  : UIImageView!
    @IBOutlet private weak var lblTitle     : UILabel!
    
    // MARK:- Variables
    var photoData: FlickrPhoto? {
        didSet{
            setUpData()
        }
    }
    
    // MARK:- Default Methods
    override func awakeFromNib() {
        viewBG.layer.cornerRadius = 5
        viewBG.layer.masksToBounds = true
        imgvPost.clipsToBounds =  true
        imgvPost.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        imgvPost.image = nil
        lblTitle.text = ""
    }
    
    private func setUpData() {
        guard let obj = photoData else { return }
        lblTitle.text = (obj.title ?? "").capitalized
        imgvNewPost.isHidden = !obj.isNew
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
        self.kf.setImage(with: url, placeholder: nil, options: [isOffline ? .onlyFromCache : .fromMemoryCacheOrRefresh, .processor(resizeProcess)], progressBlock: nil)
    }
} //extension
