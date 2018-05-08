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
    //ATTRIBUTES FOR SPEECH RECOGNITION
    private let speechRecognizer = SFSpeechRecognizer.init(locale: Locale.current)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
//    //STACK VIEW
//    @IBOutlet weak var stackViewDismiss: UIStackView!
//    @IBOutlet weak var stackViewTorch: UIStackView!
//    @IBOutlet weak var coreMLStack: UIStackView!
//    @IBOutlet weak var OCRStack: UIStackView!
//    @IBOutlet weak var removeBackgroundStack: UIStackView!
//    @IBOutlet weak var speechRecognitionStack: UIStackView!
//    @IBOutlet weak var photoStack: UIStackView!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    
// TEXT VIEW
    
    @IBOutlet weak var SpeechText: UITextView!
    
    
    //BUTTONS
    @IBOutlet weak var torchOnOff: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var coreMLButton: UIButton!
    @IBOutlet weak var OCRButton: UIButton!
    @IBOutlet weak var removeBackgroundButton: UIButton!
    @IBOutlet weak var speechRecognitionButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var dismissPhoto: UIButton!

   
    //OTHER ATTRIBUTES
    var speech: [String]?
    
    //TYPE QR/BAR CODE SCANNING
    struct codeType {
        static let supportedTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.qr]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCameraSession()
        instantiatePhotoOutput()
        autoFocusMode()
        requestAuthorization()
        self.imageView = UIImageView(frame: self.view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
        
        checkCaptureSessionOff()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRecordingSpeech()
        checkCaptureSessionOn()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func startSpeech(_ sender: UIButton) {
        startRecordingSpeech()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    @IBAction func dismissPhoto(_ sender: UIButton) {
        self.imageView.removeFromSuperview()
        self.dismissPhoto.isHidden = true
    }
    
    func setNavigationControll() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancell.png"), style: .done, target: self, action: #selector(dismissCameraView))
    }
    
    func setFlashDismissPhotoButtons() {
        self.dismissButton.setBackgroundImage(UIImage(named: "dismiss.png"), for: .normal)
        self.torchOnOff.setBackgroundImage(UIImage(named: "flashOff.png"), for: .normal)
        self.photoButton.setBackgroundImage(UIImage(named: "photoButton.png"), for: .normal)
//        self.view.bringSubview(toFront: self.stackViewDismiss)
//        self.view.bringSubview(toFront: self.stackViewTorch)
//        self.view.bringSubview(toFront: self.photoStack)
        self.view.bringSubview(toFront: self.photoButton)
        self.view.bringSubview(toFront: self.dismissButton)
        self.view.bringSubview(toFront: self.torchOnOff)
    }
    
    func setFrameworksButton() {
        self.coreMLButton.setBackgroundImage(UIImage(named: "coreml.png"), for: .normal)
        self.OCRButton.setBackgroundImage(UIImage(named: "ocr.png"), for: .normal)
        self.removeBackgroundButton.setBackgroundImage(UIImage(named: "forbici.png"), for: .normal)
        self.speechRecognitionButton.setBackgroundImage(UIImage(named: "microphone.png"), for: .normal)
//        self.view.addSubview(self.coreMLStack)
//        self.view.addSubview(self.OCRStack)
//        self.view.addSubview(self.removeBackgroundStack)
//        self.view.addSubview(self.speechRecognitionStack)
        self.view.addSubview(imageView)
        self.view.addSubview(buttonsStackView)
        
    }
    
    //AACTION FLASHLIGHT
    @IBAction func torchStatus(_ sender: UIButton) {
        flash()
    }
    
    //ACTION DISMISS
    @IBAction func dismissFromReaderView(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    //ACTION TAKE PHOTO BUTTON
    @IBAction func takePhotoButton(_ sender: UIButton) {
        //nascondere bottone torcia e bottone dismiss
        setFrameworksButton()
        onTapTakePhoto()
    }
    
    @objc func dismissCameraView() {
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 1
    }
    
    //FUNCTIONS FOR CAPTURE SESSION USED BY ViewWillDisappear
    func checkCaptureSessionOn() {
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    //FUNCTIONS FOR CAPTURE SESSION USED BY ViewDidDisappear
    func checkCaptureSessionOff() {
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
}

// ############### READER VIEW CONTROLLER EXTENSION ###############

extension ReaderViewController {

    //FLASHLIGHT FUNCTION
    func flash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        if (device.hasTorch) {
            //Check if the device has the flashlight.
            if device.isTorchAvailable {
                do {
                    try device.lockForConfiguration()
                    if (device.torchMode == .on) {
                        device.torchMode = .off
                        self.torchOnOff.setImage(UIImage(named: "flashOff.png"), for: .normal)
                    } else {
                        device.torchMode = .on
                        self.torchOnOff.setImage(UIImage(named: "flashOn.png"), for: .normal)
                    }
                    device.unlockForConfiguration()
                } catch {
                    print("Torch could not be used")
                    print(error)
                }
            }
            else {
                print("Torch is not available")
            }
        }
    }
    
    //ALERT FUNCTION
    func alert() {
        let alert = UIAlertController(title: "QR/Bar Code caught", message: "Step1: add info - Step2: capture new QR/Bar Code", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Step1", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "addDetailsItems", sender: self)
            self.captureSession?.stopRunning()
        }))
        
        alert.addAction(UIAlertAction(title: "Step2", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.captureSession?.startRunning()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //FAILED FUNCTION
    func failed() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert,animated: true)
        captureSession = nil
    }
    
    //FOCUS FUNCTION
    func autoFocusMode() {
        guard let cameraFocus = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        if cameraFocus.isFocusModeSupported(.continuousAutoFocus) {
            try! cameraFocus.lockForConfiguration()
            cameraFocus.focusMode = .continuousAutoFocus
            cameraFocus.unlockForConfiguration()
        }
    }
    
    func found(code: String) {
        print(code)
    }
}

// ############### CAMERA SESSION ###############

extension ReaderViewController: AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    //SET CAMERA ON THE VIEW.
    func setCameraSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession?.canAddInput(videoInput))! {
            captureSession?.addInput(videoInput)
        } else {
            failed()
            return
        }
        //HANDLE SECOND THREAD
        DispatchQueue.main.async {
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
            self.videoPreviewLayer?.frame = self.view.layer.bounds
            self.videoPreviewLayer?.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.videoPreviewLayer!)
            self.setFlashDismissPhotoButtons()
            self.captureSession?.startRunning()
        }
    }
    
    func instantiatePhotoOutput() {
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        // Set the output on the capture session
        if (captureSession?.canAddOutput(capturePhotoOutput!))! {
            captureSession?.addOutput(capturePhotoOutput!)
        } else {
            return
        }
    }
    
    //CALLED WHEN THE USER TAP THE BUTTON "TAKE A PHOTO"
    func onTapTakePhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else {return} // Make sure capturePhotoOutput is valid
        let photoSettings = AVCapturePhotoSettings() // Get an instance of AVCapturePhotoSettings class
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    //PHOTO OUTPUT FUNCTION
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error:Error?) {
        // get captured image - Make sure we get some photo sample buffer
        guard error == nil else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album -- CHANGE HERE TO SAVE ONLY IN OUR APP USING CORE DATA.
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.imageView.image = image
        }
    }
    
    //SET QR CODE METADATA OBJECT FUNCTION
    func setMetadataObject() {
        //GET METADATA OBJECT
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession?.canAddOutput(metadataOutput))! {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = codeType.supportedTypes
        } else {
            failed()
            return
        }
    }
    
    //METADATA OUTPUT FUNCTION
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        // Get the metadata object.
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
        }
        dismiss(animated: true)
        alert()
    }
}

// ############### SPEECH RECOGNITION ###############

extension ReaderViewController: SFSpeechRecognizerDelegate, AVAudioRecorderDelegate {
    
    //REQUEST AUTHORIZATION FOR SPEECH RECOGNITION
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authorization) in
            switch authorization {
            case .authorized:
                print("ok.")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Speech recognition restricted on this device")
            }
        }
    }
    
    //START RECORDING SPEECH FUNCTION
    func startRecordingSpeech() {
        if (self.recognitionTask != nil) {
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = self.audioEngine.inputNode
        let recognitionRequest = self.recognitionRequest
        
        recognitionRequest?.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (speechResult, error) in
            var isFinal = false
            if (speechResult != nil) {
                isFinal = (speechResult?.isFinal)!
                self.SpeechText.text = speechResult?.bestTranscription.formattedString
            }
            if (error != nil || isFinal) {
                //qui salvo ciò che dico
                debugPrint(speechResult?.bestTranscription.formattedString as Any)
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        self.audioEngine.prepare()
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        guard let myRecognizer = SFSpeechRecognizer() else {return}
        if !myRecognizer.isAvailable {return}
        debugPrint("start recording")
    }
    
    //STOP RECORDIONG SPEECH FUNCTION
    func stopRecordingSpeech() {
        self.audioEngine.stop()
        self.recognitionTask?.finish()
        self.recognitionRequest?.endAudio()
        debugPrint("stop recording.")
    }
}
























