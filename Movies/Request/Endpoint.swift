//
//  Endpoint.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

// Enum of the endpoints used by the app. All the endpoints used in the requests must be added here
enum Endpoint:String{
    
    case detail = "movie"
    case search = "search/movie"
    case movies = "discover/movie"
    case genres = "genre/movie/list"
    case apiKey = "954394990cb9c14c975548df90254c44"

    /// The absolute  address of the requests
    var address:String{
        get{
            return "https://api.themoviedb.org/3/\(self.rawValue)"
        }
    }
    
    /// The endpoint's value
    var value:String{
        get{
            return self.rawValue
        }
    }
    
    /// Adds a sulfix to the end of the address
    func add(_ sulfix:String)->String{
        return "\(address)/\(sulfix)"
    }
}
