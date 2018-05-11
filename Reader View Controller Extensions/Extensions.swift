//
//  Extensions.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit
import AVFoundation

// ############### READER VIEW CONTROLLER EXTENSION ###############

extension ReaderViewController {
    
    func setNavigationAndTabBarController() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    //FUNCTIONS FOR CHECK ON CAPTURE SESSION
    func checkCaptureSession() {
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        } else {
            captureSession?.stopRunning()
        }
    }
    
    func setFlashDismissTakePhotoButtons() {
        self.dismissButton.setBackgroundImage(UIImage(named: "dismiss.png"), for: .normal)
        self.torchOnOff.setImage(UIImage(named: "FlashOff.png"), for: .normal)
        self.photoButton.setBackgroundImage(UIImage(named: "photoButton.png"), for: .normal)
        self.view.addSubview(dismissAndTorchStackView)
        self.view.bringSubview(toFront: self.photoButton)   //TAKE PHOTO BUTTON
    }
    
    func setFrameworksButton() {
        self.coreMLButton.setBackgroundImage(UIImage(named: "coreml.png"), for: .normal)
        self.OCRButton.setBackgroundImage(UIImage(named: "ocr.png"), for: .normal)
        self.speechRecognitionButton.setBackgroundImage(UIImage(named: "microphone.png"), for: .normal)
        self.removeBackgroundButton.setBackgroundImage(UIImage(named: "forbici.png"), for: .normal)
        self.view.addSubview(imageView)
        self.view.addSubview(buttonsStackView)
    }
    
    //FOCUS FUNCTION
    func autoFocusMode() {
        guard let cameraFocus = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        if cameraFocus.isFocusModeSupported(.continuousAutoFocus) {
            try! cameraFocus.lockForConfiguration()
            cameraFocus.focusMode = .continuousAutoFocus
            cameraFocus.unlockForConfiguration()
        }
    }
    
    //ALERT FUNCTION
    func alert() {
        let alert = UIAlertController(title: "QR/Bar Code caught", message: "Step1: add info - Step2: capture new QR/Bar Code", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Step1", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "addDetailsItems", sender: self)
            self.captureSession?.stopRunning()
        }))
        
        alert.addAction(UIAlertAction(title: "Step2", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.captureSession?.startRunning()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

