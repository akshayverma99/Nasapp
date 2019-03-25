//
//  UrlCreator.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import UIKit

class UrlCreator{
    
    static var imagesUrl: URL = {
        var url = URLComponents.init(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos")
        url?.queryItems = [URLQueryItem(name: "api_key", value: "dXPVgZdkjQWrhB5HVKUUMMw2nHQmiPN9efrDD8G2"),
                           URLQueryItem(name: "sol", value: "1000")
        ]
        
        // Should not crash because its been checked but want to fatalError in case the Url is wrong
        return url!.url!
        
    }()
    
}
