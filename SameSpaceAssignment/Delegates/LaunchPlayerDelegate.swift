//
//  LaunchPlayerDelegate.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import Foundation

protocol LaunchPlayerDelegate: NSObject {
    var isShowingMinimizedPlayer: Bool {set get}
    func launchPlayer(with songs: [Song], startingSong: Song)
    func addMinimizedPlayer(songs: [Song], for song: Song)
}
