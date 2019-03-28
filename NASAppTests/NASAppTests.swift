//
//  NASAppTests.swift
//  NASAppTests
//
//  Created by Akshay Verma on 2019-03-21.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import XCTest
import MapKit
@testable import NASApp

class NASAppTests: XCTestCase {

    class testNetworkHandler: NetworkHandler{}
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    

    // Couldnt test more because even with stubbed data calls, there isn't a way to run XCTAssert and all errors are
    // handled on the spot
    
    
    
    func testGetMarsImageUrl() {
        let expectedUrl = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=dXPVgZdkjQWrhB5HVKUUMMw2nHQmiPN9efrDD8G2&sol=1000"
        let urlToTest = UrlCreator.imagesUrl.absoluteString
        
        XCTAssertTrue(urlToTest == expectedUrl, "URLS Dont match")
    }
    
    func testCoordinateUrl(){
        let expectedUrl = "https://api.nasa.gov/planetary/earth/imagery/?lon=50.75&lat=50.75&api_key=dXPVgZdkjQWrhB5HVKUUMMw2nHQmiPN9efrDD8G2"
        let urlToTest = UrlCreator.getUrlWithCoordinates(CLLocationCoordinate2D(latitude: 50.75, longitude: 50.75)).absoluteString
        
        XCTAssertTrue(urlToTest == expectedUrl, "URLS Dont match")
    }
    
    
    
    
    
    // realized network requests in unit tests dont work :( cant think of anything else that I can test
    
//    func testGetUrls(){
//        testNetworkHandler.shared.networkTask(For: .postcardUrls) { (response) in
//            switch response{
//            case .data: XCTAssertTrue(true)
//            case .error(let error): XCTAssertTrue(false, error.localizedDescription)
//            }
//        }
//    }
//
//    func testUrlData(){
//        testNetworkHandler.shared.networkTask(For: .postcardUrls) { (response) in
//            switch response{
//            case .data(let data):
//                let decoder = JSONDecoder()
//                do{
//                    let results = try decoder.decode(itemsArray.self, from: data)
//                    XCTAssertTrue(results.items.count > 0, "No data")
//                }catch{
//                     XCTAssertTrue(false, "Data is wrong")
//                }
//            case .error(let error): XCTAssertTrue(false, error.localizedDescription)
//            }
//        }
//
//    }
//
//    func testGetSpecificImage(){
//        let imageUrl = "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG"
//        let nonImageUrl = "https://swapi.co/api/people/"
//
//        testNetworkHandler.shared.networkTask(For: .postcardImage(nonImageUrl)){ response in
//            switch response{
//            case .data(let data):
//                let image = UIImage(data: data)
//                XCTAssertTrue(image != nil, "Data is not an image")
//            case .error(let error): XCTAssertTrue(false, error.localizedDescription)
//            }
//        }
//    }
//
//    func testNotImageData(){
//        let nonImageUrl = "https://swapi.co/api/people/"
//        testNetworkHandler.shared.networkTask(For: .postcardImage(nonImageUrl)){ response in
//            switch response{
//            case .data(let data):
//                let image = UIImage(data: data)
//                XCTAssert(image == nil)
//            case .error(let error): XCTAssertTrue(false, error.localizedDescription)
//            }
//        }
//    }

}
