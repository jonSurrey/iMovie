//
//  FavoriteMoviesViewController.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

// MARK: - FavoriteMoviesViewDelegate
protocol FavoriteMoviesViewDelegate:class{
    
    /// Shows a feedback message
    func showFeedback(message:String)
    
    /// Reloads and updates the UIViewController
    func updateFavoriteList()
}

// MARK: - FavoriteMoviesViewController
class FavoriteMoviesViewController:UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView:UITableView!
    
    // MARK: - Variable
    /// Controls the time to trigger the search
    private var timer:Timer?
    
    // MARK: - Constants
    /// The presenter responsible for this view's actions
    private let presenter = FavoriteMoviesPresenter()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.bind(to: self, storage: LocalStorageManager())
        setSearchController(title: "Favorite Movies", delegate:self)
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadFavoriteList()
    }
    
    // MARK: - Setup
    /// Configure the views and their actions
    private func configureViews(){
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerCell(from: FavoriteCell.self)
    }
}

// MARK: - UITableViewDelegate
extension FavoriteMoviesViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = presenter.itemFor(index: indexPath.row)
        let unfavoriteAct = UIContextualAction(style: .destructive, title: "Unfavorite", handler: { [weak self] (action, view, handler) in
            self?.presenter.unfavorite(movie)
            self?.presenter.loadFavoriteList()
        })
        return UISwipeActionsConfiguration(actions: [unfavoriteAct])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(from: FavoriteCell.self, at: indexPath)
        let item = presenter.itemFor(index: indexPath.row)
        
        cell.setupCell(movie: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectMovie(at: indexPath.row)
        performSegue(to: .movieDetail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailMovieViewController{
            if let movie = presenter.selectedMovie{
                detailViewController.setup(with: movie)
            }
        }
    }
}

// MARK: - FavoriteMoviesViewDelegate
extension FavoriteMoviesViewController:FavoriteMoviesViewDelegate{
    
    func showFeedback(message: String) {
        tableView.setEmptyView(title: "Ops!", message: message)
    }
    
    func updateFavoriteList() {
        tableView.reloadDataAnimated()
        tableView.hideEmptyMessage()
    }
}

// MARK: - UISearchResultsUpdating
extension FavoriteMoviesViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        triggerRequestForText(searchController.searchBar.text)
    }
    
    /// Triggers the timer to execute the filtering
    private func triggerRequestForText(_ term:String?){
        timer?.invalidate()
        if let text = term, !text.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                self?.presenter.filterMoviesBy(text)
            }
        }
        else{
            presenter.loadFavoriteList()
        }
    }
}
