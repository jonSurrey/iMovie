//
//  UIImageView+Utils.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.``````````
//

import UIKit
import Alamofire
import Foundation
import AlamofireImage

extension UIImageView {
    
    // Loads an URL to the UIImageVIew
    func load(_ url: String?){
        DataRequest.addAcceptableImageContentTypes(["image/*"])
        self.image = nil
        if let urlImage = url, let urlImagePath = URL(string: urlImage) {
            self.af_setImage(withURL: urlImagePath, placeholderImage: nil, filter: nil, imageTransition: .crossDissolve(0.1), completion: nil)
        }
    }
}
