//
//  UITableView+Utils.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Register a cell for the given UITableViewCell type
    func registerCell<T:UITableViewCell>(from type:T.Type){
        register(type, forCellReuseIdentifier: String(describing: T.self))
    }
    
    /// Returns a UITableViewCell for a given Class Type
    func getCell<T:UITableViewCell>(from type:T.Type, at indexPath:IndexPath)->T{
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    /// Reaload the UITableView animated
    func reloadDataAnimated(){
        let range    = NSMakeRange(0, self.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    /// Shows a message when the TableView is empty
    func setEmptyView(title: String, message: String) {
        
        let titleLabel   = UILabel()
        let messageLabel = UILabel()
        let emptyView    = UIView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))

        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .appColor(.primaryColor)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .darkGray
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor .constraint(equalTo: emptyView.centerXAnchor),
            titleLabel.bottomAnchor  .constraint(equalTo: emptyView.centerYAnchor , constant: -50),
            titleLabel.widthAnchor   .constraint(equalTo: emptyView.widthAnchor   , multiplier: 1/1.2),

            messageLabel.topAnchor     .constraint(equalTo: titleLabel.bottomAnchor  , constant: 10),
            messageLabel.leadingAnchor .constraint(equalTo: titleLabel.leadingAnchor , constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -20)
        ])

        self.separatorStyle = .none
        self.backgroundView = emptyView
    }
    
    /// Clears the Tableview backgroundView
    func hideEmptyMessage() {
        self.backgroundView = nil
    }
}
