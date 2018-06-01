//
//  ReaderViewController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 18/04/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

// ############### READER VIEW CONTROLLER ###############

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
    let detectionEngine = DetectionEngine()
    
    //MARK: ATTRIBUTE FOR SPEECH RECOGNITION
    let speechRec = SpeechRecognitionEngine()
    
    //MARK: VideoPreviewView Outlet
    @IBOutlet weak var cameraView: VideoPreviewView!
    
    //MARK: TEXT VIEW
    @IBOutlet weak var SpeechText: UITextView!
    
    //MARK: COLLECTION VIEW
    @IBOutlet weak var attributesCollectionView: UICollectionView! {
        didSet {
            attributesCollectionView.delegate = self
            attributesCollectionView.dataSource = self
        }
    }
    
    //OTHER ATTRIBUTES
    var speech: [String]?
    let sessionQueue = DispatchQueue(label: "com.DeCrapifiers.ChinalFallenge.sessionQueue")
    let speechQueue = DispatchQueue(label: "com.Decrapifiers.ChinalFallenge.speechQueue", qos: .default)
    var setupResult: SessionSetupResult = .success
    var isSessionRunning = false
    var imageView = UIImageView()
    var itemPhotos: [UIImageView] = []
    var flashMode = AVCaptureDevice.FlashMode.off
    var flagOnSpeech = false
    var parentPVC: MasterViewController!
    var presentedImage: UIImage?
    var currentItem = MyItem()
 
    
    //ENUM
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    //MARK: BUTTONS
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var conrnerLeftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
   
    
    //TYPE QR/BAR CODE SCANNING
    struct codeType {
        static let supportedTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.qr]
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraAuthorization()
        setButtonOnCameraView()
        self.SpeechText.delegate = self
        self.centerButton.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.centerButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
    }
    
    //VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        session()
        settingTextView()
        gesturesReaderView()
        //setScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        displayVideoPreviewLayer()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: IBAction FUNCTIONS.
    @IBAction func focusAndExposeTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let devicePoint = self.cameraView.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: gestureRecognizer.location(in: gestureRecognizer.view))
        focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
    }
    
    @IBAction func dismissFromCameraViewButton(_ sender: Any) {
        parentPVC.setViewControllers([parentPVC.viewControllers[1]], direction: .forward, animated: true, completion: nil)
        self.centerButton.tag = 0
    }
    
    @IBAction func cornerLeft(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            //settings
            break
        case 1:
            self.captureSession?.startRunning()
            setButtonOnCameraView()
            self.imageView.removeFromSuperview()
            self.imageView.image = nil
            self.centerButton.tag = 0
        default:
            break
        }
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // TODO: ImagePicker
            //PickImageFromCameraRoll()
            break
        case 1:
            // TODO: OCR
            //OCR()
            break
        default:
            break
        }
    }
    
    @IBAction func leftButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            setFlashlight()
        case 1:
            guard let _ = presentedImage else {break}
            detectionEngine.updateClassifications(for: presentedImage!)
            currentItem.identifier = detectionEngine.classificationResult.0
            attributesCollectionView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func centerButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            onTapTakePhoto()
            setButtonsAfterPhoto()
            sender.tag = 1
        case 1:
            sender.tag = 2
        default:
            sender.tag = 1
        }
    }
    
    
}




