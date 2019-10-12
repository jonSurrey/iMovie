//
//  Filter.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

class Filter {

    /// Indicates the genre of the movie
    var genre:Genre?
    
    /// Indicates the date of the movie
    var date:String?

    /// Resets all filters
    func resetAll(){
        date  = nil
        genre = nil
    }
}
