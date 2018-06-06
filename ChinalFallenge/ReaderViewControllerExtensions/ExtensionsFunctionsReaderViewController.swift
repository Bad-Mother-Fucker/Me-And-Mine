//
//  Extensions Functions Reader View Controller
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

// ############### READER VIEW CONTROLLER EXTENSION ###############

import UIKit
import AVFoundation

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
    
    @objc func reloadCVData(){
        currentItem.identifier = detectionEngine.classificationResult.0
        attributesCollectionView.reloadData()
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
            self.speechRec.startRecordingSpeech(speechTextView: self.SpeechText)
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
         leftButton.frame.size = CGSize(width: 30, height: 40)
        SpeechText.text = ""
        SpeechText.isHidden = true
        SpeechText.isEditable = false
        self.centerButton.setBackgroundImage(#imageLiteral(resourceName: "buttonCamera"), for: .normal)
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "arrow"), for: .normal)
        self.dismissButton.isHidden = false
        self.flashMode = .auto
        self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flash auto"), for: .normal)
        self.attributesCollectionView.isHidden = true
        self.conrnerLeftButton.setBackgroundImage(#imageLiteral(resourceName: "settings"), for: .normal)
        self.rightButton.setBackgroundImage(#imageLiteral(resourceName: "picker"), for: .normal)
    }
    
    
    func setButtonsAfterPhoto() {
        dismissButton.isHidden = true
        attributesCollectionView.isHidden = false
        attributesCollectionView.backgroundColor = .clear
        attributesCollectionView.isHidden = false
        leftButton.frame.size = CGSize(width: 40, height: 40)
        conrnerLeftButton.setBackgroundImage(#imageLiteral(resourceName: "trashButton"), for: .normal)
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "dictation inactive"), for: .normal)
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "dictation active"), for: .selected)
        rightButton.setBackgroundImage(#imageLiteral(resourceName: "OCR"), for: .normal)
        leftButton.setBackgroundImage(#imageLiteral(resourceName: "ML"), for: .normal)
        setButtonsTag(to: 1)
    }
    
    func setFlashlight() {
        switch self.flashMode {
        case .off:
            self.flashMode = .auto
            self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flash auto"), for: .normal)
        case .auto:
            self.flashMode = .on
            self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flash"), for: .normal)
        case .on:
            self.flashMode = .off
            self.leftButton.setBackgroundImage(#imageLiteral(resourceName: "flash off"), for: .normal)
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




