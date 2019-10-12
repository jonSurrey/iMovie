//
//  FilterDetailViewController.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

// MARK: - FilterOption
enum FilterOption{
    case date
    case genre
}

// MARK: - FilterOptionDelegate
protocol FilterOptionDelegate:class {
    
    /// The filter genre selected by the user
    func didSelectGenre(_ genre:Genre?)
    
    /// The filter year selected by the user
    func didSelectYear(_ year:String?)
}

// MARK: - FilterDetailViewDelegate
protocol FilterDetailViewDelegate:class {
    
    /// Updates the options of the current filter
    func updateFilterList()
}

// MARK: - FilterDetailViewController
class FilterDetailViewController: UITableViewController {

    // MARK: - Varibles
    /// Indicates which items the controller will display
    var filterOption:FilterOption = .date
    
    /// Callback to notify the caller about the selcted filter option
    weak var delegate:FilterOptionDelegate?
    
    // MARK: - Constants
    /// The preseter responsible for the implemnetation of the controller
    private let presenter = FilterDetailPresenter()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.bind(to: self, MovieService())
        setupTableViewController()
    }
    
    // MARK: - Setup
    /// Sets up the TableViewController
    private func setupTableViewController(){
        switch filterOption {
            case .date:
                self.title = "Date"
                break
            case .genre:
                self.title = "Genres"
                presenter.getGenres()
                break
        }
    
        self.tableView.tableFooterView = UIView()
        self.tableView.registerCell(from: UITableViewCell.self)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterOption {
            case .date:
                return presenter.numberOfDates
            case .genre:
                return presenter.numberOfGenres
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(from: UITableViewCell.self, at: indexPath)
        switch filterOption {
            case .date:
                cell.textLabel?.text = presenter.dates[indexPath.row]
            case .genre:
                cell.textLabel?.text = presenter.genres[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filterOption {
            case .date:
                let year = presenter.dates[indexPath.row]
                delegate?.didSelectYear(year)
                break
            case .genre:
                let genre = presenter.genres[indexPath.row]
                delegate?.didSelectGenre(genre)
                break
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - FilterDetailViewDelegate
extension FilterDetailViewController:FilterDetailViewDelegate{
    
    func updateFilterList() {
        self.tableView.reloadData()
    }
}
