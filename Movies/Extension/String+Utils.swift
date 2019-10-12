//
//  String+Util.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {

    /// Converts a string date to a given format
    func formatDate(fromPattern:String, toPattern: String)->String{
        guard let date = self else{
            return "NaN"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromPattern
        dateFormatter.locale     = Locale(identifier: "en")
        
        if let date = dateFormatter.date(from: date){
            dateFormatter.dateFormat = toPattern
            return dateFormatter.string(from: date)
        }
        
        return "NaN"
    }
}
