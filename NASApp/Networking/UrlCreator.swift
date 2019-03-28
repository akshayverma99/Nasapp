//
//  UrlCreator.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import UIKit
import MapKit

private let apiKey = "dXPVgZdkjQWrhB5HVKUUMMw2nHQmiPN9efrDD8G2"

public class UrlCreator{
    
    static var imagesUrl: URL = {
        var url = URLComponents(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos")
        url?.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                           URLQueryItem(name: "sol", value: "1000")
        ]
        
        // Should not crash because its been checked but want to fatalError in case the Url is wrong
        return url!.url!
        
    }()
    
    static func getUrlWithCoordinates(_ coordinate: CLLocationCoordinate2D) -> URL{
        var url = URLComponents(string: "https://api.nasa.gov/planetary/earth/imagery/")
        url?.queryItems = [
                            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        // Should not crash because its been checked but want to fatalError in case the Url is wrong
        return url!.url!
    }
    
    static func getUrlWithKeyword(_ keywordForSearch: String) -> URL{
        var url = URLComponents(string: "https://images-api.nasa.gov/search")
        url?.queryItems = [URLQueryItem(name: "q", value: keywordForSearch)]
        
        // Should not crash because its been checked but want to fatalError in case the Url is wrong
        return url!.url!
        
    }
    
    // Adds an s to a string to a url string
    // use with strings that start with http to turn them into https
    static func convertToHttps(_ url: String) -> String{
        var placeHolder = url
        placeHolder.insert("s", at: placeHolder.index(placeHolder.startIndex, offsetBy: 4))
        return placeHolder
    }
    
}
