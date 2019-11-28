//
//  BaseVC.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 27/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(observeNetworkChange(_:)), name: .NetworkChange, object: nil)
    }

    // MARK:- Notification Observer
    @objc private func observeNetworkChange(_ notif: Notification) {
        DispatchQueue.main.async {
            self.networkChanged()
        }
    }
    
    // MARK:- Custom Methods
    func networkChanged(_ status: Bool = NetworkHelper.sharedInstance.isNetworkAvailable) {
        debugPrint("networkChanged parent")
    }

} //class
