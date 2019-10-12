//
//  SearchMoviesPresenter.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

// MARK: - SearchMoviesPresenterDelegate
protocol SearchMoviesPresenterDelegate:class{
    
    /// The number of items in the datasource
    var numberOfItems:Int{ get }

    /// Binds the view to this presenter
    func bind(to view:SearchMoviesViewDelegate, service:MovieService)
    
    /// Selects a movie from the datasource
    func itemFor(index:Int)->Movie
    
    /// Sets selected a movie in the datasource
    func selectMovie(at index:Int)
}

// MARK: - SearchMoviesPresenter
class SearchMoviesPresenter{
    
    /// Indicates the current page of the list of movies
    var currentPage:Int = 1
    
    // Indicates if the user is searching a movie by a given term
    var isSearching = false
    
    // The current search term
    var searchTerm:String? = nil
    
    /// The movie selected by the user
    var selectedMovie:Movie?
    
    /// The list of movies
    private var movies:[Movie] = []
    
    /// The service responsible for the requests
    private var service:MovieService!{
        didSet{
            service.delegate = self
        }
    }
    
    /// Callback to update the view
    private weak var view:SearchMoviesViewDelegate!
    
    /// Requests to search a movie by the given term
    func getMovies(page:Int = 1){
        currentPage = page
        isSearching = true
        view.showLoading()
        service.search(searchTerm, page)
    }
}

// MARK: - SearchMoviesPresenterDelegate
extension SearchMoviesPresenter:SearchMoviesPresenterDelegate{
    
    var numberOfItems:Int{
        return movies.count
    }
    
    func selectMovie(at index: Int) {
        selectedMovie = movies[index]
    }
    
    func bind(to view: SearchMoviesViewDelegate, service: MovieService) {
        self.view    = view
        self.service = service
    }
    
    func itemFor(index:Int)->Movie{
        return movies[index]
    }
}

// MARK: - MovieServiceDelegate
extension SearchMoviesPresenter:MovieServiceDelegate{

    func didReceiveMovies(_ movies: [Movie]) {
        if currentPage == 1{
            self.movies = movies
            if movies.isEmpty{
                view.showFeedback(message: "There is no movies with the search term you typed.")
            }
        }
        else{
           self.movies.append(contentsOf: movies)
        }
        view.hideLoading()
        view.updateMoviesList()
    }
    
    func onRequestError(_ error: String) {
        self.movies = []
        view.hideLoading()
        view.updateMoviesList()
        view.showFeedback(message: error)
    }
    
    func noInternetConection() {
        if currentPage == 1{
            if movies.isEmpty{
                 view.showFeedback(message: "It seems you are not connected to the internet")
             }
        }
        view.hideLoading()
        view.updateMoviesList()
    }
}
