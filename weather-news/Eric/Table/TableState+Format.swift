//
//  TableState+Format.swift
//  weather-news
//
//  Created by Eric Cha on 11/29/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import EmptyStateKit

extension TableState {
    
    var format: EmptyStateFormat {
        switch self {
        case .noInternet:
            
            var format = EmptyStateFormat()
            format.buttonColor = "44CCD6".hexColor
            format.position = EmptyStatePosition(view: .bottom, text: .left, image: .top)
            format.verticalMargin = 40
            format.horizontalMargin = 40
            format.imageSize = CGSize(width: 320, height: 200)
            format.buttonShadowRadius = 10
            format.gradientColor = ("3854A5".hexColor, "2A1A6C".hexColor)
            format.titleAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 26)!, .foregroundColor: UIColor.white]
            format.descriptionAttributes = [.font: UIFont(name: "Avenir Next", size: 14)!, .foregroundColor: UIColor.white]
            return format
        }
    }
}
