//
//  UILabel+Extension.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func configure(font: UIFont, textColor: UIColor, alignment: NSTextAlignment) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
    
}
