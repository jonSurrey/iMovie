//
//  FilterCell.swift
//  Movies
//
//  Created by Jonathan Martins on 11/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

/// The cell for the filter's items
class FilterCell:UITableViewCell {
    
    // The filter's title
    private let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // The filter's option
    private let option: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        
        accessoryType  = .disclosureIndicator
        selectionStyle = .none
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds the constraints to the views in this cell
    private func setupConstraints(){
        self.contentView.addSubview(title)
        self.contentView.addSubview(option)
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:10),
            option.centerYAnchor.constraint(equalTo:  self.contentView.centerYAnchor),
            option.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:-10)
        ])
    }
    
    /// Configures the cell
    func setupCell(item:(name: String, type: FilterOption), _ filter:Filter){
        title.text = item.name
        switch item.type {
            case .date:
                option.text = filter.date
            case .genre:
                option.text = filter.genre?.name
        }
    }
}

/// The footer for the apply button
class FilterFooterCell: UIView{
    
    // The "apply" button
    let buttonApply: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.primaryColor)
        button.cornerRadius = 23
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(buttonApply)
        NSLayoutConstraint.activate([
            buttonApply.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonApply.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonApply.widthAnchor  .constraint(equalToConstant: 213),
            buttonApply.heightAnchor .constraint(equalToConstant: 45),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
