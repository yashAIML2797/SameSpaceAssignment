//
//  PlayerViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

class PlayerViewController: UIViewController {
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var coverFlowController: CoverFlowViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverFlowController = CoverFlowViewController()
        let coverFlowView = coverFlowController.view!
        
        view.addSubview(coverFlowView)
        addChild(coverFlowController)
        coverFlowController.didMove(toParent: self)
        
        coverFlowView.anchor(
            top:        view.safeAreaLayoutGuide.topAnchor,
            leading:    view.leadingAnchor,
            trailing:   view.trailingAnchor,
            height:     304,
            inset:      .init(top: 93, left: 0, bottom: 0, right: 0)
        )
        
        view.addSubview(line)
        line.anchor(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            width: 1
        )
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
