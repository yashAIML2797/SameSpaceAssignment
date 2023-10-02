//
//  LaunchPlayerDelegate.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import Foundation

protocol PlayerDelegate: NSObject, MinimizedPlayerDelgate {
    var isShowingMinimizedPlayer: Bool {set get}
    func loadPlayer(with songs: [Song], startingAt song: Song)
}
