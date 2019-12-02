//
//  UIImageView+Extension.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func configure(contentMode: ContentMode, borderWidth: CGFloat, borderColor: CGColor?) {
        self.clipsToBounds = true
        self.contentMode = contentMode
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
}

