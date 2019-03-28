//
//  PostcardCreationViewController.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import SpriteKit
import FSImageViewer


class PostcardCreationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var insertMessageTextField: UITextField!
    @IBOutlet weak var backgroundView: SKView!
    @IBOutlet weak var createButton: UIButton!
    
    
    var networkReqInProgress = false
    
    var arrayOfUrls: [postcardImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if !AppManager.didViewLandingPage{
            self.performSegue(withIdentifier: "welcomeLandingPage", sender: nil)
            AppManager.didViewLandingPage = true
        }
        
        // Changes the placeholder text to white
        insertMessageTextField.attributedPlaceholder = NSAttributedString(string: "Insert Message", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        insertMessageTextField.delegate = self
        
        // Rounds out the create button
        createButton.layer.cornerRadius = 15
        
        // Sets the background scene to the appropriate size and presents it
        if let scene = SKScene(fileNamed: "postcardCreatorBackground"){
            scene.scaleMode = .aspectFill
            backgroundView.presentScene(scene)
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Begins network request for the images
        getImages()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Gets the url for the images of all possible postcards
    func getImages(){
        networkReqInProgress = true
        NetworkHandler.shared.networkTask(For: .postcardUrls) { (response) in
            self.networkReqInProgress = false
            switch response{
            case .data(let data):
                let decoder = JSONDecoder()
                do{
                    let array = try decoder.decode(imageArray.self, from: data)
                    self.arrayOfUrls = (array).photos
                }catch{
                    DispatchQueue.main.async{
                        self.presentErrorModal(appError.decodingError)
                    }
                }
                
            case .error(let error):
                DispatchQueue.main.async{
                    self.presentErrorModal(error)
                }
            }
        }
    }
    
    
    // Tries to create a postcard and handles any errors
    @IBAction func createPostcard(_ sender: Any) {
        
        // If the text message field is not empty and the array of urls has been successfully filled
        // from the network request
        if arrayOfUrls.count > 0{
            
            getImage(at: arrayOfUrls[Int.random(in: 0...arrayOfUrls.count-1)].imageUrl)
            
        }else{
            self.presentAlertModal(withTitle: "Network Error", andDescription: "Trying to establish network connection"){ _ in
                if !self.networkReqInProgress{
                    self.getImages()
                }
            }
        }
    }
    
    // The keyboard will disappear when the user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Gets a given image at a url and displays errors if there is a problem
    func getImage(at url: String){
        let secureUrl = UrlCreator.convertToHttps(url)
        
        NetworkHandler.shared.networkTask(For: .postcardImage(secureUrl)) { (response) in
            switch response{
            case .data(let data):
                if let image = UIImage(data: data){
                    DispatchQueue.main.async{
                        let image = self.textToImage(drawText: self.insertMessageTextField.text ?? "" , inImage: image, atPoint: CGPoint(x: 0, y: 0))
                        let newImage = FSBasicImage(image: image)
                        let imgSource = FSBasicImageSource(images: [newImage])
                        let imgViewer = FSImageViewerViewController(imageSource: imgSource)
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.pushViewController(imgViewer, animated: true)
                    }
                }else{
                    DispatchQueue.main.async{
                        self.presentErrorModal(NetworkError.imageDataNotRecognized)
                    }
                }
                
            case .error(let error):
                DispatchQueue.main.async {
                    self.presentErrorModal(error)
                }
            }
        }
    }
    
    // Adds text to the top left corner of a given image
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        
        var textFont: UIFont!
        
        // Works because the mars small photos are very small and the large photos are quite large
        // but there isn't anything in between that we need to account for
        if image.size.width < 200{
            textFont = UIFont(name: "Helvetica Bold", size: 12)!
        }else{
            textFont = UIFont(name: "Helvetica Bold", size: 75)!
        }
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}
