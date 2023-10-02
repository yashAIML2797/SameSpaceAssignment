//
//  LaunchPlayerDelegate.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import Foundation

protocol LaunchPlayerDelegate: NSObject {
    var isShowingMinimizedPlayer: Bool {set get}
    func loadPlayer(with songs: [Song], startingAt song: Song)
    func loadMinimizedPlayer(with songs: [Song], startingAt song: Song)
}
