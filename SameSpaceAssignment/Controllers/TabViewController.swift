//
//  TabViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class TabViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let songsListTableViewController = SongsListTableViewController(style: .plain)
        let songsListView = songsListTableViewController.view!
        
        view.addSubview(songsListView)
        addChild(songsListTableViewController)
        songsListTableViewController.didMove(toParent: self)
        
        songsListView.fillInSuperview()
        
        let topTracksTableViewController = TopTracksTableViewController(style: .plain)
        let topTracksView = topTracksTableViewController.view!
        
        view.addSubview(topTracksView)
        addChild(topTracksTableViewController)
        topTracksTableViewController.didMove(toParent: self)
        
        topTracksView.fillInSuperview()
        
        topTracksView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
    }
}
