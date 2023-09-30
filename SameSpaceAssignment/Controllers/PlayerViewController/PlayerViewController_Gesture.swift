//
//  PlayerViewController_Gesture.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 30/09/23.
//

import UIKit

extension PlayerViewController: UIGestureRecognizerDelegate {
    func setupGesture() {
        swipeDownToCloseGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        swipeDownToCloseGesture.delegate = self
        swipeDownToCloseGesture.name = "swipeDownToClose"
        view.addGestureRecognizer(swipeDownToCloseGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let velocity = gesture.velocity(in: gesture.view)
        
        switch gesture.state {
        case .began, .changed:
            let translationY = max(0, translation.y)
            view.transform = CGAffineTransform(translationX: 0, y: translationY)
            backgroundGradient.cornerRadius = 15
        case .ended, .cancelled:
            if (velocity.y / 1000) > 0.5 || translation.y > view.frame.height * 0.25 {
                if let observer = timeObserver {
                    self.avPlayer?.removeTimeObserver(observer)
                    self.timeObserver = nil
                }
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction]) {
                    self.view.transform = .identity
                    self.backgroundGradient.cornerRadius = .zero
                }
            }
        default:
            break
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.name == "swipeDownToClose" {
            if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = gesture.velocity(in: gesture.view)
                
                return abs(velocity.y) > abs(velocity.x) && velocity.y > 0
            }
        }
        
        return true
    }
}
