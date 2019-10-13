//
//  LocalStorageManagerTests.swift
//  MoviesTests
//
//  Created by Jonathan Martins on 12/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import Movies

class LocalStorageManagerTests: XCTestCase {

    var storage:LocalStorageManagerDelegate!
    
    override func setUp() {
        storage = LocalStorageMock()
        storage.cache([Movie(id: 1, title: "Matrix"), Movie(id: 2, title: "Frozen"), Movie(id: 3, title: "Joker")])
    }
    
    func testLoadEmptyCachedMoviesList(){
        storage = LocalStorageMock()
        let cache = storage.loadCache()
        XCTAssertTrue(cache.isEmpty, "The cached movies list should be empty")
    }
    
    func testLoadCachedMoviesList(){
        let cache = storage.loadCache()
        XCTAssertFalse(cache.isEmpty, "The cached movies list should NOT be empty")
    }
    
    func testClearCachedMovies(){
        storage.clearCache()
        
        /// Expected result
        let result = storage.loadCache()
        XCTAssertTrue(result.isEmpty, "The cached movies list should be empty after calling the clear function")
    }
    
    func testLoadFavoriteMovies(){
        let result = storage.loadFavorites()
        XCTAssertEqual(result.count, 2, "The favorite list should have 2 items")
    }
    
    func testAddMovieToFavorites(){
        let movie = Movie(id: 3, title: "Interview with the Vampire")
        storage.addToFavorite(movie)
        
        let result = storage.loadFavorites()
        XCTAssertEqual(result.count, 3, "The favorite list should have 3 items")
    }
    
    func testRemoveMovieFromFavorites(){
        let movie = Movie(id: 1, title: "Matrix")
        storage.removeFromFavorite(movie)
        
        let result = storage.loadFavorites()
        XCTAssertEqual(result.count, 1, "The favorite list should have 3 items")
    }
    
    func testCheckMovieIsFavorite(){
        let movie  = Movie(id: 1, title: "Matrix")
        let result = storage.isMovieFavorite(movie)
        
        XCTAssertTrue(result, "The given movie should be favorite")
    }
    
    func testCheckMovieIsNotFavorite(){
        let movie  = Movie(id: 10, title: "Joker")
        let result = storage.isMovieFavorite(movie)
        
        XCTAssertFalse(result, "The given movie should not be a favorite")
    }
}

// MARK: - LocalStorageMock
class LocalStorageMock:LocalStorageManagerDelegate{
    
    private var movies:[Movie]    = []
    private var favorites:[Movie] = [Movie(id: 1, title: "Matrix"), Movie(id: 2, title: "Frozen")]
    
    func loadCache()->[Movie]{
        return movies
    }
    
    func cache(_ movies:[Movie]){
        self.movies = movies
    }
    
    func clearCache(){
        movies = []
    }
    
    func loadFavorites()->[Movie]{
        return favorites
    }
    
    func addToFavorite(_ movie:Movie){
        favorites.append(movie)
    }
    
    func removeFromFavorite(_ movie:Movie){
        favorites.removeAll(where: {
            movie.id == $0.id
        })
    }
    
    func isMovieFavorite(_ movie:Movie) -> Bool{
        return favorites.contains(where: { movie.id == $0.id })
    }
}
