//
//  UIViewController+Utils.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

enum Segue:String{
    
    case filter       = "segueFilter"
    case search       = "segueSearch"
    case movieDetail  = "segueDetailMovie"
    case filterDetail = "segueFilterDetail"
    
    var value:String{
        get{
            return self.rawValue
        }
    }
}

extension UIViewController{
    
    /// Ation to dismiss the ciurrent Viewcontroller
    @objc func closeViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Displays an alert with the given title and message
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Calls the next ViewController on StoryBoard
    func performSegue(to segue:Segue){
        performSegue(withIdentifier: segue.value, sender: nil)
    }
    
    /// Adds the SearchController to the View
    func setSearchController(title:String, delegate:UISearchResultsUpdating){
        self.title = title
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a movie"
        definesPresentationContext = true
    
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        // Customize the searchbar to be white
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .white
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = .white
                
                // Rounded corner
                backgroundview.clipsToBounds = true
                backgroundview.layer.cornerRadius = 5
            }
        }
    }
}
