//
//  PlayerViewController_PlaybackControls.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import UIKit
import AVFoundation

extension PlayerViewController {
    
    func configurePlayerOnLaunch() {
        //MARK: Check if selected song is already playing
        if let url = (AudioManager.shared.currentAsset as? AVURLAsset)?.url, let song = currentPlayingSong, url.absoluteString == song.url {
            //MARK: YES - Update the views with current progress of song
            
            let duration = AudioManager.shared.duration

            if let minStr = duration.minStr,
               let secStr = duration.secStr {
                self.overallTimeLabel.text = "\(minStr):\(secStr)"
            }
            
            AudioManager.shared.addTimeObserver { [weak self] currentTime in
                
                let progress = Float(currentTime.seconds / duration.seconds)
                if let minStr = currentTime.minStr,
                   let secStr = currentTime.secStr {
                    self?.updateViewsWithCurrentProgress(progress: progress, minString: minStr, secString: secStr)
                }
            }
            
            if AudioManager.shared.isPlaying {
                let config = UIImage.SymbolConfiguration(pointSize: 64)
                playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
            }
            
            if AudioManager.shared.isPaused {
                let config = UIImage.SymbolConfiguration(pointSize: 64)
                playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
                
                let currentTime = AudioManager.shared.currentTime
                let progress = Float(currentTime.seconds / duration.seconds)

                if let minStr = currentTime.minStr,
                   let secStr = currentTime.secStr {
                    self.updateViewsWithCurrentProgress(progress: progress, minString: minStr, secString: secStr)
                }
            }
            
        } else {
            //MARK: YES - Start the song and update views.
            startCurrentPlayingSong()
        }
    }
    
    func startCurrentPlayingSong() {
        resetViews()
        AudioManager.shared.stop()
        if let song = currentPlayingSong {
            if let url = URL(string: song.url) {
                AudioManager.shared.start(itemURL: url)
                
                if let asset = AudioManager.shared.currentAsset {
                    Task {
                        let duration = try await asset.load(.duration)
                        
                        if let minStr = duration.minStr,
                           let secStr = duration.secStr {
                            self.setViewsBeforeStart(minString: minStr, secString: secStr)
                        }
                        
                        AudioManager.shared.addTimeObserver { [weak self] currentTime in
                            print(currentTime)
                            let progress = Float(currentTime.seconds / duration.seconds)
                            if let minStr = currentTime.minStr,
                               let secStr = currentTime.secStr {
                                self?.updateViewsWithCurrentProgress(progress: progress, minString: minStr, secString: secStr)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func resetViews() {
        self.progressView.progress = 0
        self.currentTimeLabel.text = "-:--"
        self.overallTimeLabel.text = "-:--"
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        self.playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
    }
    
    func setViewsBeforeStart(minString: String, secString: String) {
        self.progressView.progress = 0
        self.currentTimeLabel.text = "00:00"
        self.overallTimeLabel.text = "\(minString):\(secString)"
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        self.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
    }
    
    func updateViewsWithCurrentProgress(progress: Float, minString: String, secString: String) {
        self.progressView.progress = progress
        self.currentTimeLabel.text = "\(minString):\(secString)"
    }
    
    @objc func handlePlayPauseButtonAction(sender: UIButton) {
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        
        if AudioManager.shared.isPlaying {
            AudioManager.shared.pause()
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        } else {
            AudioManager.shared.play()
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        }
    }
    
    @objc func handleNextButtonAction(sender: UIButton) {
        if let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout {
            if layout.currentItemIdex < (songs.count - 1) {
                layout.currentItemIdex += 1
            } else {
                layout.currentItemIdex = songs.count - 1
            }
            let offsetX = layout.getTargetOffsetX(for: layout.currentItemIdex)
            self.coverFlowView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            let song = songs[layout.currentItemIdex]
            self.currentPlayingSong = song
            self.configure(with: song)
        }
        
        startCurrentPlayingSong()
    }
    
    @objc func handlePreviousButtonAction(sender: UIButton) {
        
        guard AudioManager.shared.currentTime.seconds <= 3 else {
            AudioManager.shared.pause()
            AudioManager.shared.restart()
            AudioManager.shared.play()
            return
        }
        
        if let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout {
            if layout.currentItemIdex > 0 {
                layout.currentItemIdex -= 1
            } else {
                layout.currentItemIdex = 0
            }
            
            let offsetX = layout.getTargetOffsetX(for: layout.currentItemIdex)
            self.coverFlowView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            let song = songs[layout.currentItemIdex]
            self.currentPlayingSong = song
            self.configure(with: song)
        }
        
        startCurrentPlayingSong()
    }
}
