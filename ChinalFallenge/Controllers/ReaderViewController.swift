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
    
    //MARK: ATTRIBUTES FOR CAMERA
    var captureSession: AVCaptureSession?
    var videoDeviceInput: AVCaptureDeviceInput?
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
    var isCaptureSessionConfigured = false // Instance proprerty on this view controller class
    let photoOutput = AVCapturePhotoOutput()
    
    //MARK: ATTRIBUTE FOR SPEECH RECOGNITION
    let speechRec = SpeechRecognitionEngine()
    
    //MARK: VIEW
    @IBOutlet weak var cameraView: VideoPreviewView!
    @IBOutlet weak var trashButton: UIButton!
    
    //MARK: TEXT VIEW
    @IBOutlet weak var SpeechText: UITextView!
    
    //MARK: COLLECTION VIEW
    @IBOutlet weak var frameworksCollectionView: UICollectionView!
    
    //OTHER ATTRIBUTES
    var speech: [String]?
    let sessionQueue = DispatchQueue(label: "session queue")
    var setupResult: SessionSetupResult = .success
    var isSessionRunning = false
    var imageView: UIImageView!
    var flashMode = AVCaptureDevice.FlashMode.off
    var flagOnSpeech = false
    let nameFrameworks = ["Smart Read","Dictation","Extract"]
    
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
        setButtonOnCameraView()
        frameworksCollectionView.delegate = self
        frameworksCollectionView.dataSource = self
    }
    
    //VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        tabBarController?.tabBar.isHidden = true
        session()
        settingTextView()
        gesturesReaderView()
        self.imageView = UIImageView(frame: self.cameraView.frame)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.setupResult == .success {
            self.captureSession?.stopRunning()
            self.isSessionRunning = (self.captureSession?.isRunning)!
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        displayVideoPreviewLayer()
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    } I don't need this method anymore becase I do the same in viewWillAppear with the line: UIApplication.shared...
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        onTapTakePhoto()
        setSwipeGestureFrameworksAndOtherButtons()
    }
    
    @IBAction func dismissFromCameraViewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToDiscoverView", sender: self)
    }
    
    @IBAction func flashlightOnOff(_ sender: Any) {
        setFlashlight()
    }
    
    @IBAction func trushFunction(_ sender: Any) {
        self.captureSession?.startRunning()
        setButtonOnCameraView()
        self.imageView.removeFromSuperview()
        self.imageView.image = nil
    }
    
    @IBAction func focusAndExposeTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let devicePoint = self.cameraView.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: gestureRecognizer.location(in: gestureRecognizer.view))
        focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
    }
}









