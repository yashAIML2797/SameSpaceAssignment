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
        
        let tabViewController = TabViewController()
        let tabView = tabViewController.view!
        
        view.addSubview(tabView)
        addChild(tabViewController)
        tabViewController.didMove(toParent: self)
        
        tabView.fillInSuperview()
    }


}

