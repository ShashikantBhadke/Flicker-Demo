//
//  LoadingView.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 24/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    // MARK: Properties
    
    private struct Colors {
        static let pink = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        static let beige = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    let gradientLayer = CAGradientLayer()

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    // MARK: Setup

    private func setup() {
        gradientLayer.colors = [Colors.pink.cgColor, Colors.beige.cgColor, Colors.pink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.0, 0.4]
        layer.addSublayer(gradientLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: UIApplication.willEnterForegroundNotification, object: nil)
        startLoading()
    }
    
    // MARK: Animation
    
    @objc func startLoading() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1.5
        animation.fromValue = [0.0, 0.0, 0.4]
        animation.toValue = [0.4, 0.9, 1]
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "AsanaLoadingView")
    }
}
