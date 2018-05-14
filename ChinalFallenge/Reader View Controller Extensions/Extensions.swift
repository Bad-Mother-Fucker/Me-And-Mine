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
    
    //HIDE KEYBOARD TAPPING EVERYWHERE
    func gestureDismissKeyboard() {
        let tapGestureDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.cameraView.addGestureRecognizer(tapGestureDismissKeyboard)
    }
    
    //HIDE AND IS NOT EDITABLE TEXT VIEW.
    func settingTextView() {
        self.SpeechText.isHidden = true
        self.SpeechText.isSelectable = false
    }
    
    func setButtonOnCameraView() {
        self.photoButton.setBackgroundImage(#imageLiteral(resourceName: "buttonCamera"), for: .normal)
        self.cameraView.bringSubview(toFront: photoButton)
    }
    
    func setSwipeGestureFrameworks() {
        self.photoButton.isHidden = true
    }
    
    //FUNCTIONS FOR CHECK ON CAPTURE SESSION
    func checkCaptureSession() {
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        } else {
            captureSession?.stopRunning()
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

