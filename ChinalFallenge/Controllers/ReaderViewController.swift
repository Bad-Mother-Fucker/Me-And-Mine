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
    
    //STACK VIEW
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var dismissAndTorchStackView: UIStackView!
    
    //TEXT VIEW
    @IBOutlet weak var SpeechText: UITextView!
    
    //BUTTONS
    @IBOutlet weak var torchOnOff: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var coreMLButton: UIButton!
    @IBOutlet weak var OCRButton: UIButton!
    @IBOutlet weak var removeBackgroundButton: UIButton!
    @IBOutlet weak var speechRecognitionButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!

    //OTHER ATTRIBUTES
    var speech: [String]?
    
    //TYPE QR/BAR CODE SCANNING
    struct codeType {
        static let supportedTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.qr]
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setCameraSession()
        instantiatePhotoOutput()
        autoFocusMode()
        requestAuthorization()
        self.imageView = UIImageView(frame: self.view.frame)
        
        //Hide keyboard tapping everywhere
        let tapGestureDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureDismissKeyboard)
    }
    
    //VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationAndTabBarController()
        checkCaptureSession()
        self.SpeechText.isSelectable = false
    }
    
    //FUNCTION TO HIDE KEYBOARD
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    //BUTTON TO RECORD SPEECH
    @IBAction func startSpeech(_ sender: UIButton) {
        if (self.flagOnSpeech == false) {
            startRecordingSpeech()
            self.flagOnSpeech = true
        } else {
            stopRecordingSpeech()
            self.flagOnSpeech = false
        }
    }
    
    //AACTION FLASHLIGHT
    @IBAction func torchStatus(_ sender: UIButton) {
        switch self.flashMode {
        case .auto:
            self.flashMode = .on
            self.torchOnOff.setImage(#imageLiteral(resourceName: "FlashOn"), for: .normal)
        case .on:
            self.flashMode = .off
            self.torchOnOff.setImage(#imageLiteral(resourceName: "FlashOff"), for: .normal)
        case .off:
            self.flashMode = .auto
            self.torchOnOff.setImage(#imageLiteral(resourceName: "FlashAuto"), for: .normal)
        }
    }
    
    //ACTION TAKE PHOTO BUTTON
    @IBAction func takePhotoButton(_ sender: UIButton) {
        //nascondere bottone torcia e bottone dismiss
        onTapTakePhoto()
        captureSession?.stopRunning()
        setFrameworksButton()
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 1
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







