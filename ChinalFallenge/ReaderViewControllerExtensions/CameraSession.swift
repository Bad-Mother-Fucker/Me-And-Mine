//
//  Camera Session.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

// ############### CAMERA SESSION ###############

import AVFoundation
import UIKit

extension ReaderViewController: AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    //CHECK FOR AUTHORIZATION CAMERA SESSION (called in viewDidLoad)
    func cameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
        sessionQueue.async {
            self.configureSession()
        }
    }
    
    func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let devices = self.discoverySession.devices
        guard !devices.isEmpty else {fatalError("Missing capture devices.")}
        return devices.first(where: {device in device.position == position })!
    }
    
    func configureSession() {
        if setupResult != .success {
            return
        }
        captureSession = AVCaptureSession()
        guard let session = self.captureSession else {return}
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: bestDevice(in: .back))
            
            if (session.canAddInput(videoDeviceInput)) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                self.cameraView.session = session
                self.cameraView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                DispatchQueue.main.async {
                    let statusBarOrientation = UIApplication.shared.statusBarOrientation
                    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                    if statusBarOrientation != .unknown {
                        if let videoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue) {
                            initialVideoOrientation = videoOrientation
                        }
                    }
                    self.cameraView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
                }
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        // Add photo output.
        if (session.canAddOutput(photoOutput)) {
            session.addOutput(photoOutput)
            self.photoOutput.isHighResolutionCaptureEnabled = true
        } else {
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        session.commitConfiguration()
    }
    
    func session() {
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                //ONLY SETUP START THE SESSION RUNNING IF SETUP SUCCEDED.
                self.captureSession?.startRunning()
                self.isSessionRunning = (self.captureSession?.isRunning)!
            case .notAuthorized:
                DispatchQueue.main.async {
                    let changePrivacySetting = "Me & Mine doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "Me & Mine", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                        self.tabBarController?.selectedIndex = 1
                    }))
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { _ in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            case .configurationFailed:
                DispatchQueue.main.async {
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "Me & Mine", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //CALLED WHEN THE USER TAP THE BUTTON "TAKE A PHOTO"
    func onTapTakePhoto() {
        let videoPreviewLayerOrientation = self.cameraView.videoPreviewLayer.connection?.videoOrientation
        sessionQueue.async {
            // Update the photo output's connection to match the video orientation of the video preview layer.
            if let photoOutputConnection = self.photoOutput.connection(with: .video) {
                photoOutputConnection.videoOrientation = videoPreviewLayerOrientation!
            }
            // Set photo settings for our need
            let photoSettings = AVCapturePhotoSettings()
            if (self.videoDeviceInput?.device.isFlashAvailable)! {
                photoSettings.flashMode = self.flashMode
            }
            photoSettings.isHighResolutionPhotoEnabled = true
            if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
            }
            photoSettings.isAutoStillImageStabilizationEnabled = true
            // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    //PHOTO OUTPUT FUNCTION
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {return}
        // Initialise a UIImage with our image data
        //let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = UIImage.init(data: imageData , scale: 1.0) {
//            detectionEngine.updateClassifications(for: image)
//            print (detectionEngine.result?.0)
            self.presentedImage = image
            self.captureSession?.stopRunning()
        }
    }
    
    //SET QR CODE METADATA OBJECT FUNCTION
    func setMetadataObject() {
        //GET METADATA OBJECT
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession?.canAddOutput(metadataOutput))! {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = codeType.supportedTypes
        } else {return}
    }
    
    //METADATA OUTPUT FUNCTION
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        // Get the metadata object.
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            print(stringValue)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        dismiss(animated: true)
    }
}

