//
//  PopularMoviesPresenter.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

// MARK: - PopularMoviesPresenterDelegate
protocol PopularMoviesPresenterDelegate:class{
    
    /// The list of movies
    var movies:[Movie] { get set}

    /// Binds the view to this presenter
    func bind(to view:PopularMoviesViewDelegate, service:MovieService, storage:LocalStorageManagerDelegate)
    
    /// Perfomrs the request to the movies list
    func getMovies(page:Int)
    
    /// Removes the selects filters
    func clearFilters()
}

// MARK: - PopularMoviesPresenterDelegate Default Implementation
extension PopularMoviesPresenterDelegate{

    func getMovies(page:Int = 1){}
}

// MARK: - PopularMoviesPresenter
class PopularMoviesPresenter{
    
    // MARK: - Variables
    var movies:[Movie] = []
    
    /// Indicates the current page of the list of movies
    var currentPage:Int = 1
    
    /// The movie selected by the user
    var selectedMovie:Movie?
    
    /// The possible filter of the request
    var filter = Filter()
    
    /// The number of items in the datasource
    var numberOfItems:Int{
        return movies.count
    }
    
    /// The service responsible for the requests
    private var service:MovieService!{
        didSet{
            service.delegate = self
        }
    }
    
    /// Manager for the local storage
    private var storage:LocalStorageManagerDelegate!
    
    /// Callback responsible for updating the view
    private weak var view:PopularMoviesViewDelegate!
    
    /// Sets selected a movie in the datasource
    func selectMovie(at index: Int) {
        selectedMovie = movies[index]
    }
}

// MARK: - PopularMoviesPresenterDelegate
extension PopularMoviesPresenter:PopularMoviesPresenterDelegate{
    
    func getMovies(page:Int = 1){
        currentPage = page
        view.showLoading()
        service.popular(page: page, filter)
    }
    
    func clearFilters() {
        filter.resetAll()
        view.showRemoveFiltersButton(false)
        
        getMovies()
    }

    func bind(to view: PopularMoviesViewDelegate, service: MovieService, storage:LocalStorageManagerDelegate) {
        self.view    = view
        self.service = service
        self.storage = storage
    }
}

// MARK: - MovieServiceDelegate
extension PopularMoviesPresenter:MovieServiceDelegate{

    func didReceiveMovies(_ movies: [Movie]) {
        if currentPage == 1{
            storage.cache(movies)
            self.movies = movies
            if movies.isEmpty{
                view.showFeedback(message: "Ops... Something went wrong. Please, try again.")
            }
        }
        else{
           self.movies.append(contentsOf: movies)
        }
        view.hideLoading()
        view.updateMoviesList()
    }
    
    func onRequestError(_ error: String) {
        movies = []
        view.hideLoading()
        view.updateMoviesList()
        view.showFeedback(message: error)
    }
    
    func noInternetConection() {
        if currentPage == 1{
            movies = storage.loadCache()
            if movies.isEmpty{
                 view.showFeedback(message: "It seems you are not connected to the internet")
             }
        }
        view.hideLoading()
        view.updateMoviesList()
    }
}
