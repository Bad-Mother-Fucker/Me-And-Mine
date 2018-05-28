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
        self.centerButton.setBackgroundImage(#imageLiteral(resourceName: "buttonCamera"), for: .normal)
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "arrowRight"), for: .normal)
        self.dismissButton.isHidden = false
        self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        self.attributesCollectionView.isHidden = true
        self.trashButton.isHidden = true
        self.settingsButton.isHidden = false
        
        //TODO: set assets for this
//        self.settingsButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
//        self.rightButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal) (imagePickerIcon)

        
    }
    
    func setButtonsAfterPhoto() {
        dismissButton.isHidden = true
        settingsButton.isHidden = true
        attributesCollectionView.backgroundColor = .clear
        attributesCollectionView.isHidden = false
        trashButton.setBackgroundImage(#imageLiteral(resourceName: "trashButton"), for: .normal)
        trashButton.isHidden = false
        centerButton.setImage(#imageLiteral(resourceName: "cameraWithMicrophoneButton"), for: .selected)
        
//        TODO: Set Assets for these
        
//        leftButton.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal) (OCR icon)
//        rightButton.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal) (ML icon)
//        centerButton.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal) (dictation inactive icon)
    }
    
    func setFlashlight() {
        switch self.flashMode {
        case .off:
            self.flashMode = .auto
            self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        case .auto:
            self.flashMode = .on
            self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "FlashOn"), for: .normal)
        case .on:
            self.flashMode = .off
            self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "FlashOff"), for: .normal)
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

//    func setScrollView(){
//         scrollView.frame.size.width = cameraView.frame.width * CGFloat(itemPhotos.count)
//        for imageView in itemPhotos{
//            scrollView.addSubview(imageView)
//            imageView.frame.origin.x = CGFloat(itemPhotos.count - 1) * scrollView.frame.width
//        }
//
//    }
}




