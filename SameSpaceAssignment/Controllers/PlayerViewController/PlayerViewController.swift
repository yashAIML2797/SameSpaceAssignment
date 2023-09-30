//
//  PlayerViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

protocol PlayerViewControllerDelegate: NSObject {
    var songs: [Song] {get set}
    
    func launchPlayer(with song: Song)
}

class PlayerViewController: UIViewController {
    
    var coverFlowController: CoverFlowViewController!
    weak var delegate: PlayerViewControllerDelegate?
    var currentPlayingSong: Song?
    var swipeDownToCloseGesture: UIPanGestureRecognizer!
    
    let nameLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Song Name"
        label.textColor = .white
        return label
    }()
    
    let artistLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Artist Name"
        label.textColor = .lightGray
        return label
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.progress = 0.5
        view.tintColor = .lightGray
        return view
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2:04"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let overallTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "4:12"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        button.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.configuration = config
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    let previousButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.configuration = config
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    var backgroundGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.lightGray.cgColor, UIColor.black.cgColor]
        layer.startPoint = .init(x: 0.5, y: 0)
        layer.endPoint = .init(x: 0.5, y: 1)
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        view.backgroundColor = .black
        view.layer.addSublayer(backgroundGradient)
        
        coverFlowController = CoverFlowViewController()
        let coverFlowView = coverFlowController.view!
        
        view.addSubview(coverFlowView)
        addChild(coverFlowController)
        coverFlowController.didMove(toParent: self)
        
        coverFlowView.anchor(
            top:        view.topAnchor,
            leading:    view.leadingAnchor,
            trailing:   view.trailingAnchor,
            height:     304,
            inset:      .init(top: 146, left: 0, bottom: 0, right: 0)
        )
        
        view.addSubview(nameLable)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        nameLable.topAnchor.constraint(equalTo: coverFlowView.bottomAnchor, constant: 57).isActive = true
        nameLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(artistLable)
        artistLable.translatesAutoresizingMaskIntoConstraints = false
        artistLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor).isActive = true
        artistLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(progressView)
        progressView.anchor(
            top: artistLable.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            inset: .init(top: 56, left: 20, bottom: 0, right: 20)
        )
        
        view.addSubview(currentTimeLabel)
        currentTimeLabel.anchor(
            top: progressView.bottomAnchor,
            leading: view.leadingAnchor,
            inset: .init(top: 12, left: 20, bottom: 0, right: 0)
        )
        
        view.addSubview(overallTimeLabel)
        overallTimeLabel.anchor(
            top: progressView.bottomAnchor,
            trailing: view.trailingAnchor,
            inset: .init(top: 12, left: 0, bottom: 0, right: 20)
        )
        
        view.addSubview(playButton)
        playButton.anchor(
            top: progressView.bottomAnchor,
            width: 64,
            height: 64,
            inset: .init(top: 60, left: 0, bottom: 0, right: 0)
        )
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nextButton)
        nextButton.anchor(
            leading: playButton.trailingAnchor,
            width: 44,
            height: 44,
            inset: .init(top: 0, left: 48, bottom: 0, right: 0)
        )
        nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        
        view.addSubview(previousButton)
        previousButton.anchor(
            trailing: playButton.leadingAnchor,
//            width: 44,
//            height: 44,
            inset: .init(top: 0, left: 0, bottom: 0, right: 48)
        )
        previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        
        playButton.addTarget(self, action: #selector(handlePlayButtonAction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    func configure(with song: Song) {
        let color = UIColor(hex: song.accent)
        backgroundGradient.colors = [color.cgColor, UIColor.black.cgColor]
        
        nameLable.text = song.name
        artistLable.text = song.artist
    }
    
    @objc func handlePlayButtonAction(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
