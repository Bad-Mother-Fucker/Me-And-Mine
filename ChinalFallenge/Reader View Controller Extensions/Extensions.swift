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
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "exitButton"), for: .normal)
        self.cameraView.bringSubview(toFront: dismissButton)
        self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "flashOff"), for: .normal)
        self.cameraView.bringSubview(toFront: flashlightButton)
        self.frameworksCollectionView.isHidden = true
    }
    
    func setSwipeGestureFrameworks() {
        self.photoButton.isHidden = true
        self.dismissButton.isHidden = true
        self.flashlightButton.isHidden = true
        self.frameworksCollectionView.isHidden = false
        self.frameworksCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.cameraView.bringSubview(toFront: self.frameworksCollectionView)
    }
    
    func setFlashlight() {
        switch self.flashMode {
        case .off:
            self.flashMode = .auto
            self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        case .auto:
            self.flashMode = .on
            self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "flashOn"), for: .normal)
        case .on:
            self.flashMode = .off
            self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "flashOff"), for: .normal)
        }
    }
}

