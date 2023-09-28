//
//  SongsListTableViewCell.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class SongsListTableViewCell: UITableViewCell {
    
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
    
    let artistLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "Artist Name"
        label.textColor = .white
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(coverImageView)
        coverImageView.anchor(
            leading:     contentView.leadingAnchor,
            width:       48,
            height:      48,
            inset:       .init(top: 0, left: 12, bottom: 0, right: 0)
        )
        coverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        coverImageView.backgroundColor = .gray
        
        contentView.addSubview(stackView)
        stackView.anchor(
            leading:    coverImageView.trailingAnchor,
            trailing:   contentView.trailingAnchor,
            inset:      .init(top: 0, left: 16, bottom: 0, right: 12)
        )
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(nameLable)
        stackView.addArrangedSubview(artistLable)
    }
    
    func configure(with song: Song) {
        self.nameLable.text = song.name
        self.artistLable.text = song.artist
        APIService.shared.fetchCoverImage(for: song.cover) { image in
            DispatchQueue.main.async {
                self.coverImageView.image = image
            }
        }
    }
}
