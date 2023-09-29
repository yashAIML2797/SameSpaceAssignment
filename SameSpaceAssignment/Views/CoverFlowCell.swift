//
//  CoverFlowCell.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

class CoverFlowCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        layer.cornerRadius = 4
        
        addSubview(imageView)
        imageView.fillInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String) {
        APIService.shared.fetchCoverImage(for: imageURL) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
