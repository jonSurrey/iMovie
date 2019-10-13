//
//  DetailMoviePresenter.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

// MARK: - DetailMoviePresenterDelegate
protocol DetailMoviePresenterDelegate {
    
    /// Binds a view to the presentes
    func bind(to view:DetailMovieViewDelegate, _ movie:Movie, service:MovieService, storage:LocalStorageManagerDelegate)
    
    /// Requests the details of the currnet movie
    func getMovieDetails()
    
    /// Adds or remos a movie to the favorite list
    func favorite()
}

// MARK: - DetailMoviePresenter
class DetailMoviePresenter{
    
    /// The movie being displayed
    private var movie:Movie!
    
    /// Indicates  if the current movie is favorite or not
    private var isFavorite = false
    
    /// Callback to update the view
    private weak var view:DetailMovieViewDelegate!
    
    /// The service responsible for the request
    private var service:MovieService!{
        didSet{
            service.delegate = self
        }
    }
    
    /// Manager for the local storage
    private var storage:LocalStorageManagerDelegate!
    
    /// Formats the array of genres into a plain String
    private func formatGenres(of movie:Movie)->String{
        if let genres = movie.genres, genres.count > 0{
             return genres.map{"\($0.name!)"}.joined(separator: ", ")
        }
        return ""
    }
    
    /// Formats the date to a/MMM/yyy
    private func formatDate(of movie:Movie)->String{
        return movie.releaseDate.formatDate(fromPattern: "yyyy-mm-dd", toPattern: "d MMMM yyyy")
    }
    
    /// Checks if the current movie is already in the favorite list
    private func checkMovieIsFavorite(_ movie:Movie) {
        isFavorite = storage.isMovieFavorite(movie)
        view.updateIsMovieFavorite(isFavorite)
    }
}

// MARK: - DetailMoviePresenterDelegate
extension DetailMoviePresenter:DetailMoviePresenterDelegate{
    
    func favorite() {
        if isFavorite{
            storage.removeFromFavorite(movie)
            view.updateIsMovieFavorite(false)
        }
        else{
            storage.addToFavorite(movie)
            view.updateIsMovieFavorite(true)
        }
    }
    
    func getMovieDetails() {
        view.showLoading()
        service.detail(of: movie)
    }
    
    func bind(to view: DetailMovieViewDelegate, _ movie:Movie, service:MovieService, storage:LocalStorageManagerDelegate) {
        self.view    = view
        self.movie   = movie
        self.service = service
        self.storage = storage
    }
}

// MARK: - MovieServiceDelegate
extension DetailMoviePresenter:MovieServiceDelegate{
    
    func didReceiveDetailOf(_ movie:Movie){
        
        view.hideLoading()
        checkMovieIsFavorite(movie)
        
        view.updateMovieTitle (movie.title)
        view.updateMoviePoster(movie.poster)
        view.updateMovieOverview(movie.overview)
        view.updateMovieGenre(formatGenres(of: movie))
        view.updateMovieReleaseDate(formatDate(of:movie))
    }
    
    func onRequestError(_ error: String) {
        view.hideLoading()
        view.showFeedback(error)
    }
    
    func noInternetConection() {
        view.hideLoading()
        view.showFeedback("It seems you are not connected to the internet")
    }
}
