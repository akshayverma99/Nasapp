//
//  Errors.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

enum NetworkError: Error{
    case invalidUrl
    case imageDataNotRecognized
    case nothingReturned
}

extension NetworkError: LocalizedError{
    public var errorDescription: String?{
        switch self{
        case .invalidUrl: return NSLocalizedString("Url is invalid, try again", comment: "")
        case .nothingReturned: return NSLocalizedString("Nothing matches the search description", comment: "")
        case .imageDataNotRecognized: return NSLocalizedString("data not recognized", comment: "")
        }
    }
}

enum appError: Error{
    case decodingError
}
