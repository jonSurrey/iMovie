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
    
    /// The number of items in the datasource
    var numberOfItems:Int{ get }

    /// Binds the view to this presenter
    func bind(to view:PopularMoviesViewDelegate, service:MovieService, storage:LocalStorageManager)
    
    /// Selects a movie from the datasource
    func itemFor(index:Int)->Movie
    
    /// Sets selected a movie in the datasource
    func selectMovie(at index:Int)
    
    /// Removes the selects filters
    func clearFilters()
}

// MARK: - PopularMoviesPresenter
class PopularMoviesPresenter{
    
    // MARK: - Variables
    /// Indicates the current page of the list of movies
    var currentPage:Int = 1
    
    /// The movie selected by the user
    var selectedMovie:Movie?
    
    /// The possible filter of the request
    var filter = Filter()
    
    /// The list of movies
    private var movies:[Movie] = []
    
    /// The service responsible for the requests
    private var service:MovieService!{
        didSet{
            service.delegate = self
        }
    }
    
    /// Manager for the local storage
    private var storage:LocalStorageManager!
    
    /// Callback responsible for updating the view
    private weak var view:PopularMoviesViewDelegate!
    
    /// Perfomrs the request to the movies list
    func getMovies(page:Int = 1){
        currentPage = page
        view.showLoading()
        service.popular(page: page, filter)
    }
}

// MARK: - PopularMoviesPresenterDelegate
extension PopularMoviesPresenter:PopularMoviesPresenterDelegate{
    
    var numberOfItems:Int{
        return movies.count
    }
    
    func clearFilters() {
        filter.resetAll()
        view.showRemoveFiltersButton(false)
        
        getMovies()
    }
    
    func selectMovie(at index: Int) {
        selectedMovie = movies[index]
    }
    
    func bind(to view: PopularMoviesViewDelegate, service: MovieService, storage:LocalStorageManager) {
        self.view    = view
        self.service = service
        self.storage = storage
    }
    
    func itemFor(index:Int)->Movie{
        return movies[index]
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
