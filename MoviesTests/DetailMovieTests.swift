//
//  DetailMovieTests.swift
//  MoviesTests
//
//  Created by Jonathan Martins on 13/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import Movies

class DetailMovieTests: XCTestCase {

    var view:DetailMovieViewDelegate!
    var service:MovieServiceMock!
    var storage:LocalStorageManagerDelegate!
    var presenter:DetailMoviePresenter!
    
    override func setUp() {
        view      = DetailMoviesViewMock()
        service   = MovieServiceMock()
        storage   = LocalStorageMock()
        presenter = DetailMoviePresenter()
        
        /// The movie to display the datails
        let movie = Movie(id: 1, title: "Interview with the Vampire")
    
        presenter.bind(to: view, movie, service: service, storage: storage)
    }
    
    func testGetMovieDetails(){
        
    }
    
    func testFavoriteMovie(){
        
    }
    
    func testUnfavoriteMovie(){
        
    }
}


// MARK: - DetailMoviesViewMock
class DetailMoviesViewMock:DetailMovieViewDelegate{
    
    func showLoading() { }
    
    func hideLoading() { }
    
    func updateMoviePoster(_ url: String?) { }
    
    func updateMovieTitle(_ title: String?) { }
    
    func updateMovieGenre(_ genres: String?) { }
    
    func updateMovieReleaseDate(_ date: String?) { }
    
    func updateMovieOverview(_ overview: String?) { }
    
    func updateIsMovieFavorite(_ isFavorite: Bool) { }
    
    func showFeedback(_ message: String) { }
}
