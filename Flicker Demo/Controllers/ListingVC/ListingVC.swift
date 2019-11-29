//
//  ListingVC.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

final class ListingVC: BaseVC {
    
    // MARK:- Outlets    
    @IBOutlet private weak var viewLoading          : LoadingView!
    @IBOutlet internal weak var collectionView      : UICollectionView!
    @IBOutlet private weak var alViewLoadingHeight  : NSLayoutConstraint!
    
    // MARK:- Variables
    var intPage         = 1
    var isLoding        = false
    var arrPhoto        = [FlickrPhoto]()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        getDataInCoreDB()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callWebService()
        setUpCollectionView()
        self.showMessage("Hello there...")
    }
    
    // MARK:- Setup CollectionView
    private func setUpCollectionView() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setUpSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Nature"
        navigationItem.searchController = search
    }
    
    // MARK:- API Call
    func callWebService(strSearch: String = "Nature") {
        showIndicator()
        Constants.getListingfor(strSearch, intPage: intPage){ result in
            switch result {
            case .success(let arrData):
                if let arr = arrData.photos?.photo, !arr.isEmpty {
                    self.intPage += 1
                    for newObj in arr {
                        if !self.arrPhoto.contains(newObj) {
                            self.arrPhoto.append(newObj)
                        }
                    }
                    self.collectionView.reloadData()
                    if self.intPage == 2 || arr.count < 20 {
                        self.saveDataInCoreDB(arr)
                    }
                } 
                if self.arrPhoto.isEmpty {
                    self.stopIndicator()
                } else {
                    self.stopIndicator()
                }
            case .error(let strErr):
                self.stopIndicator()
                self.showMessage(strErr)
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
                self.showMessage("No data to save in side coreDB")
            }
        } catch let errDocadable {
            self.showMessage(errDocadable.localizedDescription)
        }
    }
    
    func getDataInCoreDB() {
        showIndicator()
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
                        self.showMessage("No data from coreDB to show listing")
                    }
                } catch let errDocadable {
                    self.showMessage(errDocadable.localizedDescription)
                }
                
            case .error(let strErr):
                self.showMessage(strErr)
            }
            self.stopIndicator()
        }
    }
    
    // MARK:- Indicator Methods
    private func showIndicator() {
        isLoding = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.alViewLoadingHeight.constant = 3
            }
        }
    }
    
    private func stopIndicator() {
        isLoding = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.alViewLoadingHeight.constant = 0
            }
        }
    }
    
    // MARK:- Network Change Called
    override func networkChanged(_ status: Bool = NetworkHelper.sharedInstance.isNetworkAvailable) {
        showMessage(status ? "You are online now.." : "Please check your network connection...")
        guard status else { return }
        intPage = 0
        callWebService()
        
    }
    
    // MARK:- Show Toast
    func showMessage(_ strMessage: String) {
        self.view.makeToast(strMessage, duration: 3.0, position: .bottom)
    }
    
} //class
