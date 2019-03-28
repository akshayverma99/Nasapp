//
//  NetworkHandler.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import MapKit

enum NetworkResponse{
    case error(Error)
    case data(Data)
}

enum NetworkTask{
    case postcardUrls
    case galleryUrls(String)
    case galleryImage(String)
    case postcardImage(String)
    case satImage(CLLocationCoordinate2D)
}

public class NetworkHandler{
    
    static var shared = NetworkHandler()
    
    let timeoutInterval: Double = 10
    
    func networkTask(For task: NetworkTask, CompletionHandler: @escaping (NetworkResponse)->Void){
        
        switch task{
            
        // Gets the postcard image urls
        case .postcardUrls:
            let networkReq = URLRequest(url: UrlCreator.imagesUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            
            
            URLSession.shared.dataTask(with: networkReq){ data,response,error in
                if let error = error{
                    CompletionHandler(.error(error))
                    return
                }
                
                if let data = data{
                    CompletionHandler(.data(data))
                    return
                }
                
                }.resume()
            
        // Gets the url for a coordinate at a given point
        case .satImage(let coordinate):
            let networkReq = URLRequest(url: UrlCreator.getUrlWithCoordinates(coordinate), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            
            URLSession.shared.dataTask(with: networkReq) { (data, response, error) in
                
                if let error = error{
                    CompletionHandler(.error(error))
                    return
                }
                
                if let data = data{
                    CompletionHandler(.data(data))
                    return
                }
                
                }.resume()
            
            
        // Gets an image at a given url, noncached
        case .postcardImage(let url):
            
            if let url = URL(string: url){
                let networkReq = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
                
                URLSession.shared.dataTask(with: networkReq){ data,response,error in
                    if let error = error{
                        CompletionHandler(.error(error))
                        return
                    }
                    
                    if let data = data{
                        CompletionHandler(.data(data))
                        return
                    }
                    }.resume()
            }else{
                CompletionHandler(.error(NetworkError.invalidUrl))
            }
            
        // same as above but w/ a different cache policy because image downloading is network heavy
        case .galleryImage(let url):
            let urlWithNoSpaces = url.replacingOccurrences(of: " ", with: "")
            if let url = URL(string: urlWithNoSpaces){
                
                let networkReq = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeoutInterval)
                
                URLSession.shared.dataTask(with: networkReq){ data,response,error in
                    if let error = error{
                        CompletionHandler(.error(error))
                        return
                    }
                    
                    if let data = data{
                        CompletionHandler(.data(data))
                        return
                    }
                    }.resume()
            }else{
                print(url)
                CompletionHandler(.error(NetworkError.invalidUrl))
            }
            
        case .galleryUrls(let phrase):
            let networkReq = URLRequest(url: UrlCreator.getUrlWithKeyword(phrase), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            
            URLSession.shared.dataTask(with: networkReq){ data,response,error in
                if let error = error{
                    CompletionHandler(.error(error))
                    return
                }
                
                if let data = data{
                    CompletionHandler(.data(data))
                    return
                }
                }.resume()
        }
        
        
    }
}


