//
//  Camera.swift
//  maklib
//
//  Created by Marck Regio on 11/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import UIKit
import AVFoundation


class Camera: UIViewController {
    
    let cameraController = CameraController()
    
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet var flash: UIButton!
    
    @IBOutlet var cameraPosition: UIButton!
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureCamera()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCamera(){
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.cameraView)
            
        }
    }
    
    @IBAction func flashMode(_ sender: UIButton) {
        if cameraController.flashMode == .on{
            cameraController.flashMode = .off
            flash.setImage(#imageLiteral(resourceName: "ic_flash_off"), for: .normal)
        } else {
            cameraController.flashMode = .on
            flash.setImage(#imageLiteral(resourceName: "ic_flash_on"), for: .normal)
        }
    }
    
    @IBAction func cameraMode(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        } catch {
            print (error)
        }
    
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
