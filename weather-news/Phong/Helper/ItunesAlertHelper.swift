//
//  AlertHelper.swift
//  weather-news
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit

class ItunesAlertHelper {
    
    static func showAlertWithDefaultAction(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, defaultActionButtonTitle: "Ok", tintColor: nil)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

