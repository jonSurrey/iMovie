//
//  LocalStorageManager.swift
//  Movies
//
//  Created by Jonathan Martins on 11/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import CoreData
import Foundation

// MARK: - LocalStorageManagerDelegate
protocol LocalStorageManagerDelegate {
    
    /// Loads the cached movies from the CoreData
    func loadCache()->[Movie]
    
    /// Saves a given list of movies in the CoreData
    func cache(_ movies:[Movie])
    
    /// Removes all cache  from CoreData
    func clearCache()
    
    /// Loads the movies that the user has favorited
    func loadFavorites()->[Movie]
    
    /// Saves a given movie favorited by the user
    func addToFavorite(_ movie:Movie)
    
    /// Deletes a given movie that the user has unfavorited
    func removeFromFavorite(_ movie:Movie)
    
    /// Checks if a movie exists in the favorite list
    func isMovieFavorite(_ movie:Movie) -> Bool
}

// MARK: - LocalStorageManager
class LocalStorageManager:LocalStorageManagerDelegate{
    
    private let ENTITY_CACHE    = "Cache"
    private let ENTITY_FAVORITE = "Favorite"
    
    /// The PersistentContainer's context. Responsible for the CoreData operations
    private var viewContext:NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func loadCache()->[Movie] {
        let items = loadEntity(named: ENTITY_CACHE)
        return toMovieArray(items)
    }
    
    func cache(_ movies: [Movie]) {
        clearCache()
        movies.forEach({ movie in
            save(movie, to: ENTITY_CACHE)
        })
    }
    
    func clearCache(){
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_CACHE)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch let error as NSError {
            print("Could not clear the records. \(error), \(error.userInfo)")
        }
    }
    
    func loadFavorites() -> [Movie] {
        let items = loadEntity(named: ENTITY_FAVORITE)
        return toMovieArray(items)
    }
    
    func addToFavorite(_ movie: Movie) {
        save(movie, to: ENTITY_FAVORITE)
    }
    
    func removeFromFavorite(_ movie: Movie) {
        guard let id = movie.id else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_FAVORITE)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        do{
            let result = try viewContext.fetch(fetchRequest)
            result.forEach({
                viewContext.delete($0 as! NSManagedObject)
            })
            try viewContext.save()
        } catch let error as NSError {
            print("Could not delete the favorite. \(error), \(error.userInfo)")
        }
    }

    func isMovieFavorite(_ movie:Movie) -> Bool{
        let movies = loadFavorites()
        let isMovieFavorite = movies.first(where: {$0.id == movie.id})
        return isMovieFavorite != nil ? true:false
    }
}

// MARK: - Private Functions
extension LocalStorageManager{
    
    /// Loads form CoreData the entity with the given name
    private func loadEntity(named:String)->[NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: named)
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    /// Saves a movie to CoreData
    private func save(_ movie:Movie, to entity:String){
    
        let entity = NSEntityDescription.entity(forEntityName: entity, in: viewContext)!
        let object = NSManagedObject(entity: entity, insertInto: viewContext)
        
        object.setValue(movie.id         , forKeyPath: "id")
        object.setValue(movie.url        , forKeyPath: "url")
        object.setValue(movie.title      , forKeyPath: "title")
        object.setValue(movie.genres     , forKeyPath: "genres")
        object.setValue(movie.overview   , forKeyPath: "overview")
        object.setValue(movie.releaseDate, forKeyPath: "releaseDate")

        do {
          try viewContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /// Converts a given [NSManagedObject] to [Movie]
    private func toMovieArray(_ items:[NSManagedObject])->[Movie]{
        var movies:[Movie] = []
        items.forEach({
            movies.append(Movie($0))
        })
        return movies
    }
}
