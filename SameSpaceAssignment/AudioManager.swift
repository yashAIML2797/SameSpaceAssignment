//
//  AudioManager.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import Foundation
import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    
    var player: AVPlayer?
    private var timeObserver: Any?
    
    var isPlaying: Bool {
        player?.timeControlStatus == .playing
    }
    
    var isPaused: Bool {
        player?.timeControlStatus == .paused
    }
    
    var currentAsset: AVAsset? {
        player?.currentItem?.asset
    }
    
    var currentTime: Double {
        player?.currentTime().seconds ?? .zero
    }
    
    var duration: Double {
        player?.currentItem?.duration.seconds ?? .zero
    }
    
    private init() {
        
    }
    
    func start(itemURL: URL) {
        let item = AVPlayerItem(url: itemURL)
        
        if let player = player {
            player.replaceCurrentItem(with: item)
        } else {
            player = AVPlayer(playerItem: item)
        }
        
        play()
    }
    
    func play() {
        guard !isPlaying else {
            return
        }
        
        player?.play()
    }
    
    func pause() {
        guard isPlaying else {
            return
        }
        
        player?.pause()
    }
    
    func stop() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        self.player = nil
    }
    
    func addTimeObserver(completion: @escaping (Double) -> Void) {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            completion(time.seconds)
        })
    }
    
    func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    func restart() {
        player?.seek(to: .zero)
    }
}
