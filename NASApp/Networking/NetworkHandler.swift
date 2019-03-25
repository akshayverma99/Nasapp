//
//  NetworkHandler.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

enum NetworkResponse{
    case error(Error)
    case data(Data)
}

enum NetworkTask{
    case postcardUrls
    case postcardImage(String)
    case satImage((Double,Double))
}

enum NetworkError: Error{
    case invalidUrl
}

class NetworkHandler{
    
    static var shared = NetworkHandler()
    
    func networkTask(For task: NetworkTask, CompletionHandler: @escaping (NetworkResponse)->Void){
        
        // TODO: Make this work
        
        switch task{
        case .postcardUrls:
            
            // Get image from Url then return either the data or error
            
            URLSession.shared.dataTask(with: UrlCreator.imagesUrl){ data,response,error in
                if let error = error{
                    CompletionHandler(.error(error))
                }
                
                if let data = data{
                    CompletionHandler(.data(data))
                }
                
            }.resume()
            
            
        case .satImage(let coordinate): break
        case .postcardImage(let url):
            if let url = URL(string: url){
                URLSession.shared.dataTask(with: url){ data,response,error in
                    if let error = error{
                        CompletionHandler(.error(error))
                    }
                    
                    if let data = data{
                        CompletionHandler(.data(data))
                    }
                }.resume()
            }else{
                CompletionHandler(.error(NetworkError.invalidUrl))
            }
        }
        
    }
    
}
