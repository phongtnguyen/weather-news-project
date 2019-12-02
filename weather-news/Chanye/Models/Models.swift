//
//  Models.swift
//  weather-news
//
//  Created by Chanye Jung on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation

struct Weather {
    let currentWeather : Double
    let timezone : String
    let date : String
    let time : String
    let summary : String
    let temperatureHigh : Double
    let temperatureLow : Double
    let humidty : Double
    let windSpeed : Double
    let precipProbability : Double
}
