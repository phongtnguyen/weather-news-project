//
//  URL+Extensions.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 3/9/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

extension URL {
    
    static func urlForHoroscope(sign : String) -> URL? {
        return URL(string: "http://horoscope-api.herokuapp.com/horoscope/today/\(sign)")
    }
}
