//
//  PlayerViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

class PlayerViewController: UIViewController {
    weak var minimizedPlayerDelgate: MinimizedPlayerDelgate?
    var currentPlayingSong: Song? {
        didSet {
            if let song = currentPlayingSong {
                configure(with: song)
            }
        }
    }
    var songs: [Song] = []
    var swipeDownToCloseGesture: UIPanGestureRecognizer!
    
    var didLaunch = false
    
    let coverFlowView: UICollectionView = {
        let layout = CoverFlowViewLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
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
        view.progress = 0.0
        view.tintColor = .lightGray
        return view
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "-:--"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let overallTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "-:--"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let playPauseButton: UIButton = {
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
        
        view.backgroundColor = .black
        view.layer.addSublayer(backgroundGradient)
        
        setupViews()
        setupGesture()
        setupCoverFlowView()
        
        addNotificationObserver()
        configurePlayerOnLaunch()
    }
    
    private func setupViews() {
        
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
        
        view.addSubview(playPauseButton)
        playPauseButton.anchor(
            top: progressView.bottomAnchor,
            width: 64,
            height: 64,
            inset: .init(top: 60, left: 0, bottom: 0, right: 0)
        )
        playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nextButton)
        nextButton.anchor(
            leading: playPauseButton.trailingAnchor,
            width: 44,
            height: 44,
            inset: .init(top: 0, left: 48, bottom: 0, right: 0)
        )
        nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor).isActive = true
        
        view.addSubview(previousButton)
        previousButton.anchor(
            trailing: playPauseButton.leadingAnchor,
            width: 44,
            height: 44,
            inset: .init(top: 0, left: 0, bottom: 0, right: 48)
        )
        previousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor).isActive = true
        
        playPauseButton.addTarget(self, action: #selector(handlePlayPauseButtonAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButtonAction), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(handlePreviousButtonAction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        
        //MARK: CoverFlowView
        let inset: CGFloat = (view.frame.width * 0.5) - (304 * 0.5)
        coverFlowView.contentInset.left =  inset
        coverFlowView.contentInset.right = inset
        
        if !didLaunch {
            if let currentSong = currentPlayingSong,
               let index = songs.firstIndex(where: {$0.id == currentSong.id}),
               let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout
            {
                coverFlowView.contentOffset.x = layout.getTargetOffsetX(for: index)
                layout.currentItemIdex = index
            }
            didLaunch = true
        }
    }
    
    deinit {
        print("deallocated")
        removeNotificationObserver()
    }
    
    func configure(with song: Song) {
        let color = UIColor(hex: song.accent)
        backgroundGradient.colors = [color.cgColor, UIColor.black.cgColor]
        
        nameLable.text = song.name
        artistLable.text = song.artist
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
