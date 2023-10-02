//
//  TabViewController_LaunchPlayer.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import UIKit

extension TabViewController: LaunchPlayerDelegate {
    
    func loadMinimizedPlayer(with songs: [Song], startingAt song: Song) {
        if isShowingMinimizedPlayer {
            minimizedPlayer.songs = songs
            minimizedPlayer.currentPlayingSong = song
        } else {
            view.addSubview(minimizedPlayer)
            minimizedPlayer.anchor(
                leading:    view.leadingAnchor,
                trailing:   view.trailingAnchor,
                bottom:     tabView.topAnchor,
                height:     64
            )
            minimizedPlayer.launchPlayerDelegate = self
            tabView.removeMask()
            isShowingMinimizedPlayer = true
            
            minimizedPlayer.songs = songs
            minimizedPlayer.currentPlayingSong = song
        }
    }
    
    func loadPlayer(with songs: [Song], startingAt song: Song) {
        
        let playerController = PlayerViewController()
        playerController.minimizedPlayerDelgate = self
        playerController.songs = songs
        playerController.currentPlayingSong = song
        
        playerController.modalPresentationStyle = .custom
        present(playerController, animated: true)
    }
}
