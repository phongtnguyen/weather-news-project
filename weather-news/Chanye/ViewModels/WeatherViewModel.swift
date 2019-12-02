//
//  WeatherViewModel.swift
//  weather-news
//
//  Created by Chanye Jung on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherListViewModel{
    let weatherVM: [WeatherViewModel]
}

extension WeatherListViewModel {
    init(_ weatherList: [Weather]) {
        self.weatherVM = weatherList.compactMap(WeatherViewModel.init)
    }
}

extension WeatherListViewModel {
    func weatherAt(_ index: Int) -> WeatherViewModel {
        return self.weatherVM[index]
    }
}

struct WeatherViewModel {
    
    let weather: Weather
    
    init(_ weather: Weather) {
        self.weather = weather
    }
}

extension WeatherViewModel {
    var currentWeather: Observable<String> {
        return Observable<String>.just("\(Int(weather.currentWeather))°F")
    }
    var date: Observable<String> {
        return Observable<String>.just(weather.date)
    }
    var summary: Observable<String> {
        return Observable<String>.just(weather.summary)
    }
    var tempHigh: Observable<String> {
        return Observable<String>.just("\(Int(weather.temperatureHigh))°F")
    }
    var tempLow: Observable<String> {
        return Observable<String>.just("\(Int(weather.temperatureLow))°F")
    }
    var time: Observable<String> {
        return Observable<String>.just(weather.time)
    }
    var timezone: Observable<String> {
        return Observable<String>.just(weather.timezone)
    }
}

