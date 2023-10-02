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
                self.setButtonToPause()
            }
            
            if AudioManager.shared.isPaused {
                self.setButtonToPlay()
                
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
    
    func moveToNextSong() {
        if let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout {
            
            var nextSongIndex = layout.currentItemIdex
            
            if layout.currentItemIdex < (songs.count - 1) {
                nextSongIndex += 1
            } else {
                nextSongIndex = songs.count - 1
            }
            let offsetX = layout.getTargetOffsetX(for: nextSongIndex)
            self.coverFlowView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            
            layout.currentItemIdex = nextSongIndex
            let nextSong = songs[nextSongIndex]
            self.currentPlayingSong = nextSong
            self.configure(with: nextSong)
        }
        
        startCurrentPlayingSong()
    }
    
    func moveToPreviousSong() {
        guard AudioManager.shared.currentTime.seconds <= 3 else {
            AudioManager.shared.pause()
            AudioManager.shared.restart()
            AudioManager.shared.play()
            return
        }
        
        if let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout {
            var previousSongIndex = layout.currentItemIdex
            
            if layout.currentItemIdex > 0 {
                previousSongIndex -= 1
            } else {
                previousSongIndex = 0
            }
            
            let offsetX = layout.getTargetOffsetX(for: previousSongIndex)
            self.coverFlowView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            layout.currentItemIdex = previousSongIndex
            let previousSong = songs[previousSongIndex]
            self.currentPlayingSong = previousSong
            self.configure(with: previousSong)
        }
        
        startCurrentPlayingSong()
    }
    
    @objc func handlePlayPauseButtonAction(sender: UIButton) {
        if AudioManager.shared.isPlaying {
            AudioManager.shared.pause()
            self.setButtonToPlay()
        } else {
            AudioManager.shared.play()
            self.setButtonToPause()
        }
    }
    
    @objc func handleNextButtonAction(sender: UIButton) {
        moveToNextSong()
    }
    
    @objc func handlePreviousButtonAction(sender: UIButton) {
        moveToPreviousSong()
    }
}
