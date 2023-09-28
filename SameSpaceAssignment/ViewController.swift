//
//  ViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let songsListTableViewController = SongsListTableViewController()
        let songsListView = songsListTableViewController.view!
        
        view.addSubview(songsListView)
        addChild(songsListTableViewController)
        songsListTableViewController.didMove(toParent: self)
        
        songsListView.fillInSuperview()
    }


}

