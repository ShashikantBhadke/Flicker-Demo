//
//  ListingVC.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

var isOffline = false

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
        getDataInCoreDB()
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
                        for var newObj in arr {
                            if !self.arrPhoto.contains(newObj) {
                                newObj.isNew = true
                                self.arrPhoto.append(newObj)
                                let indexPath = IndexPath(item: self.arrPhoto.count - 1, section: 0)
                                self.collectionView.insertItems(at: [indexPath])
                            }
                        }
                        self.saveDataInCoreDB(arr)
                        isOffline = false
                    } else {
                        isOffline = true
                    }
                    
                    if self.arrPhoto.isEmpty {
                        self.stopIndicator(withErr: "No data available right now.")
                    } else {
                        self.stopIndicator()
                    }
                }
            case .error(let strErr):
                debugPrint(strErr)
                DispatchQueue.main.async {
                    if self.arrPhoto.isEmpty {
                        self.stopIndicator(withErr: "No data available right now.")
                    } else {
                        self.stopIndicator()
                    }
                }
            }
        }
    }

    func saveDataInCoreDB(_ _arrData: [FlickrPhoto]) {
        guard !_arrData.isEmpty else { return }
        do {
            let arrData = try JSONEncoder().encode(_arrData)
            if !arrData.isEmpty {
                CoreDataHelper.saveData(arrData, table: .FlickrListing)
            } else {
                debugPrint("No data to save in side coreDB")
            }
        } catch let errDocadable {
            debugPrint(errDocadable.localizedDescription)
        }
    }
    
    func getDataInCoreDB() {
        CoreDataHelper.getLastData(.FlickrListing) { (result) in
            switch result {
            case .success(let data):
                guard !data.isEmpty else { return }
                do {
                    let arrData = try JSONDecoder().decode([FlickrPhoto].self, from: data)
                    if !arrData.isEmpty {
                        self.arrPhoto.insert(contentsOf: arrData, at: 0)
                        self.stopIndicator()
                        self.collectionView.reloadData()
                    } else {
                        debugPrint("No data from coreDB to show listing")
                    }
                } catch let errDocadable {
                    debugPrint(errDocadable.localizedDescription)
                }
                
            case .error(let strErr):
                debugPrint(strErr)
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
