//
//  UIView_Ext.swift
//  GratitudeAssignment
//
//  Created by Yash Uttekar on 18/09/23.
//

import UIKit

extension UIView {
    func fillInSuperview(inset: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = superview {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top).isActive = true
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left).isActive = true
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right).isActive = true
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom).isActive = true
        }
    }
    
    func anchor(top: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
                leading: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
                trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
                bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
                width: CGFloat? = nil, height: CGFloat? = nil, inset: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: inset.top).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: inset.left).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -inset.right).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -inset.bottom).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerInSuperview(width: CGFloat?, height: CGFloat?, inset: CGPoint = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let superview = superview {
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: inset.x).isActive = true
        }
        
        if let superview = superview {
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: inset.y).isActive = true
        }
    }
}
