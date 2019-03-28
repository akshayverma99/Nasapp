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

struct satImage: Codable{
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey{
        case imageUrl = "url"
    }
}

struct imageArray: Codable{
    var photos: [postcardImage]
}

struct wrapperCollection: Codable{
    var collection: itemsArray
}

public struct itemsArray: Codable{
    var items: [Item]
}

struct Item: Codable{
    var href: String?
}

struct imageHolder{
    var imageUrls: [String]
}


