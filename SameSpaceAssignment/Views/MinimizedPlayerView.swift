//
//  MinimizedPlayerView.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 30/09/23.
//

import UIKit

protocol MinimizedPlayerDelgate: NSObject {
    func loadMinimizedPlayer(with songs: [Song], startingAt song: Song)
}

class MinimizedPlayerView: UIView {
    weak var launchPlayerDelegate: LaunchPlayerDelegate?
    
    var currentPlayingSong: Song? {
        didSet {
            if let song = currentPlayingSong {
                configure(with: song)
            }
        }
    }
    var songs: [Song] = []
    
    let coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 24
        return coverImageView
    }()
    
    let nameLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "Song Name"
        label.textColor = .white
        return label
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        button.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishCurrentTrack), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func setupViews() {
        backgroundColor = .gray
        
        addSubview(coverImageView)
        coverImageView.anchor(
            leading:     leadingAnchor,
            width:       48,
            height:      48,
            inset:       .init(top: 0, left: 16, bottom: 0, right: 0)
        )
        coverImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        coverImageView.backgroundColor = .gray
        
        addSubview(nameLable)
        nameLable.anchor(
            leading:    coverImageView.trailingAnchor,
            inset:      .init(top: 0, left: 16, bottom: 0, right: 0)
        )
        nameLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(playPauseButton)
        playPauseButton.anchor(
            trailing:    trailingAnchor,
            width:       44,
            height:      44,
            inset:      .init(top: 0, left: 0, bottom: 0, right: 16)
        )
        playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        playPauseButton.addTarget(self, action: #selector(handlePlayPauseButtonAction), for: .touchUpInside)
    }
    
    func configure(with song: Song) {
        self.nameLable.text = song.name
        let color = UIColor(hex: song.accent)
        backgroundColor = color
        
        APIService.shared.fetchCoverImage(for: song.cover) { image in
            DispatchQueue.main.async {
                self.coverImageView.image = image
            }
        }
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        if AudioManager.shared.isPaused {
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        }
    }
    
    @objc func handlePlayPauseButtonAction(sender: UIButton) {
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        
        if AudioManager.shared.isPlaying {
            AudioManager.shared.pause()
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        } else {
            AudioManager.shared.play()
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        }
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if let song = currentPlayingSong {
            launchPlayerDelegate?.loadPlayer(with: songs, startingAt: song)
        }
    }
    
    @objc func didFinishCurrentTrack(notification: Notification) {
        
        if let currentPlayingSong = currentPlayingSong,
           let currentIndex = songs.firstIndex(where: {$0.id == currentPlayingSong.id})
        {
            var nextSongIndex = currentIndex
            
            if currentIndex < (songs.count - 1) {
                nextSongIndex += 1
            } else {
                nextSongIndex = songs.count - 1
            }
            
            let nextSong = songs[nextSongIndex]
            self.currentPlayingSong = nextSong
            self.configure(with: nextSong)
            if let url = URL(string: nextSong.url) {
                AudioManager.shared.start(itemURL: url)
            }
        }
    }
}
