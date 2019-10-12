//
//  Result.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

struct Result:Codable{
    
    let movies:[Movie]?
    let genres:[Genre]?
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
        case genres = "genres"
    }
}
