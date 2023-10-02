//
//  MinimizedPlayerView_Notifications.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import UIKit

extension MinimizedPlayerView {
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishCurrentTrack), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func didFinishCurrentTrack(notification: Notification) {
        //Move to next song.
        if let currentPlayingSong = currentPlayingSong,
           let currentIndex = songs.firstIndex(where: {$0.id == currentPlayingSong.id})
        {
            var nextSongIndex = currentIndex
            
            if currentIndex < (songs.count - 1) {
                nextSongIndex += 1
            } else {
                nextSongIndex = songs.count - 1
            }
            
            let nextSong = songs[nextSongIndex]
            self.currentPlayingSong = nextSong
            self.configure(with: nextSong)
            if let url = URL(string: nextSong.url) {
                AudioManager.shared.start(itemURL: url)
            }
        }
    }
}
