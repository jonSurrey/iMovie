//
//  Movie.swift
//  Movies
//
//  Created by Jonathan Martins on 10/09/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation
import CoreData

struct Movie:Codable{

    let id:Int?
    let url:String?
    let title:String?
    let genres:[Genre]?
    let overview:String?
    let releaseDate:String?
    var poster: String? {
        get{
            if let url = url{
                return "https://image.tmdb.org/t/p/w500/\(url)"
            }
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id          = "id"
        case title       = "original_title"
        case genres      = "genres"
        case overview    = "overview"
        case url         = "poster_path"
        case releaseDate = "release_date"
    }
    
    init(id:Int, title:String, genres:[Genre] = []){
        self.id          = id
        self.url         = "www.test.com"
        self.title       = title
        self.genres      = genres
        self.overview    = "Description"
        self.releaseDate = "00/00/0000"
    }
    
    init(id:Int, url:String, title:String, genres:[Genre], overview:String, releaseDate:String){
        self.id          = id
        self.url         = url
        self.title       = title
        self.genres      = genres
        self.overview    = overview
        self.releaseDate = releaseDate
    }
    
    init(_ object:NSManagedObject){
        id          = object.value(forKey: "id")          as? Int
        url         = object.value(forKey: "url")         as? String
        title       = object.value(forKey: "title")       as? String
        genres      = object.value(forKey: "genres")      as? [Genre]
        overview    = object.value(forKey: "overview")    as? String
        releaseDate = object.value(forKey: "releaseDate") as? String
    }
}
