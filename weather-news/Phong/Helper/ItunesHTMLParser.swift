//
//  ItunesHTMLParser.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import SwiftSoup

class ItunesHTMLParser {
    
    class func parseHTMLFromDataForURL(_ data: Data) -> URL? {
        
        guard let htmlString = String(data: data, encoding: .utf8) else { print ("Cannot convert data to html string"); return nil }
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let elements = try doc.select("[class=we-artwork__source]")
            if let first = elements.first() {
                let urlStringSet = try first.attr("srcset")
                let urlStrings = urlStringSet.components(separatedBy: [",", " "])
                if let urlString = urlStrings.first {
                    return URL(string: urlString)
                }
            }
        } catch Exception.Error(let type, let message) {
            print(type, " ==== ", message)
        } catch let error {
            print("\(error.localizedDescription)")
        }
        return nil
        
    }
    
}
