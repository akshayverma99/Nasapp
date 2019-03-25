//
//  PostcardCreationViewController.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-25.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import SpriteKit

// APIKey: dXPVgZdkjQWrhB5HVKUUMMw2nHQmiPN9efrDD8G2

class PostcardCreationViewController: UIViewController {
    @IBOutlet weak var insertMessageTextField: UITextField!
    @IBOutlet weak var backgroundView: SKView!
    @IBOutlet weak var createButton: UIButton!
    
    var arrayOfUrls: [postcardImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Changes the placeholder text to white
        insertMessageTextField.attributedPlaceholder = NSAttributedString(string: "Insert Message", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
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
    
    func getImages(){
        NetworkHandler.shared.networkTask(For: .postcardUrls) { (response) in
            switch response{
            case .data(let data):
                let decoder = JSONDecoder()
                do{
                    self.arrayOfUrls = (try decoder.decode(imageArray.self, from: data)).photos
                }catch{
                    // Throw a decoding error modal
                    print("Decoding Error")
                }
                
            case .error(let error): print(error)
            }
        }
    }
    
    func getImage(at url: String){
        NetworkHandler.shared.networkTask(For: .postcardImage(url)) { (response) in
            switch response{
            case .data(let data):
                guard let image = UIImage(data: data) else {return}
                
            case .error(let error): break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func createPostcard(_ sender: Any) {
        
    }
    
}
