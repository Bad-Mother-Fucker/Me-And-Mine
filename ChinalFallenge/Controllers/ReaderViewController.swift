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
import UserNotifications
import UserNotificationsUI

class ReaderViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var stackView: UIStackView!
    
    struct codeType {
        static let supportedTypes = [AVMetadataObject.ObjectType.upce,
                                     AVMetadataObject.ObjectType.code39,
                                     AVMetadataObject.ObjectType.code39Mod43,
                                     AVMetadataObject.ObjectType.code93,
                                     AVMetadataObject.ObjectType.code128,
                                     AVMetadataObject.ObjectType.ean8,
                                     AVMetadataObject.ObjectType.ean13,
                                     AVMetadataObject.ObjectType.aztec,
                                     AVMetadataObject.ObjectType.pdf417,
                                     AVMetadataObject.ObjectType.itf14,
                                     AVMetadataObject.ObjectType.dataMatrix,
                                     AVMetadataObject.ObjectType.interleaved2of5,
                                     AVMetadataObject.ObjectType.qr]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        self.tabBarController?.tabBar.isHidden = true
        startSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

extension ReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func startSession() {
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
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput))! {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = codeType.supportedTypes
        } else {
            failed()
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)
        self.view.bringSubview(toFront: self.stackView)
        captureSession?.startRunning()
    }
    
    func failed() {
        let allert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(allert,animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
    }
    
}
























