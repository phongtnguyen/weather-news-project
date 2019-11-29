//
//  Stocks.swift
//  StockApp
//
//  Created by Eric Cha on 11/27/19.
//  Copyright © 2019 Eric Cha. All rights reserved.
//

import Foundation

// MARK: - BestMatch
struct BestMatch: Codable {
    let symbol, name, type, region: String
    let marketOpen, marketClose, timezone, currency: String
    let matchScore: String

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case region = "4. region"
        case marketOpen = "5. marketOpen"
        case marketClose = "6. marketClose"
        case timezone = "7. timezone"
        case currency = "8. currency"
        case matchScore = "9. matchScore"
    }
}

// MARK: - MetaData
struct MetaData: Codable {
    let information, symbol, lastRefreshed, outputSize: String
    let timeZone: String

    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case outputSize = "4. Output Size"
        case timeZone = "5. Time Zone"
    }
}

// MARK: - TimeSeriesDaily
struct TimeSeriesDaily: Codable {
    let open, high, low, close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
