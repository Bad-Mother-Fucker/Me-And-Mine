//
//  Extensions Functions Reader View Controller
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit
import AVFoundation

// ############### READER VIEW CONTROLLER EXTENSION ###############

extension ReaderViewController {
    
    //HIDE KEYBOARD TAPPING EVERYWHERE
    func gesturesReaderView() {
        let tapGestureDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.cameraView.addGestureRecognizer(tapGestureDismissKeyboard)
    }
    
    //FUNCTION TO HIDE KEYBOARD
    @objc func dismissKeyboard() {
        self.cameraView.endEditing(true)
    }
    
    //HIDE AND IS NOT EDITABLE TEXT VIEW.
    func settingTextView() {
        self.SpeechText.isHidden = true
        self.SpeechText.isSelectable = false
    }
    
    func setButtonOnCameraView() {
        self.photoButton.setBackgroundImage(#imageLiteral(resourceName: "buttonCamera"), for: .normal)
        self.photoButton.isHidden = false
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "arrowRight"), for: .normal)
        self.dismissButton.isHidden = false
        self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        self.flashlightButton.isHidden = false
        self.attributesCollectionView.isHidden = true
        self.trashButton.isHidden = true
        self.settingsButton.isHidden = false
        self.cameraRollPicker.isHidden = false
        self.mlButton.isHidden = false
        self.ocrButton.isHidden = false
        self.frameworks.isHidden = false
        self.dictation.isHidden = true
        self.dictation.setBackgroundImage(#imageLiteral(resourceName: "cameraWithMicrophoneButton"), for: .normal)

        //TODO: set assets for this
//        self.settingsButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
//        self.cameraRollPicker.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
//        self.ocrButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
//        self.mlButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
        
    }
    
    func setButtonsAfterPhoto() {
        self.photoButton.isHidden = true
        self.dismissButton.isHidden = true
        self.flashlightButton.isHidden = true
        self.settingsButton.isHidden = true
        self.frameworks.isHidden = true
        self.cameraRollPicker.isHidden = true
        self.attributesCollectionView.backgroundColor = .clear
        self.attributesCollectionView.isHidden = false
        self.trashButton.setBackgroundImage(#imageLiteral(resourceName: "trashButton"), for: .normal)
        self.trashButton.isHidden = false
        self.dictation.isHidden = false

    }
    
    func setFlashlight() {
        switch self.flashMode {
        case .off:
            self.flashMode = .auto
            self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        case .auto:
            self.flashMode = .on
            self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "FlashOn"), for: .normal)
        case .on:
            self.flashMode = .off
            self.flashlightButton.setBackgroundImage(#imageLiteral(resourceName: "FlashOff"), for: .normal)
        }
    }
    
    func focus(with focusMode: AVCaptureDevice.FocusMode, exposureMode: AVCaptureDevice.ExposureMode, at devicePoint: CGPoint, monitorSubjectAreaChange: Bool) {
        sessionQueue.async {
            let device = self.videoDeviceInput?.device
            do {
                try device?.lockForConfiguration()
                if (device?.isFocusPointOfInterestSupported)! && (device?.isFocusModeSupported(focusMode))! {
                    device?.focusPointOfInterest = devicePoint
                    device?.focusMode = focusMode
                }
                if (device?.isExposurePointOfInterestSupported)! && (device?.isExposureModeSupported(exposureMode))! {
                    device?.exposurePointOfInterest = devicePoint
                    device?.exposureMode = exposureMode
                }
                device?.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                device?.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
            }
        }
    }
    
    func displayVideoPreviewLayer() {
        if let videoPreviewLayerConnection = self.cameraView.videoPreviewLayer.connection {
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation),
                deviceOrientation.isPortrait || deviceOrientation.isLandscape else {
                    return
            }
            videoPreviewLayerConnection.videoOrientation = newVideoOrientation
        }
    }
    
    func setScrollView(){
         scrollView.frame.size.width = cameraView.frame.width * CGFloat(itemPhotos.count)
        for imageView in itemPhotos{
            scrollView.addSubview(imageView)
            imageView.frame.origin.x = CGFloat(itemPhotos.count - 1) * scrollView.frame.width
        }
        
    }
}




