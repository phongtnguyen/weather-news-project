//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 3/7/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

extension Horoscope {
    
    static var empty: Horoscope {
        return Horoscope(date: "", horoscope: "")
    }
    
}

struct Horoscope: Codable {
    let date: String
    let horoscope: String
}
