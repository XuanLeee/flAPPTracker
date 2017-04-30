//
// AudioViewController.swift
//  VideoDoctor
//
//  Created by BrotherP on 2017-04-29.
//  Copyright © 2017 BrotherP. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    @IBOutlet weak var recordButton:UIButton!
    @IBOutlet weak var playButton:UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareAudioRecorder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func recordButtonPressed(sender:AnyObject) {
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
                print(error)
            }
        } else {
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch {
                print(error)
            }
            
            if self.verifyFileExists() {
                print("file exists")
                playButton.isHidden = false
            } else {
                print("There was a problem recording")
            }
        }
        
        self.updateRecordButtonTitle()
    }
    
    @IBAction func playButtonPressed(sender:AnyObject) {
        
        self.playAudio()
    }
    
    func prepareAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: URL(fileURLWithPath: self.audioFileLocation()), settings: self.audioRecorderSettings())
            audioRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    func playAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: self.audioFileLocation()))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
    func audioFileLocation() -> String {
        return NSTemporaryDirectory().appending("audioRecord.m4a")
    }
    
    func audioRecorderSettings() -> [String:Any] {
        let settings = [AVFormatIDKey : NSNumber.init(value: kAudioFormatAppleLossless),
                        AVSampleRateKey : NSNumber.init(value: 44100.0),
                        AVNumberOfChannelsKey : NSNumber.init(value: 1),
                        AVLinearPCMBitDepthKey: NSNumber.init(value: 16),
                        AVEncoderAudioQualityKey : NSNumber.init(value: AVAudioQuality.high.rawValue)]
        return settings
    }
    
    func updateRecordButtonTitle() {
        if audioRecorder.isRecording {
            recordButton.setTitle("Recording...", for: .normal)
            recordButton.backgroundColor=UIColor.red
        } else {
            recordButton.setTitle("Start Record", for: .normal)
            recordButton.backgroundColor=UIColor.cyan
            
        }
    }
    
    func verifyFileExists() -> Bool {
        let fileManager = FileManager.default
        
        return fileManager.fileExists(atPath: self.audioFileLocation())
    }
    
}
