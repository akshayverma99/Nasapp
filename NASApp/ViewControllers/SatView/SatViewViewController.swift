//
//  SatViewViewController.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import MapKit
import FSImageViewer
import NVActivityIndicatorView

class SatViewViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var viewSatImageButton: UIButton!
    
    let searchResultsVC = SearchResultsTableViewController()
    lazy var searchController = UISearchController(searchResultsController: searchResultsVC)
    
    // Whenever this is set, it adds a marker to the map
    // at the given location and centres the map on that location
    var location: MKMapItem?{
        didSet{
            map.removeAnnotations(map.annotations)
            if let location = location{
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.placemark.coordinate
                if let location = location as? AVMapItem{
                    annotation.title = location.title
                }else{
                    annotation.title = location.placemark.title
                }
                map.addAnnotation(annotation)
                self.centerMapOnLocation(location.placemark.coordinate, mapView: self.map)
                UIView.animate(withDuration: 1) {
                    self.viewSatImageButton.transform = CGAffineTransform.identity
                }
            }else{
                UIView.animate(withDuration: 1) {
                    self.viewSatImageButton.transform = CGAffineTransform(translationX: 0, y: 600)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        map.delegate = self
        searchResultsVC.previousVC = self
        
        UIView.animate(withDuration: 1) {
            self.viewSatImageButton.transform = CGAffineTransform(translationX: 0, y: 600)
        }
        
        searchController.searchResultsUpdater = searchResultsVC
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Changes the chosen location to wherever the user tapped
    @IBAction func userTapped(_ sender: UITapGestureRecognizer) {
        let touchCoordinate = map.convert(sender.location(in: self.map), toCoordinateFrom: map)
        let mapItem = AVMapItem(placemark: MKPlacemark(coordinate: touchCoordinate), title: "\(touchCoordinate.latitude.rounded(toPlaces: 4)), \(touchCoordinate.longitude.rounded(toPlaces: 4))")
        self.location = mapItem
    }
    
    // gets the satallite image for the chosen point and presents it
    @IBAction func viewSatImagePressed(_ sender: Any) {
        NetworkHandler.shared.networkTask(For: .satImage(location!.placemark.coordinate)) { (response) in
            switch response{
            case .data(let data):
                let decoder = JSONDecoder()
                do{
                    let imageUrl = (try decoder.decode(satImage.self, from: data)).imageUrl
                    if let url = URL(string: imageUrl){
                        DispatchQueue.main.async {
                            let image = FSBasicImage(imageURL: url)
                            let imgSource = FSBasicImageSource(images: [image])
                            let imgViewer = FSImageViewerViewController(imageSource: imgSource)
                            self.navigationController?.pushViewController(imgViewer, animated: true)
                        }
                    }else{
                        DispatchQueue.main.async {
                         self.presentAlertModal(withTitle: "Url Error", andDescription: "Please select another location")
                        }
                    }
                   
                    
                }catch let error{
                    DispatchQueue.main.async {
                        self.presentErrorModal(error)
                    }
                }
                
            case .error(let error):
                DispatchQueue.main.async {
                    self.presentErrorModal(error)
                }
            }
        }
        
    }

}

// A way of adding custom titles to MKMapitems
class AVMapItem: MKMapItem{
    var title: String
    
    init(placemark: MKPlacemark, title: String) {
        self.title = title

        super.init(placemark: placemark)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
