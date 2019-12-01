//
//  QueryService.swift
//  StockApp
//
//  Created by Eric Cha on 11/27/19.
//  Copyright © 2019 Eric Cha. All rights reserved.
//

import Foundation

//
// MARK: - Query Service
//

/// Runs query data task, and stores results in array of Tracks
class QueryService {
    //
    // MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    
    //
    // MARK: - Variables And Properties
    //
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var stock : Stock?
    var bestMatches: [BestMatch] = []
    
    //
    // MARK: - Type Alias
    //
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([BestMatch]?, String) -> Void
    typealias StockQueryResult = (Stock?, String) -> Void
    
    //
    // MARK: - Internal Methods
    //
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://www.alphavantage.co/query?") {
            urlComponents.query = "function=SYMBOL_SEARCH&keywords=\(searchTerm)&apikey=\(APIKey.alphaVantageAPIKey)"
            
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.updateSearchResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self?.bestMatches, self?.errorMessage ?? "")
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func getStockResults(searchTerm: String, completion: @escaping StockQueryResult) {
        if var urlComponents = URLComponents(string: "https://www.alphavantage.co/query?") {
            urlComponents.query = "function=TIME_SERIES_DAILY&symbol=\(searchTerm)&apikey=\(APIKey.alphaVantageAPIKey)"
            
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.updateStockResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self?.stock, self?.errorMessage ?? "")
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    //
    // MARK: - Private Methods
    //
    private func updateStockResults(_ data: Data) {
        var response: JSONDictionary?
        stock = nil
        
        var metaData: MetaData?
        var timeSeriesDaily: [TimeSeriesDaily] = []
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let metaDataDict = response!["Meta Data"] as? JSONDictionary else { return }
        
        if let information = metaDataDict["1. Information"] as? String,
            let symbol = metaDataDict["2. Symbol"] as? String,
            let lastRefreshed = metaDataDict["3. Last Refreshed"] as? String,
            let outputSize = metaDataDict["4. Output Size"] as? String,
            let timeZone = metaDataDict["5. Time Zone"] as? String{
            metaData = MetaData(information: information, symbol: symbol, lastRefreshed: lastRefreshed, outputSize: outputSize, timeZone: timeZone)
        }
        
        guard let timeSeriesDict = response!["Time Series (Daily)"] as? Dictionary<String, JSONDictionary> else { return }
        
        for (_, stockDictionary) in timeSeriesDict{
            if
                let open = stockDictionary["1. open"] as? String,
                let high = stockDictionary["2. high"] as? String,
                let low = stockDictionary["3. low"] as? String,
                let close = stockDictionary["4. close"] as? String,
                let volume = stockDictionary["5. volume"] as? String{
                timeSeriesDaily.append(TimeSeriesDaily(open: open, high: high, low: low, close: close, volume: volume))
            } else {
                errorMessage += "Problem parsing stockDictionary\n"
            }
        }
        
        stock = Stock(companyName: "", metaData: metaData!, timeSeries: timeSeriesDaily)
    }
    
    private func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        bestMatches.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["bestMatches"] as? [Any] else { return }
        
        var index = 0
        
        for stockDictionary in array {
            if let stockDictionary = stockDictionary as? JSONDictionary,
                let symbol = stockDictionary["1. symbol"] as? String,
                let name = stockDictionary["2. name"] as? String,
                let type = stockDictionary["3. type"] as? String,
                let region = stockDictionary["4. region"] as? String,
                let marketOpen = stockDictionary["5. marketOpen"] as? String,
                let marketClose = stockDictionary["6. marketClose"] as? String,
                let timezone = stockDictionary["7. timezone"] as? String,
                let currency = stockDictionary["8. currency"] as? String,
                let matchScore = stockDictionary["9. matchScore"] as? String{
                bestMatches.append(BestMatch(symbol: symbol, name: name, type: type, region: region, marketOpen: marketOpen, marketClose: marketClose, timezone: timezone, currency: currency, matchScore: matchScore))
                index += 1
            } else {
                errorMessage += "Problem parsing stockkDictionary\n"
            }
        }
    }
    
    
}


