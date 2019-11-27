//
//  ViewController.swift
//  weather-news
//
//  Created by Phong Nguyen on 11/27/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "key", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path)
            print (keys)
        } else {
            print ("No file")
        }
    }


}

