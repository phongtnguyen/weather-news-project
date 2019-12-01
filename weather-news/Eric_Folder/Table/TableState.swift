//
//  TableState.swift
//  weather-news
//
//  Created by Eric Cha on 11/29/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import EmptyStateKit

enum TableState: CustomState {
    
    case noInternet
    
    var image: UIImage? {
        switch self {
        case .noInternet: return UIImage(named: "Internet")
        }
    }
    
    var title: String? {
        switch self {
        case .noInternet: return "No Results"
        }
    }
    
    var description: String? {
        switch self {
        case .noInternet: return "Please search for stock symbols in the search bar"
        }
    }
    
    var titleButton: String? {
        switch self {
        case .noInternet: return "Try again?"
        }
    }
}
