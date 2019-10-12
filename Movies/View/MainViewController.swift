//
//  MainViewController.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }
    
    /// Creates the main view of the app with it`s respective tabs
    private func setupTabBarController(){
        
        /// Sets the selected colour for the icons and the
        self.tabBar.tintColor       = .appColor(.primaryColor)
        self.tabBar.backgroundColor = .white
    }
}
