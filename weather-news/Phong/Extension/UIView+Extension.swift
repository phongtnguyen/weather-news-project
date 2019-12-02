//
//  UIView+Extension.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/27/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel

extension UIView {
    
    func threeSidesConstraintWithHeight(yAnchor: NSLayoutYAxisAnchor, yConstant: CGFloat, toYAnchor: NSLayoutYAxisAnchor, leftAnchor: NSLayoutXAxisAnchor, leftConstant: CGFloat, rightAnchor: NSLayoutXAxisAnchor, rightConstant: CGFloat, heightConstant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: toYAnchor, constant: yConstant).isActive = true
        self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant).isActive = true
        self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant).isActive = true
        self.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
    }
    
    func fourSidesConstraint(topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat, bottomAnchor: NSLayoutYAxisAnchor, bottomConstant: CGFloat, leftAnchor: NSLayoutXAxisAnchor, leftConstant: CGFloat, rightAnchor: NSLayoutXAxisAnchor, rightConstant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant).isActive = true
        self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant).isActive = true
        self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant).isActive = true
    }
    
    func addToViewWithConstraints(top: NSLayoutYAxisAnchor, topConstant: CGFloat, bottom: NSLayoutYAxisAnchor, bottomConstant: CGFloat, leading: NSLayoutXAxisAnchor, leadingConstant: CGFloat, trailing: NSLayoutXAxisAnchor, trailingConstant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant).isActive = true
    }
    
    func addConstraintsWithWidthEqualHeight(yAnchor: NSLayoutYAxisAnchor, by yConstant: CGFloat, to viewYAnchor: NSLayoutYAxisAnchor, xAnchor: NSLayoutXAxisAnchor, by xConstant: CGFloat, to viewXAnchor: NSLayoutXAxisAnchor, size: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: viewYAnchor, constant: yConstant).isActive = true
        xAnchor.constraint(equalTo: viewXAnchor, constant: xConstant).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    func addConstraintsWithKnownSize(yAnchor: NSLayoutYAxisAnchor, by yConstant: CGFloat, to viewYAnchor: NSLayoutYAxisAnchor, xAnchor: NSLayoutXAxisAnchor, by xConstant: CGFloat, to viewXAnchor: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: viewYAnchor, constant: yConstant).isActive = true
        xAnchor.constraint(equalTo: viewXAnchor, constant: xConstant).isActive = true
    }
    
    func addConstraintsWithSize(yAnchor: NSLayoutYAxisAnchor, by yConstant: CGFloat, to viewYAnchor: NSLayoutYAxisAnchor, xAnchor: NSLayoutXAxisAnchor, by xConstant: CGFloat, to viewXAnchor: NSLayoutXAxisAnchor, height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: viewYAnchor, constant: yConstant).isActive = true
        xAnchor.constraint(equalTo: viewXAnchor, constant: xConstant).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addConstraintsWithKnownHeight(top: NSLayoutYAxisAnchor, topConstant: CGFloat, trailing: NSLayoutXAxisAnchor, trailingConstant: CGFloat, leading: NSLayoutXAxisAnchor, leadingConstant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
    }
    
    func animateViewWithSpringEffect(duration: TimeInterval, delay: TimeInterval, springSize: CGFloat) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn,    animations: {
            self.transform = CGAffineTransform(scaleX: springSize, y: springSize)
        }) { [weak self] (_) in
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    func setBlurBackground(_ style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
}
