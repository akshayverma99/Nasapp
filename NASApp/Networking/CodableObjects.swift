//
//  CodableObjects.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

struct postcardImage: Codable{
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey{
        case imageUrl = "img_src"
    }
}

struct imageArray: Codable{
    var photos: [postcardImage]
}

