//
//  PopularMoviesTests.swift
//  MoviesTests
//
//  Created by Jonathan Martins on 12/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import Movies

class PopularMoviesTests: XCTestCase {

    var view:PopularMoviesViewDelegate!
    var service:MovieServiceMock!
    var storage:LocalStorageManagerDelegate!
    var presenter:PopularMoviesPresenter!
      
    override func setUp() {
        view      = PopularMoviesViewMock()
        service   = MovieServiceMock()
        storage   = LocalStorageMock()
        presenter = PopularMoviesPresenter()
        
        presenter.bind(to: view, service: service, storage: storage)
    }
    
    func testGetMovies(){
        XCTAssertTrue(presenter.movies.isEmpty, "The list of movies should be empty before the request")
        presenter.getMovies()
        XCTAssertFalse(presenter.movies.isEmpty, "The list of movies should not be empty after the request")
    }
    
    func testGetMoviesFilteringByGivenGenre(){
        XCTAssertTrue(presenter.movies.isEmpty, "The list of movies should be empty before the request")
        
        // The genre to be used as filter
        let filter = Filter()
        filter.genre = Genre(id: 1, name: "Fiction")
        
        // Performs the request with the filter
        presenter.filter = filter
        presenter.getMovies()
        
        XCTAssertEqual(presenter.movies.count, 1, "After the request the movies list should be equal to 1")
        
        /// Expected result
        let movie = presenter.movies[0]
        XCTAssertEqual(movie.genres?[0].name, filter.genre?.name, "The genre of the resulted movie should be the same as the filter")
    }
    
    func testSearchMoviesWithGivenTerm(){
        
    }
    
    func testGetMovieDetails(){
        
    }
    
    func testGetGenres(){
        
    }
    
    func testNoInternetConectionAvailable(){
        
    }
    
    func testRequestError(){
        
    }
}

// MARK: - PopularMoviesViewMock
class PopularMoviesViewMock:PopularMoviesViewDelegate{
    
    func showLoading() { }
    
    func hideLoading() { }
    
    func showFeedback(message: String) { }
    
    func updateMoviesList() { }
    
    func showRemoveFiltersButton(_ show: Bool) { }
}

// MARK: - MovieServiceMock
class MovieServiceMock:MovieService{
    
    private let movies = [Movie(id: 1, title: "Matrix"   , genres: [Genre(id: 1, name: "Fiction")]),
                          Movie(id: 2, title: "Lion King", genres: [Genre(id: 2, name: "Adventure")]),
                          Movie(id: 3, title: "Aladdin"  , genres: [Genre(id: 3, name: "Animation")]),
                          Movie(id: 4, title: "Joker"    , genres: [Genre(id: 4, name: "Drama")])]
    
    private let movieGenres = [Genre(id: 1, name: "Action"),
                               Genre(id: 2, name: "Fiction"),
                               Genre(id: 3, name: "Adventure")]
    
    override func popular(page: Int, _ filter:Filter){
        let filtered = movies.filter({
            $0.genres!.contains(where: { (genre) -> Bool in
                genre.id == filter.genre?.id
            })
        })
        delegate?.didReceiveMovies(filtered.isEmpty ? movies:filtered)
    }
    
    override func search(_ term:String?, _ page: Int = 1){
        let filtered = movies.filter({$0.title == term})
        delegate?.didReceiveMovies(filtered)
    }
    
    override func detail(of movie:Movie){
        let movie = movies.filter({$0.id == movie.id}).first!
        delegate?.didReceiveDetailOf(movie)
    }
    
    override func genres(){
        delegate?.didReceiveGenres(movieGenres)
    }
    
    func noInternetConnection(){
        delegate?.noInternetConection()
    }
    
    func didFailToCompleteRequest(){
        delegate?.onRequestError("didFailToCompleteRequest")
    }
}
