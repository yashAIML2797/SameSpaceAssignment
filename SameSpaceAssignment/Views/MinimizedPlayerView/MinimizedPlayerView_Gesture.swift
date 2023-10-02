//
//  MinimizedPlayerView_Gesture.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import UIKit

extension MinimizedPlayerView {
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if let song = currentPlayingSong {
            launchPlayerDelegate?.loadPlayer(with: songs, startingAt: song)
        }
    }
}
