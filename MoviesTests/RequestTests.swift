//
//  RequestTests.swift
//  MoviesTests
//
//  Created by Jonathan Martins on 12/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import Movies

class RequestTests: XCTestCase {
    
    var service:MovieServiceMock!
    
    override func setUp() {
        service = MovieServiceMock()
    }
    
    func testGetMovies(){
        
    }
    
    func testGetMoviesFilteringByGivenGenre(){
        
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

class MovieServiceMock:MovieService{
    
    private let movies = [Movie(id: 1, title: "Matrix"   , genres: [Genre(id: 1, name: "Fiction")]),
                          Movie(id: 2, title: "Lion King", genres: [Genre(id: 1, name: "Adventure")]),
                          Movie(id: 3, title: "Aladdin"  , genres: [Genre(id: 1, name: "Animation")]),
                          Movie(id: 4, title: "Joker"    , genres: [Genre(id: 1, name: "Drama")])]
    
    private let movieGenres = [Genre(id: 1, name: "Action"),
                               Genre(id: 2, name: "Fiction"),
                               Genre(id: 3, name: "Adventure")]
    
    override func popular(page: Int, _ filter:Filter){
        let filtered = movies.filter({
            $0.genres!.contains(where: { (genre) -> Bool in
                genre.id == filter.genre!.id
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
