//
//  PlayerViewController_Notifications.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import UIKit

extension PlayerViewController {
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishCurrentTrack), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func didFinishCurrentTrack(notification: Notification) {
        
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
}
