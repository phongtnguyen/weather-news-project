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
    var stocks: [BestMatch] = []
    
    //
    // MARK: - Type Alias
    //
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([BestMatch]?, String) -> Void
    
    //
    // MARK: - Internal Methods
    //
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        // 1
        dataTask?.cancel()
        
        // 2
        if var urlComponents = URLComponents(string: "https://www.alphavantage.co/query?") {
            urlComponents.query = "function=SYMBOL_SEARCH&keywords=\(searchTerm)&apikey=\(APIKey.alphaVantageAPIKey)"
            
            // 3
            guard let url = urlComponents.url else {
                return
            }
            
            // 4
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                // 5
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.updateSearchResults(data)
                    
                    // 6
                    DispatchQueue.main.async {
                        completion(self?.stocks, self?.errorMessage ?? "")
                    }
                }
            }
            
            // 7
            dataTask?.resume()
        }
    }
    
    //
    // MARK: - Private Methods
    //
    private func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        stocks.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["bestMatches"] as? [Any] else {
            errorMessage += "Dictionary does not contain bestMatches key\n"
            return
        }
        
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
                stocks.append(BestMatch(symbol: symbol, name: name, type: type, region: region, marketOpen: marketOpen, marketClose: marketClose, timezone: timezone, currency: currency, matchScore: matchScore))
                index += 1
            } else {
                errorMessage += "Problem parsing stockkDictionary\n"
            }
        }
    }
}


