//
// VideoPreviewViewControlle.swift
//  VideoDoctor
//
//  Created by BrotherP on 2017-04-29.
//  Copyright © 2017 BrotherP. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPreviewViewController: UIViewController {
    
    
    static let assetKeysRequiredToPlay = ["playable","hasProtectedContent"]
    
    let player = AVPlayer()
    
    var asset:AVURLAsset? {
        
        didSet {
            guard let newAsset = asset else { return }
            loadURLAsset(newAsset)
        }
    }
    
    
    var playerLayer:AVPlayerLayer? {
        return playerView.playerLayer
    }
    
    
    var playerItem:AVPlayerItem? {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
            player.actionAtItemEnd = .none
        }
    }
    
    
    var fileLocation:URL? {
        
        didSet {
            self.asset = AVURLAsset(url: self.fileLocation!)
        }
    }
    
    @IBOutlet weak var playerView:PlayerView!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var playPauseButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        addObserver(self, forKeyPath: "player.rate", options: [.new, .initial], context: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerReachedEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        
        self.playerView.playerLayer.player = player
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver(self, forKeyPath: "player.currentItem.status", context: nil)
        removeObserver(self, forKeyPath: "player.rate", context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func loadURLAsset(_ asset: AVURLAsset) {
        
        asset.loadValuesAsynchronously(forKeys: VideoPreviewViewController.assetKeysRequiredToPlay) {
            DispatchQueue.main.async {
                guard asset == self.asset else { return }
                for key in VideoPreviewViewController.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if !asset.isPlayable || asset.hasProtectedContent {
                        let message = "Video cannot play."
                        self.showAlert(title: "Error", message: message, dismiss: false)
                        return
                    }
                    
                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
                        
                        let message = "Failed to load"
                        self.showAlert(title: "Error", message: message, dismiss: false)
                        
                        
                        return
                    }
                }
                
                self.playerItem = AVPlayerItem(asset: asset)
            }
        }
    }
    
    
    
    
    
    @IBAction func closePreview() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveToLibrary() {
        
        self.saveVideoToUserLibrary()
    }
    
    @IBAction func playPauseButtonPressed() {
        
        self.updatePlayPauseButtonTitle()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "player.currentItem.status" {
            
            playPauseButton.isHidden = false
            saveButton.isHidden = false
            
        }
    }
    
    
    func playerReachedEnd(notification:NSNotification) {
        
        self.asset = AVURLAsset(url: self.fileLocation!)
        self.updatePlayPauseButtonTitle()
    }
    
    
    func saveVideoToUserLibrary(){
        PhotoManager().saveVideoToUserLibrary(fileUrl: self.fileLocation!) { (success, error) in
            if success {
                self.showAlert(title: "Success", message: "Video saved Success", dismiss: true)
            } else {
                self.showAlert(title: "Error", message: (error?.localizedDescription)!, dismiss: false)
            }
        }
    }
    
    func showAlert(title:String, message:String, dismiss:Bool) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if dismiss {
            controller.addAction(UIAlertAction(title: "OKay", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
        } else {
            controller.addAction(UIAlertAction(title: "OKay", style: .default, handler: nil))
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func updatePlayPauseButtonTitle() {
        if player.rate > 0 {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
            playPauseButton.backgroundColor = UIColor.lightGray
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
            playPauseButton.backgroundColor = UIColor.gray
        }
    }
    
}
