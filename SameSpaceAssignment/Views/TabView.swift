//
//  TabView.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

protocol TabViewDelegate: NSObject {
    var isShowingSecondViewController: Bool {get set}
    func switchViewController()
}

class TabView: UIView {
    
    weak var delegate: TabViewDelegate?
    
    let forYouButton: TabViewButton = {
        let label = TabViewButton()
        label.textLabel.text = "For You"
        return label
    }()
    
    let topTracksButton: TabViewButton = {
        let label = TabViewButton()
        label.textLabel.text = "Top Tracks"
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    let gradientMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let gradientMaskLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.25).cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.black.cgColor
        ]
        layer.startPoint = .init(x: 0.5, y: 0)
        layer.endPoint = .init(x: 0.5, y: 1)
        layer.locations = [0, 0.0625, 0.125, 0.25]
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientMaskLayer.frame = gradientMaskView.bounds
    }
    
    private func setupViews() {
        addSubview(gradientMaskView)
        gradientMaskView.fillInSuperview()
        gradientMaskView.layer.mask = gradientMaskLayer
        
        addSubview(stackView)
        stackView.anchor(
            bottom:     safeAreaLayoutGuide.bottomAnchor,
            width:      280,
            height:     38,
            inset:      .init(top: 0, left: 0, bottom: 18, right: 0)
        )
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stackView.addArrangedSubview(forYouButton)
        stackView.addArrangedSubview(topTracksButton)
        stackView.distribution = .fillEqually
        
        topTracksButton.deselectButton()
        
        forYouButton.addTarget(self, action: #selector(handleforYouButtonAction), for: .touchUpInside)
        topTracksButton.addTarget(self, action: #selector(handletopTracksButtonAction), for: .touchUpInside)
    }
    
    @objc func handleforYouButtonAction(sender: UIButton) {
        if let isShowingSecondViewController = delegate?.isShowingSecondViewController {
            if isShowingSecondViewController {
                delegate?.switchViewController()
            }
        }
    }
    
    @objc func handletopTracksButtonAction(sender: UIButton) {
        if let isShowingSecondViewController = delegate?.isShowingSecondViewController {
            if !isShowingSecondViewController {
                delegate?.switchViewController()
            }
        }
    }
    
    func switchButtonStates() {
        if let isShowingSecondViewController = delegate?.isShowingSecondViewController {
            if isShowingSecondViewController {
                topTracksButton.selectButton()
                forYouButton.deselectButton()
            } else {
                forYouButton.selectButton()
                topTracksButton.deselectButton()
            }
        }
    }
    
    func removeMask() {
        gradientMaskView.layer.mask = nil
    }
}
