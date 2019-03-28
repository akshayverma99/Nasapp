//
//  GalleryCollectionViewController.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuse"

class GalleryCollectionViewController: UICollectionViewController, UISearchBarDelegate, UISearchControllerDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var urlsForImgs: [Item] = []
    var thumbnailImages: [UIImage] = []
    var pictureData: [imageHolder] = []
    
    var numOfImagesReturned = 0{
        willSet{
            if newValue == urlsForImgs.count-1{
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.searchController.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        for indexPath in self.collectionView.indexPathsForVisibleItems{
            getImageForCell(index: indexPath.row, cell: self.collectionView.cellForItem(at: indexPath) as! GalleryImageCollectionViewCell)
        }
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureData.count-1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryImageCollectionViewCell
        
        cell.imageView.image = nil
        getImageForCell(index: indexPath.row, cell: cell)
        // Configure the cell
        
        return cell
    }
    
    // searches and obtains all the images associates with a given phrase, also throws errors if needed
    func search(with phrase: String){
        NetworkHandler.shared.networkTask(For: .galleryUrls(phrase)) { (response) in
            switch response{
            case .error:
                DispatchQueue.main.async {
                    self.presentAlertModal(withTitle: "No Results", andDescription: "No results were found"){ _ in
                        self.collectionView.reloadData()
                    }
                }
            case .data(let data):
                let decoder = JSONDecoder()
                do{
                    self.urlsForImgs = (try decoder.decode(wrapperCollection.self, from: data)).collection.items
                    if self.urlsForImgs.count == 0{
                        throw NetworkError.nothingReturned
                    }
                    self.getImageUrls()
                }catch{
                    DispatchQueue.main.async {
                        self.presentErrorModal(error)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // gets the image urls for an image object(array of image urls depending on size)
    func getImageUrls(){
        for item in urlsForImgs{
            guard let url = item.href else {
                self.numOfImagesReturned += 1
                return
            }
            NetworkHandler.shared.networkTask(For: .galleryImage(url)) { (response) in
                switch response{
                case .error:
                    // Silently fails and is not added to the list of usable urls
                    break
                case .data(let data):
                    let decoder = JSONDecoder()
                    do{
                        let arrayOfItemUrls = try decoder.decode([String].self, from: data)
                        
                        for url in arrayOfItemUrls{
                            if url.contains("thumb") && url.contains("image"){
                                self.pictureData.append(imageHolder(imageUrls: arrayOfItemUrls))
                                break
                            }
                        }
                        self.numOfImagesReturned += 1
                    }catch{
                        self.numOfImagesReturned += 1
                    }
                }
            }
        }
    }
    
    func getImageForCell(index: Int, cell: GalleryImageCollectionViewCell){
        if index>pictureData.count-1{return}
        
        let placeholder = self.pictureData[index]
        for url in placeholder.imageUrls{
            if url.contains("thumb"){
                let secureUrl = UrlCreator.convertToHttps(url)
                guard let newUrl = URL(string: secureUrl) else {return}
                cell.imageView.kf.setImage(with: newUrl)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(with: searchBar.text ?? "")
        
        self.pictureData = []
        self.numOfImagesReturned = 0
        self.thumbnailImages = []
        self.urlsForImgs = []
        self.searchController.isActive = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.searchController.isActive = true
    }

    
}
