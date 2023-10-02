//
//  MinimizedPlayerDelgate.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import Foundation

protocol MinimizedPlayerDelgate: NSObject {
    func loadMinimizedPlayer(with songs: [Song], startingAt song: Song)
}
