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
    let sessionQueue = DispatchQueue(label: "session queue")
    var setupResult: SessionSetupResult = .success
    var isSessionRunning = false
    var imageView: UIImageView!
    var itemPhotos:[UIImageView] = []
    var flashMode = AVCaptureDevice.FlashMode.off
    var flagOnSpeech = false
    var parentPVC: MasterViewController!
    var attributes: [String] = []
    
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
        setImagePreviewView()
    }
    
    func setImagePreviewView(){
//        Set a view on which the preview of the photo will be shwon
        self.imageView = UIImageView(frame: self.cameraView.frame)
//        Set constraints to keep it locked to the view when it is going to resize
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: cameraView, attribute: .height, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: cameraView, attribute: .width, multiplier: 1, constant: 0)
        let xAlignmentConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: cameraView, attribute: .centerX, multiplier: 1, constant: 0)
        let yAlignmentConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: cameraView, attribute: .centerY, multiplier: 1, constant: 0)
        let constraints = [heightConstraint,widthConstraint,xAlignmentConstraint,yAlignmentConstraint]
        cameraView.addSubview(imageView)
        cameraView.addConstraints(constraints)
        
    }
    
    //VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        session()
        settingTextView()
        gesturesReaderView()
//        setScrollView()
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
    }
    
    @IBAction func cornerLeft(_ sender: UIButton) {
        switch sender.tag {
        case 0:
//       settings
            break
        case 1:
            self.captureSession?.startRunning()
            setButtonOnCameraView()
            self.imageView.removeFromSuperview()
            self.imageView.image = nil
            break
        default:
            break
        }
  
    }
    
    @IBAction func centerButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            onTapTakePhoto()
            setButtonsAfterPhoto()
        case 1:
            centerButton.setImage(#imageLiteral(resourceName: "cameraWithMicrophoneButton"), for: .selected)
            speechRec.startRecordingSpeech(speechTextView: SpeechText)
            break
        default:
            break
        }
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
//            PickImageFromCameraRoll() ---> Should be PickImageFromOurApp() ????? why?
            break
        case 1:
//            ML()
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
//            OCR()
            break
        default:
            break
        }
    }
}









