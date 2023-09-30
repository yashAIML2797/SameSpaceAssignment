//
//  PlayerViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit
import AVFoundation

protocol PlayerViewControllerDelegate: NSObject {
    var songs: [Song] {get set}
    
    func launchPlayer(with song: Song)
}

class PlayerViewController: UIViewController {
    
    var coverFlowController: CoverFlowViewController!
    weak var delegate: PlayerViewControllerDelegate? {
        didSet {
            self.songs = delegate?.songs ?? []
        }
    }
    var currentPlayingSong: Song?
    var songs: [Song] = []
    var swipeDownToCloseGesture: UIPanGestureRecognizer!
    var avPlayer: AVQueuePlayer?
    var timeObserver: Any?
    
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
        label.text = "-:-"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let overallTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "-:-"
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
            width: 44,
            height: 44,
            inset: .init(top: 0, left: 0, bottom: 0, right: 48)
        )
        previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        
        playButton.addTarget(self, action: #selector(handlePlayButtonAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButtonAction), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(handlePreviousButtonAction), for: .touchUpInside)
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
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        
        if avPlayer?.timeControlStatus == .playing {
            avPlayer?.pause()
            playButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        } else {
            avPlayer?.play()
            playButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        }
    }
    
    @objc func handleNextButtonAction(sender: UIButton) {
        if let layout = coverFlowController.collectionView.collectionViewLayout as? CoverFlowViewLayout {
            if layout.currentItemIdex < (songs.count - 1) {
                layout.currentItemIdex += 1
            } else {
                layout.currentItemIdex = songs.count - 1
            }
            let offsetX = layout.getTargetOffsetX(for: layout.currentItemIdex)
            self.coverFlowController.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            let song = songs[layout.currentItemIdex]
            self.currentPlayingSong = song
            self.configure(with: song)
        }
        
        play()
    }
    
    @objc func handlePreviousButtonAction(sender: UIButton) {
        
        guard (avPlayer?.currentTime().seconds ?? 0) <= 3 else {
            avPlayer?.pause()
            avPlayer?.seek(to: .zero)
            avPlayer?.play()
            return
        }
        
        if let layout = coverFlowController.collectionView.collectionViewLayout as? CoverFlowViewLayout {
            if layout.currentItemIdex > 0 {
                layout.currentItemIdex -= 1
            } else {
                layout.currentItemIdex = 0
            }
            
            let offsetX = layout.getTargetOffsetX(for: layout.currentItemIdex)
            self.coverFlowController.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            let song = songs[layout.currentItemIdex]
            self.currentPlayingSong = song
            self.configure(with: song)
        }
        
        play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
    
    func start() {
        if let song = currentPlayingSong {
            if let url = URL(string: song.url) {
                let item = AVPlayerItem(url: url)
                avPlayer = AVQueuePlayer(playerItem: item)
                avPlayer?.play()

                Task {
                    let duration = try await item.asset.load(.duration)
                    let config = UIImage.SymbolConfiguration(pointSize: 64)
                    playButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)

                    let minutes = duration.seconds / 60
                    let seconds = duration.seconds.truncatingRemainder(dividingBy: 60)
                    
                    let timeformatter = NumberFormatter()
                    timeformatter.minimumIntegerDigits = 2
                    timeformatter.minimumFractionDigits = 0
                    timeformatter.roundingMode = .down

                    if let minStr = timeformatter.string(from: NSNumber(value: minutes)),
                       let secStr = timeformatter.string(from: NSNumber(value: seconds)) {
                        self.currentTimeLabel.text = "00:00"
                        self.overallTimeLabel.text = "\(minStr):\(secStr)"
                    }
                    
                    timeObserver = avPlayer?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
                        print(time.seconds)
                        let progress = time.seconds / duration.seconds
                        self.progressView.progress = Float(progress)
                        
                        let minutes = time.seconds / 60
                        let seconds = time.seconds.truncatingRemainder(dividingBy: 60)
                        
                        if let minStr = timeformatter.string(from: NSNumber(value: minutes)),
                           let secStr = timeformatter.string(from: NSNumber(value: seconds)) {
                            self.currentTimeLabel.text = "\(minStr):\(secStr)"
                        }
                    })
                }
            }
        }
    }
    
    func play() {
        let config = UIImage.SymbolConfiguration(pointSize: 64)
        currentTimeLabel.text = "-:--"
        overallTimeLabel.text = "-:--"
        progressView.progress = 0.0

        playButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        avPlayer?.pause()
        avPlayer?.removeAllItems()
        if let observer = timeObserver {
            avPlayer?.removeTimeObserver(observer)
        }
        avPlayer = nil
        
        
        if let song = currentPlayingSong {
            if let url = URL(string: song.url) {
                let item = AVPlayerItem(url: url)
                avPlayer = AVQueuePlayer(playerItem: item)
                avPlayer?.play()

                Task {
                    let duration = try await item.asset.load(.duration)
                    let config = UIImage.SymbolConfiguration(pointSize: 64)
                    playButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)

                    let minutes = duration.seconds / 60
                    let seconds = duration.seconds.truncatingRemainder(dividingBy: 60)
                    
                    let timeformatter = NumberFormatter()
                    timeformatter.minimumIntegerDigits = 2
                    timeformatter.minimumFractionDigits = 0
                    timeformatter.roundingMode = .down

                    if let minStr = timeformatter.string(from: NSNumber(value: minutes)),
                       let secStr = timeformatter.string(from: NSNumber(value: seconds)) {
                        self.currentTimeLabel.text = "00:00"
                        self.overallTimeLabel.text = "\(minStr):\(secStr)"
                    }
                    
                    timeObserver = avPlayer?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
                        print(time.seconds)
                        let progress = time.seconds / duration.seconds
                        self.progressView.progress = Float(progress)
                        
                        let minutes = time.seconds / 60
                        let seconds = time.seconds.truncatingRemainder(dividingBy: 60)
                        
                        if let minStr = timeformatter.string(from: NSNumber(value: minutes)),
                           let secStr = timeformatter.string(from: NSNumber(value: seconds)) {
                            self.currentTimeLabel.text = "\(minStr):\(secStr)"
                        }
                    })
                }
            }
        }
    }
}
