//
//  Genre.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

public class Genre:NSObject, Codable, NSCoding{
    
    public var id:Int?
    public var name:String?
    
    init(id:Int, name:String){
        self.id   = id
        self.name = name
    }
    
    private enum Key:String{
        case id   = "id"
        case name = "name"
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id  , forKey: Key.id  .rawValue)
        coder.encode(name, forKey: Key.name.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        id   = coder.decodeObject(forKey: Key.id.rawValue)   as? Int
        name = coder.decodeObject(forKey: Key.name.rawValue) as? String
    }
}
