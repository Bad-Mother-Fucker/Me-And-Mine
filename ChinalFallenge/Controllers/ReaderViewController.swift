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
    var videoDeviceInput: AVCaptureDeviceInput?
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
    var isCaptureSessionConfigured = false // Instance proprerty on this view controller class
    var photoOutput: AVCapturePhotoOutput?
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
    @IBOutlet weak var cameraView: VideoPreviewView!
    
    //TEXT VIEW
    @IBOutlet weak var SpeechText: UITextView!
    
    //COLLECTION VIEW
    @IBOutlet weak var frameworksCollectionView: UICollectionView!
    
    //OTHER ATTRIBUTES
    var speech: [String]?
    let sessionQueue = DispatchQueue(label: "session queue") //Communicate with the session and other session objects on this queue.
    var setupResult: SessionSetupResult = .success
    var isSessionRunning = false
    
    //ENUM
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    //BUTTONS
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var flashlightButton: UIButton!
    
    //TYPE QR/BAR CODE SCANNING
    struct codeType {
        static let supportedTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.qr]
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraAuthorization()
        
    }
    
    //VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationAndTabBarController()
        session()
        settingTextView()
        gestureDismissKeyboard()
        setButtonOnCameraView()
        self.imageView = UIImageView(frame: self.cameraView.frame)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.setupResult == .success {
            self.captureSession?.stopRunning()
            self.isSessionRunning = (self.captureSession?.isRunning)!
        }
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
    
    @IBAction func dismissFromCameraViewButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func flashlightOnOff(_ sender: Any) {
        setFlashlight()
    }
    
    @IBAction func frameworkFunction(_ sender: Any) {
        print("button tapped!")
    }
}









