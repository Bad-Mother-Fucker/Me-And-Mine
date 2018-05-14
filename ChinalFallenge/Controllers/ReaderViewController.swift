//
//  ReaderViewController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 18/04/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Speech

class ReaderViewController: UIViewController {
    
    //ATTRIBUTES FOR CAMERA
    var captureSession: AVCaptureSession?
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var imageView: UIImageView!
    let photoSettings = AVCapturePhotoSettings()
    var flashMode = AVCaptureDevice.FlashMode.off
    
    //ATTRIBUTES FOR SPEECH RECOGNITION
    let speechRecognizer = SFSpeechRecognizer.init(locale: Locale.current)
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var flagOnSpeech = false
    
    //VIEW
    @IBOutlet weak var cameraView: UIView!
    
    //TEXT VIEW
    @IBOutlet weak var SpeechText: UITextView!

    //OTHER ATTRIBUTES
    var speech: [String]?
    
    //BUTTONS
    @IBOutlet weak var photoButton: UIButton!
    
    //TYPE QR/BAR CODE SCANNING
    struct codeType {
        static let supportedTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.qr]
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setCameraSession()
        requestCameraAuthorization()
        gestureDismissKeyboard()
    }
    
    //VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationAndTabBarController()
        checkCaptureSession()
        settingTextView()
        setButtonOnCameraView()
        self.imageView = UIImageView(frame: self.cameraView.frame)
    }
    
    //FUNCTION TO HIDE KEYBOARD
    @objc func dismissKeyboard() {
        self.cameraView.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        captureSession?.stopRunning()
        onTapTakePhoto()
        setSwipeGestureFrameworks()
    }
    
}

// ############### HANDLE TEXT VIEW ###############

extension ReaderViewController: UITextViewDelegate {
    func moveTextView(textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animatedTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView: textView, moveDistance: -250, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView: textView, moveDistance: -250, up: false)
    }
}







