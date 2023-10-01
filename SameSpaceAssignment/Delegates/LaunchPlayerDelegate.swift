//
//  LaunchPlayerDelegate.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 01/10/23.
//

import Foundation

protocol LaunchPlayerDelegate: NSObject {
    func launchPlayer(with songs: [Song], startingSong: Song)
}
