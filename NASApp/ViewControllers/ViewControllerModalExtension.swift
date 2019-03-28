//
//  ViewControllerModalExtension.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import UIKit


// Every variation of a modal controller I would like to use
extension UIViewController{
    
    func presentErrorModal(withTitle title: String, andError error: Error){
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentErrorModal(withTitle title: String, andError error: Error, handler: @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentErrorModal(_ error: Error){
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentErrorModal(_ error: Error, handler: @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertModal(withTitle title: String, andDescription description: String){
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertModal(withTitle title: String, andDescription description: String, handler: @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
