//
//  ActivityIndicatorHelper.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ActivityIndicatorHelper {
    
    static func showIndicator(with type: NVActivityIndicatorType) {
        let activityData = ActivityData(type: type)
        if !NVActivityIndicatorPresenter.sharedInstance.isAnimating {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    static func hideIndicator() {
        if NVActivityIndicatorPresenter.sharedInstance.isAnimating {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
}
