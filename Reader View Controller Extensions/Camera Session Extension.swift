//
//  Camera Session Extension.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import AVFoundation
import UIKit

// ############### CAMERA SESSION ###############

extension ReaderViewController: AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    //SET CAMERA ON THE VIEW.
    func setCameraSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {return}
        if (captureSession?.canAddInput(videoInput))! {
            captureSession?.addInput(videoInput)
        } else {return}
        //HANDLE SECOND THREAD
        DispatchQueue.main.async {
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
            self.videoPreviewLayer?.frame = self.view.layer.bounds
            self.videoPreviewLayer?.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.videoPreviewLayer!)
            self.setFlashDismissTakePhotoButtons()
            self.captureSession?.startRunning()
        }
    }
    
    func instantiatePhotoOutput() {
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        // Set the output on the capture session
        if (captureSession?.canAddOutput(capturePhotoOutput!))! {
            captureSession?.addOutput(capturePhotoOutput!)
        } else {return}
    }
    
    //CALLED WHEN THE USER TAP THE BUTTON "TAKE A PHOTO"
    func onTapTakePhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else {return} // Make sure capturePhotoOutput is valid
        // Set photo settings for our need
        photoSettings.flashMode = self.flashMode
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        let settings = AVCapturePhotoSettings.init(from: self.photoSettings)
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: settings, delegate: self)
        
        debugPrint("[DEBUG] okay flashmode: \(photoSettings.flashMode)")
    }
    
    //PHOTO OUTPUT FUNCTION
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error:Error?) {
        // get captured image - Make sure we get some photo sample buffer
        guard error == nil else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album -- CHANGE HERE TO SAVE ONLY IN OUR APP USING CORE DATA.
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.imageView.image = image
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
        alert()
    }
}
