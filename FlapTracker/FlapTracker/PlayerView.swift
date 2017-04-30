//
// PlayerView.swift
//  VideoDoctor
//
//  Created by BrotherP on 2017-04-29.
//  Copyright © 2017 BrotherP. All rights reserved.
//
import UIKit
import AVFoundation

class PlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override public class var layerClass:Swift.AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
}
