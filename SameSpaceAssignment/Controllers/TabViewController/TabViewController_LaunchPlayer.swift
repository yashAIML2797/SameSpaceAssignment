//
//  TabViewController_LaunchPlayer.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import UIKit

extension TabViewController: LaunchPlayerDelegate {
    func launchPlayer(with songs: [Song], startingSong: Song) {
        
        let playerController = PlayerViewController()
        playerController.minimizedPlayerDelgate = self
        playerController.songs = songs
        playerController.currentPlayingSong = startingSong
        
        playerController.modalPresentationStyle = .custom
        present(playerController, animated: true)
    }
}
