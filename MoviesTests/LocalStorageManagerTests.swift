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
    }
    
    func testLoadCachedMovies(){
        
    }
    
    func testCacheMovies(){
        
    }
    
    func testClearMoviesCache(){
        
    }
    
    func testLoadFavoriteMovies(){
        
    }
    
    func testAddMovieToFavorites(){
        
    }
    
    func testRemoveMovieFromFavorite(){
        
    }
    
    func testCheckMovieIsFavorite(){
        
    }
    
    func testCheckMovieIsNotFavorite(){
        
    }
}

class LocalStorageMock:LocalStorageManagerDelegate{
    
    private var movies:[Movie]    = []
    private var favorites:[Movie] = []
    
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
