//
//  SearchMoviesTests.swift
//  MoviesTests
//
//  Created by Jonathan Martins on 12/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import Movies

class SearchMoviesTests: XCTestCase {

    var view:SearchMoviesViewDelegate!
    var service:MovieServiceMock!
    var presenter:SearchMoviesPresenter!
    
    override func setUp() {
        view      = SearchMoviesViewMock()
        service   = MovieServiceMock()
        presenter = SearchMoviesPresenter()
    
        presenter.bind(to: view, service: service)
    }
    
    func testGetMoviesFilteringBySearchTerm(){
        XCTAssertTrue(presenter.movies.isEmpty, "The list of movies should be empty before the request")
        
        /// The text to be used as filter on the request
        let searchTerm = "Joker"
        
        /// Perfomrs the request
        presenter.searchTerm = searchTerm
        presenter.getMovies()
        
        /// Expected result
        XCTAssertEqual(presenter.movies.count, 1, "After the request the movies list should be equal to 1")
        XCTAssertEqual(presenter.movies[0].title, searchTerm, "After the request the movie result should be Joker")
    }
    
    func testGetMoviesFilteringByInexistentMovieName(){
        XCTAssertTrue(presenter.movies.isEmpty, "The list of movies should be empty before the request")
        
        /// The text to be used as filter on the request
        let searchTerm = "kvjchnj"
        
        /// Performs the request
        presenter.searchTerm = searchTerm
        presenter.getMovies()
        
        /// Expected result
        XCTAssertTrue(presenter.movies.isEmpty, "After the request the movies list should empty")
    }
}

// MARK: - SearchMoviesViewMock
class SearchMoviesViewMock:SearchMoviesViewDelegate{
    
    func showLoading() { }
    
    func hideLoading() { }
    
    func showFeedback(message: String) { }
    
    func updateMoviesList() { }
}
