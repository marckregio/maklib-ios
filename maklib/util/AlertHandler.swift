//
//  AlertHandler.swift
//  maklib
//
//  Created by Marck Regio on 19/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation
import UIKit

class AlertHandler{
    
    func showAlert(title: String, message: String, completion: @escaping (_ result: Bool) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            completion(false)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            completion(true)
        }))
        
        return alert
    }
    
    func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
}
