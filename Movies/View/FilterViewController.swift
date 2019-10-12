//
//  FilterViewController.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

// MARK: - FilterDelegate
protocol FilterDelegate:class {
    
    /// Notifies the caller about the selected filters
    func didSelectFilter(_ filter:Filter)
}

// MARK: -
class FilterViewController: UITableViewController {
    
    // MARK: - Constants
    /// The filters'options
    private let items = [(name: "Date", type: FilterOption.date), (name: "Genre", type: FilterOption.genre)]
    
    /// The object that holds the filters
    private let filter = Filter()
    
    // MARK: - Varibles
    /// The filter option to be selected
    private var selectedOption:FilterOption!
    
    /// Callback to the notify the caller of the selected filter
    weak var delegate:FilterDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Setup's
    /// Adds the close button and title to the Controller
    private func configureNavigationBar(){
        self.title = "Filter"
        let close = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem = close
    }
    
    /// Sets up the tableview
    private func setupTableView(){
        self.tableView.registerCell(from: FilterCell.self)
        let footer = FilterFooterCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        footer.buttonApply.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        tableView.tableFooterView = footer
    }
    
    /// Apply the filters
    @objc private func applyFilters(){
        delegate?.didSelectFilter(filter)
        closeViewController()
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(from: FilterCell.self, at: indexPath)
        cell.setupCell(item: items[indexPath.row], filter)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].type {
            case .date:
                selectedOption = .date
                break
            case .genre:
                selectedOption = .genre
                break
        }
        performSegue(to: .filterDetail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterDetailViewController = segue.destination as? FilterDetailViewController{
            filterDetailViewController.delegate     = self
            filterDetailViewController.filterOption = selectedOption
        }
    }
}

// MARK: - FilterOptionDelegate
extension FilterViewController:FilterOptionDelegate {
    
    func didSelectGenre(_ genre: Genre?) {
        filter.genre = genre
    }
    
    func didSelectYear(_ year: String?) {
        filter.date = year
    }
}
