//
//  SearchMoviesViewController.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

// MARK: - Outlets
protocol SearchMoviesViewDelegate:class{
    
    /// Displays the loading on the view
    func showLoading()
    
    /// Hides the loading on the view
    func hideLoading()
    
    /// Shows  a feedback message
    func showFeedback(message:String)
    
    /// Updates the list of movies
    func updateMoviesList()
}

// MARK: - Outlets
class SearchMoviesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView:UICollectionView!
    
    // MARK: - Variables
    /// Controls the time to trigger the search
    private var timer:Timer?
    
    // Controls if the list is loading more items
    private var isLoadingMore = false

    // Controls the Scroll's last position
    private var lastOffset: CGFloat = 0.0
    
    // MARK: - Constants
    /// The RefreshControl that indicates when the list is updating
    private let refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .appColor(.primaryColor)
        return refreshControl
    }()
    
    // The presente responsible for the logic of this ViewController
    private let presenter = SearchMoviesPresenter()
    
    /// StorageManager to inject our service
    private let storage = LocalStorageManager()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.bind(to: self, service: MovieService())
        setSearchController(title:"Search", delegate:self)
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMoviesList()
    }
    
    // MARK: - Setup
    /// Sets up the collectionView
    private func setupViews(){
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .appColor(.secondaryColor)
        collectionView.contentOffset = CGPoint(x:0, y:-refreshControl.frame.size.height)
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        collectionView.registerCell(from: MovieCell.self)
        
        let close = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem = close
    }
}

// MARK: - Actions
extension SearchMoviesViewController{
    
    /// Triggers the pull to refresh to update the list
    @objc private func refreshAction(){
        presenter.getMovies()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchMoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width/3.4, height: view.bounds.size.height/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}

// MARK: - UICollectionViewDelegate
extension SearchMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(from: MovieCell.self, at: indexPath)
        let movie      = presenter.itemFor(index: indexPath.row)
        let isFavorite = storage.isMovieFavorite(movie)
        cell.setupCell(movie: movie, isFavorite: isFavorite)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectMovie(at: indexPath.row)
        performSegue(to:.movieDetail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailMovieViewController{
            if let movie = presenter.selectedMovie{
                detailViewController.setup(with: movie)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SearchMoviesViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        triggerRequestForText(searchController.searchBar.text)
    }
    
    /// Triggers the timer to execute the filtering
    private func triggerRequestForText(_ term:String?){
        guard let text = term, !text.isEmpty else{
            return
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            print("Filtering movie with name: \(text)...")
            self?.presenter.searchTerm = text
            self?.presenter.getMovies()
        }
    }
}

// MARK: - ScrollViewDelegate
extension SearchMoviesViewController{
    
    // Load more items when the collectionView's scrolls reach
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView && presenter.numberOfItems != 0{
            navigationItem.searchController?.searchBar.endEditing(true)
            
            let contentOffset = scrollView .contentOffset.y
            let maximumOffset = (scrollView.contentSize.height - scrollView.frame.size.height)
            
            // Checks if it is the end of the scroll
            if(contentOffset >= maximumOffset){
                if(!isLoadingMore){
                    isLoadingMore = true
                    presenter.currentPage+=1
                    presenter.getMovies(page: presenter.currentPage)
                    print("Loading more movies from page \(presenter.currentPage)...")
                }
            }
        }
    }
}

// MARK: - SearchMoviesViewDelegate
extension SearchMoviesViewController:SearchMoviesViewDelegate{
    
    func updateMoviesList() {
        isLoadingMore = false
        collectionView.reloadData()
    }
    
    func showLoading() {
        refreshControl.beginRefreshing()
        collectionView.hideEmptyMessage()
    }
    
    func hideLoading() {
        refreshControl.endRefreshing()
    }
    
    func showFeedback(message: String) {
        collectionView.setEmptyView(title: "Ops!", message: message)
    }
}

