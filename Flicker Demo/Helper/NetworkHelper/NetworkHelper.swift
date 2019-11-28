//
//  NetworkHelper.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 27/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    // MARK:- Internal Objects
    static let sharedInstance = NetworkHelper()
    private init(){}
    private var reachability : Reachability!
    
    // MARK:- Public Objects
    var isNetworkAvailable = false
    
    // MARK:- Public Methods
    func observeReachability() {
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    // MARK:- Private Methods
    @objc private func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular, .wifi:
            isNetworkAvailable = true
        case .none, .unavailable:
            isNetworkAvailable = false
        }
        debugPrint("🗼📱 Network Available Status - \(isNetworkAvailable)🗼📱")
        NotificationCenter.default.post(name: .NetworkChange, object: nil, userInfo: nil)
    }
    
} //class

// MARK:- Extension for Notification Objects
extension Notification.Name {
    static let NetworkChange = Notification.Name("NetworkChange")
} //extension
