//
//  PlayerViewController_ViewUpdates.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import UIKit

extension PlayerViewController {
    func resetViews() {
        self.progressView.progress = 0
        self.currentTimeLabel.text = "-:--"
        self.overallTimeLabel.text = "-:--"
        self.setButtonToPlay()
    }
    
    func setViewsBeforeStart(minString: String, secString: String) {
        self.progressView.progress = 0
        self.currentTimeLabel.text = "00:00"
        self.overallTimeLabel.text = "\(minString):\(secString)"
        self.setButtonToPause()
    }
    
    func updateViewsWithCurrentProgress(progress: Float, minString: String, secString: String) {
        self.progressView.progress = progress
        self.currentTimeLabel.text = "\(minString):\(secString)"
    }
    
    func setButtonToPlay() {
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        self.playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
    }
    
    func setButtonToPause() {
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        self.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
    }
}
