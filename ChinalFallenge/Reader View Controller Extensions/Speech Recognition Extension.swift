//
//  Speech Recognition Extension.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import AVFoundation
import UIKit
import Speech

// ############### SPEECH RECOGNITION ###############

extension ReaderViewController: SFSpeechRecognizerDelegate, AVAudioRecorderDelegate {
    
    //REQUEST AUTHORIZATION FOR SPEECH RECOGNITION
    func requestSpeechAuthorization() {
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
                let speech = speechResult?.bestTranscription.formattedString
                self.handleSpeechText(speech!)
            }
            if (error != nil || isFinal) {
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
    
    func handleSpeechText(_ speech: String) {
        self.view.addSubview(self.SpeechText)
        self.SpeechText.text = speech
        self.SpeechText.isEditable = true
    }
}
