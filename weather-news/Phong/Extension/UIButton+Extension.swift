//
//  UIButton+Extension.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func configure(title: String, titleColor: UIColor, tag: Int, font: UIFont, background: UIColor?) {
        setTitleForAllStates(title)
        setTitleColorForAllStates(titleColor)
        self.tag = tag
        titleLabel?.font = font
        if background == nil { backgroundColor = .clear }
        else { backgroundColor = background }
    }
    
    func configure(image: UIImage, tintColor: UIColor, contentMode: ContentMode, tag: Int) {
        self.setImage(image, for: .normal) // if for all states then no image effect
        self.tintColor = tintColor
        self.contentMode = contentMode
        self.tag = tag
    }
    
    func setTitle(title: String, titleColor: UIColor, font: UIFont) {
        setTitleForAllStates(title)
        setTitleColorForAllStates(titleColor)
        titleLabel?.font = font
    }
    
    func setImage(image: UIImage, tintColor: UIColor, contentMode: ContentMode) {
        self.setImage(image, for: .normal)
        self.tintColor = tintColor
        self.contentMode = contentMode
    }
    
}
