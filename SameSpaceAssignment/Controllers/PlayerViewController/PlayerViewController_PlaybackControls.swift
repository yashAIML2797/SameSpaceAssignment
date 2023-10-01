//
//  PlayerViewController_PlaybackControls.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import UIKit

extension PlayerViewController {
    
    func start() {
        resetViews()
        AudioManager.shared.stop()
        if let song = currentPlayingSong {
            if let url = URL(string: song.url) {
                AudioManager.shared.start(itemURL: url)
                
                if let asset = AudioManager.shared.currentAsset {
                    Task {
                        let duration = try await asset.load(.duration)
                        let timeformatter = NumberFormatter()
                        timeformatter.minimumIntegerDigits = 2
                        timeformatter.minimumFractionDigits = 0
                        timeformatter.roundingMode = .down
                        
                        let minutes = duration.seconds / 60
                        let seconds = duration.seconds.truncatingRemainder(dividingBy: 60)
                        
                        if let minStr = timeformatter.string(from: NSNumber(value: minutes)),
                           let secStr = timeformatter.string(from: NSNumber(value: seconds)) {
                            self.currentTimeLabel.text = "00:00"
                            self.overallTimeLabel.text = "\(minStr):\(secStr)"
                            let config = UIImage.SymbolConfiguration(pointSize: 64)
                            self.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
                        }
                        
                        AudioManager.shared.addTimeObserver { [weak self] currentTime in
                            print(currentTime)
                            let progress = currentTime / duration.seconds
                            self?.progressView.progress = Float(progress)

                            let minutes = currentTime / 60
                            let seconds = currentTime.truncatingRemainder(dividingBy: 60)

                            if let minStr = timeformatter.string(from: NSNumber(value: minutes)),
                               let secStr = timeformatter.string(from: NSNumber(value: seconds)) {
                                self?.currentTimeLabel.text = "\(minStr):\(secStr)"
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
        
        start()
    }
    
    @objc func handlePreviousButtonAction(sender: UIButton) {
        
        guard AudioManager.shared.currentTime <= 3 else {
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
        
        start()
    }
}
