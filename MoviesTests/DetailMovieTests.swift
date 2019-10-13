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

    var view:DetailMoviesViewMock!
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
        
        XCTAssertFalse(view.didReceivePoster  , "poster should be false before caaling the request")
        XCTAssertFalse(view.didReceiveTitle   , "title be false before caaling the request")
        XCTAssertFalse(view.didReceiveGenre   , "genre be false before caaling the request")
        XCTAssertFalse(view.didReceiveDate    , "date be false before caaling the request")
        XCTAssertFalse(view.didReceiveOverview, "overview be false before caaling the request")
        
        presenter.getMovieDetails()
        
        XCTAssertTrue(view.didReceivePoster  , "poster should be true after caaling the request")
        XCTAssertTrue(view.didReceiveTitle   , "title should be true after caaling the request")
        XCTAssertTrue(view.didReceiveGenre   , "genre should be true after caaling the request")
        XCTAssertTrue(view.didReceiveDate    , "date should be true after caaling the request")
        XCTAssertTrue(view.didReceiveOverview, "overview should true after before caaling the request")
    }
    
    func testFavoriteMovie(){
        XCTAssertFalse(view.isFavorite, "The movie should not be favorite before calling the favorite action")
        presenter.favorite()
        XCTAssertTrue(view.isFavorite, "The movie should be favorte after calling th favorite action")
    }
    
    func testUnfavoriteMovie(){
        
        /// First we favorite a movie
        presenter.favorite()
        XCTAssertTrue(view.isFavorite, "The movie should be favorite calling the favorite action")
        
        /// Calling again the function should neagte the first operation
        presenter.favorite()
        XCTAssertFalse(view.isFavorite, "The movie should not be favortie after calling th favorite action again")
    }
}


// MARK: - DetailMoviesViewMock
class DetailMoviesViewMock:DetailMovieViewDelegate{
    
    var didReceivePoster = false
    var didReceiveTitle = false
    var didReceiveGenre = false
    var didReceiveDate = false
    var didReceiveOverview = false
    
    var isFavorite = false
    
    func showLoading() { }
    
    func hideLoading() { }
    
    func showFeedback(_ message: String) { }
    
    func updateIsMovieFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    func updateMoviePoster(_ url: String?) {
        didReceivePoster = true
    }
    
    func updateMovieTitle(_ title: String?) {
        didReceiveTitle = true
    }
    
    func updateMovieGenre(_ genres: String?) {
        didReceiveGenre = true
    }
    
    func updateMovieReleaseDate(_ date: String?) {
        didReceiveDate = true
    }
    
    func updateMovieOverview(_ overview: String?) {
        didReceiveOverview = true
    }
}
