//
//  FavoriteTests.swift
//  MoviesTests
//
//  Created by Jonathan Martins on 12/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import Movies

class FavoritesMoviesTests: XCTestCase {

    var view:FavoriteMoviesViewDelegate!
    var storage:LocalStorageManagerDelegate!
    var presenter:FavoriteMoviesPresenter!
    
    override func setUp() {
        view      = FavoritesMoviesViewMock()
        storage   = LocalStorageMock()
        presenter = FavoriteMoviesPresenter()
    
        presenter.bind(to: view, storage: storage)
    }
    
    func testLoadFavoriteMoviesList(){
        XCTAssertTrue(presenter.movies.isEmpty, "The list of movies should be empty before loading the favorites")
        presenter.loadFavoriteList()
        XCTAssertFalse(presenter.movies.isEmpty, "The list of movies should not be empty after loading the favorites")
    }
    
    func testUnfavoriteMovie(){
        
        // First we load the favorite list
        presenter.loadFavoriteList()
        XCTAssertEqual(presenter.movies.count, 2, "The number of favorited movies should be 2")
        
        /// The movie to be unfavorited
        let movie = Movie(id: 2, title: "Frozen")
        
        /// Performs the action
        presenter.unfavorite(movie)
        
        /// Expected result after the action
        XCTAssertEqual(presenter.movies.count, 1, "The number of favorited movies should be 1")
    }
    
    func testFilterFavoriteMoviesByTitle(){
        
        /// First we load the favorite list
        presenter.loadFavoriteList()
        XCTAssertEqual(presenter.movies.count, 2, "The number of favorited movies should be 2")
        
        /// Performs the filter action
        presenter.filterMoviesBy("Mat")
        
        /// The expecte result
        XCTAssertEqual(presenter.movies[0].title, "Matrix", "The filtered movie should be Matrix")
    }
}

// MARK: - FavoritesMoviesViewMock
class FavoritesMoviesViewMock:FavoriteMoviesViewDelegate{
    
    func showFeedback(message:String){ }
    
    func updateFavoriteList(){ }
}
