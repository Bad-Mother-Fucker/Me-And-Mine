//
//  Speech Recognition.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 11/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import AVFoundation
import UIKit
import Speech

// ############### CLASS SPEECH RECOGNITION ###############

class SpeechRecognitionEngine {
    
    let speechRecognizer = SFSpeechRecognizer.init(locale: Locale.current)
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var groupWords: [String] = []
    
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
    func startRecordingSpeech(speechTextView: UITextView) {
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
        }
            if (error != nil || isFinal) {
                debugPrint(speechResult?.bestTranscription.formattedString as Any)
                inputNode.removeTap(onBus: 0)
                let speech = speechResult?.bestTranscription.formattedString 
//                self.handleSpeechText(speech!, speechTextView: speechTextView)
                let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
                tagger.string = speech
                let range = NSRange(location: 0, length: (speech?.utf16.count)!)
                let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
                tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
                    if let tag = tag {
                        if tag.rawValue == "Adjective" || tag.rawValue == "Noun" {
                            let word = (speech! as NSString).substring(with: tokenRange)
                            self.groupWords.append(word)
                            speechTextView.text = self.groupWords.joined(separator: " , ")
                            print("groupWords:\(self.groupWords)")
                        }
                    }
                }
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
    
    func handleSpeechText(_ speech: String, speechTextView: UITextView) {
        speechTextView.isHidden = false
        speechTextView.isEditable = true
    }
}
