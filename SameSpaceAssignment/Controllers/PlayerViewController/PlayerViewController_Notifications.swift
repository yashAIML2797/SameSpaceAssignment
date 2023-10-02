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
        moveToNextSong()
    }
}
