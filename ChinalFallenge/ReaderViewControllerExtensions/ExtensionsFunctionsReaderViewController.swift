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
        self.SpeechText.text = ""
        self.SpeechText.isHidden = true
        self.SpeechText.isSelectable = false
    }
    
    func centerButtonSwitch(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            onTapTakePhoto()
            setButtonsAfterPhoto()
            sender.tag = 1
        case 1:
            sender.tag = 2
            print("case1")
        default:
            //colore bottone black/gray
            break
        }
    }
    
    @objc func touchDown() {
        if self.centerButton.tag == 1 {
            centerButton.isSelected = true
            speechQueue.async {
                self.speechRec.startRecordingSpeech(speechTextView: self.SpeechText)
            }
        }
       
    }
    
    @objc func touchUp() {
        if self.centerButton.tag == 2 {
            self.centerButton.isSelected = false
            self.speechRec.stopRecordingSpeech()
            self.centerButton.setBackgroundImage(#imageLiteral(resourceName: "dictation inactive"), for: .normal)
        }
    }
    
    func setButtonOnCameraView() {
        setButtonsTag(to: 0)
        self.centerButton.setBackgroundImage(#imageLiteral(resourceName: "buttonCamera"), for: .normal)
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "arrowRight"), for: .normal)
        self.dismissButton.isHidden = false
        self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        self.attributesCollectionView.isHidden = true
        //TODO: set assets for this
        //self.cornerLeftButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal) (settings)
        //self.rightButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal) (imagePickerIcon)
    }
    
    
    func setButtonsAfterPhoto() {
        dismissButton.isHidden = true
        attributesCollectionView.backgroundColor = .clear
        attributesCollectionView.isHidden = false
        conrnerLeftButton.setBackgroundImage(#imageLiteral(resourceName: "trashButton"), for: .normal)
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "dictation inactive"), for: .normal)
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "dictation active"), for: .selected)
        rightButton.setBackgroundImage(#imageLiteral(resourceName: "OCR"), for: .normal)
        leftButton.setBackgroundImage(#imageLiteral(resourceName: "MLButton"), for: .normal)
        setButtonsTag(to: 1)
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
    
    func setButtonsTag(to tag: Int) {
        centerButton.tag = tag
        leftButton.tag = tag
        conrnerLeftButton.tag = tag
        rightButton.tag = tag
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
    
    func setImagePreviewView() {
        //Set a view on which the preview of the photo will be shown
        self.imageView = UIImageView(frame: self.cameraView.frame)
        
        //Set constraints to keep it locked to the view when it is going to resize
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: cameraView, attribute: .height, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: cameraView, attribute: .width, multiplier: 1, constant: 0)
        let xAlignmentConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: cameraView, attribute: .centerX, multiplier: 1, constant: 0)
        let yAlignmentConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: cameraView, attribute: .centerY, multiplier: 1, constant: 0)
        let constraints = [heightConstraint,widthConstraint,xAlignmentConstraint,yAlignmentConstraint]
        
        cameraView.addSubview(imageView)
        cameraView.addConstraints(constraints)
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




