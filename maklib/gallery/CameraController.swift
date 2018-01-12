//
//  CameraController.swift
//  maklib
//
//  Created by Marck Regio on 11/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class CameraController: NSObject{
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var cameraPosition: CameraPosition?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var flashMode = AVCaptureDevice.FlashMode.off
    
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func switchCameras() throws {
        
        guard let currentCamera = cameraPosition, let captureSession = self.captureSession,
            captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        captureSession.beginConfiguration()
        
        func switchFront() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput],
                let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation}
        
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!){
                captureSession.addInput(self.frontCameraInput!)
                self.cameraPosition = .front
            } else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        func switchBack() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput],
                let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation}
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!){
                captureSession.addInput(self.rearCameraInput!)
                self.cameraPosition = .rear
            } else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        switch currentCamera{
        case .front:
            try switchFront()
        case .rear:
            try switchBack()
        }
        
        captureSession.commitConfiguration()
    }
}

extension CameraController{
    func prepare(completionHandler: @escaping (Error?) -> Void){
        func createCaptureSession(){
            self.captureSession = AVCaptureSession()
        }
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = session.devices.flatMap({ $0 })
            if (cameras.isEmpty){
                throw CameraControllerError.noCamerasAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
                self.cameraPosition = .rear
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.cameraPosition = .front
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        func configureOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if (captureSession.canAddOutput(self.photoOutput!)){
                captureSession.addOutput(self.photoOutput!)
            }
            captureSession.startRunning()
        }
        func displayPreview(on view: UIView) throws {
            guard let captureSession = self.captureSession, captureSession.isRunning else {
                throw CameraControllerError.captureSessionIsMissing
            }
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.previewLayer?.connection?.videoOrientation = .portrait
            view.layer.insertSublayer(self.previewLayer!, at: 0)
            self.previewLayer?.frame = view.frame
        }
        
        DispatchQueue(label: "prepare").async {
            do{
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configureOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}


extension CameraController{
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}
