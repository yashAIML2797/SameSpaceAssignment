//
//  TabViewDelegate.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import Foundation

protocol TabViewDelegate: NSObject {
    var isShowingSecondViewController: Bool {get set}
    func switchViewController()
}
