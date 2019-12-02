//
//  URL_URLComponents+Extension.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with param: [String: String]) {
        self.queryItems = param.map({ URLQueryItem(name: $0.key, value: $0.value) })
    }
    
}

extension URL {
    
    static func constructURL(_ searchTerm: String) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        
        let queryParams: [String: String] = [
            "media": "music",
            "entity": "song",
            "term": searchTerm
        ]
        urlComponents.setQueryItems(with: queryParams)
//        print ("Query URL =>", urlComponents.url?.absoluteString ?? "No URL")
        return urlComponents.url
        
    }
    
}
