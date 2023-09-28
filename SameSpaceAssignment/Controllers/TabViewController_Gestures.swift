//
//  TabViewController_Gestures.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

extension TabViewController: UIGestureRecognizerDelegate {
    func setupSwipeGesture() {
        swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.name = "swipe"
        swipeGesture.delegate = self
        containerView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipe(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let velocity = gesture.velocity(in: gesture.view)
        
        switch gesture.state {
        case .began, .changed:
            applyViewTranform(for: translation.x)
        case .ended, .cancelled:
            if abs(velocity.x / 1000) > 0.5 || abs(translation.x) > view.frame.width * 0.3 {
                switchViewController()
            } else {
                restoreTranslationForCurrentViewController()
            }
        default:
            break
        }
    }
    
    private func applyViewTranform(for gestureTranslationX: CGFloat) {
        if !isShowingSecondViewController {
            let translationX = min(gestureTranslationX, 0)
            containerView.transform = CGAffineTransform(translationX: translationX, y: 0)
        } else {
            let translationX = gestureTranslationX > 0 ? (view.frame.width - gestureTranslationX) : view.frame.width
            containerView.transform = CGAffineTransform(translationX: -translationX, y: 0)
        }
    }
    
    private func restoreTranslationForCurrentViewController() {
        if isShowingSecondViewController {
            showSecondViewController()
        } else {
            showFirstViewController()
        }
    }
    
    private func switchViewController() {
        if isShowingSecondViewController {
            showFirstViewController()
        } else {
            showSecondViewController()
        }
    }
    
    private func showFirstViewController() {
        isShowingSecondViewController = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction]) {
            self.containerView.transform = .identity
        }
    }
    
    private func showSecondViewController() {
        isShowingSecondViewController = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction]) {
            self.containerView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.name == "swipe" {
            if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = gesture.velocity(in: gesture.view)
                
                if abs(velocity.x) > abs(velocity.y) {
                    if isShowingSecondViewController {
                        return velocity.x > 0
                    } else {
                        return velocity.x < 0
                    }
                } else {
                    return false
                }
            }
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        (gestureRecognizer.name == "swipe")
    }
}
