//
//  SplashVC.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

final class SplashVC: UIViewController {

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pushListingVC()
        }
    }
    
    // MARK:- Push Controller
    private func pushListingVC() {
        guard let listingVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ListingVC.self)) as? ListingVC else { return }
        self.navigationController?.pushViewController(listingVC, animated: true)
    }
    
} //class

