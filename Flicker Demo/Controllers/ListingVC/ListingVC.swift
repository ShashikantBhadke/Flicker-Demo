//
//  ListingVC.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

final class ListingVC: UIViewController {

    // MARK:- Outlets
    
    @IBOutlet private weak var indicator        : UIActivityIndicatorView!
    @IBOutlet private weak var lblStatus        : UILabel!
    @IBOutlet private weak var collectionView   : UICollectionView!
    
    // MARK:- Variables
    var arrPhoto = [FlickrPhoto]()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callWebService()
    }

    // MARK:- Setup CollectionView
    private func setUpCollectionView() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK:- API Call
    private func callWebService() {
        showIndicator()
        Constants.getListingfor("Nature"){ result in
            switch result {
            case .success(let arrData):
                DispatchQueue.main.async {
                    if let arr = arrData.photos?.photo, !arr.isEmpty {
                        self.arrPhoto = arr
                        self.collectionView.reloadData()
                        self.stopIndicator()
                    } else {
                        self.stopIndicator(withErr: "No data available right now.")
                    }
                    
                }
            case .error(let strErr):
                DispatchQueue.main.async {
                    self.stopIndicator(withErr: strErr)
                }
            }
        }
    }

    // MARK:- Indicator Methods
    private func showIndicator(_ strMessage: String = "Loading...") {
        lblStatus.isHidden = false
        lblStatus.text = strMessage
        indicator.startAnimating()
    }
    
    private func stopIndicator(withErr: String? = nil) {
        indicator.stopAnimating()
        lblStatus.isHidden = true
        if let strErr = withErr {
            lblStatus.isHidden = false
            lblStatus.text = strErr
        }
    }
    
} //class
