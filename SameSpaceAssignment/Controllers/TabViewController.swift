//
//  TabViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class TabViewController: UIViewController {
    
    var swipeGesture: UIPanGestureRecognizer!
    var songsListView: UIView!
    var topTracksView: UIView!
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var isShowingSecondViewController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setupSwipeGesture()
    }
    
    private func setupViews() {
        let songsListTableViewController = SongsListTableViewController(style: .plain)
        let topTracksTableViewController = TopTracksTableViewController(style: .plain)
        
        songsListView = songsListTableViewController.view!
        topTracksView = topTracksTableViewController.view!
        
        view.addSubview(containerView)
        containerView.anchor(
            top:        view.topAnchor,
            leading:    view.leadingAnchor,
            bottom:     view.bottomAnchor
        )
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2).isActive = true
        
        containerView.addSubview(songsListView)
        songsListView.anchor(
            top:        containerView.topAnchor,
            leading:    containerView.leadingAnchor,
            bottom:     containerView.bottomAnchor
        )
        songsListView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        containerView.addSubview(topTracksView)
        topTracksView.anchor(
            top:        containerView.topAnchor,
            leading:    songsListView.trailingAnchor,
            trailing:   containerView.trailingAnchor,
            bottom:     containerView.bottomAnchor
        )
        
        addChild(songsListTableViewController)
        songsListTableViewController.didMove(toParent: self)
        addChild(topTracksTableViewController)
        topTracksTableViewController.didMove(toParent: self)
        
    }
}
