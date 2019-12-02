//
//  DateFormatter+Extension.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static func formatDateFromString(_ dateString: String) -> String {
        //2018-02-28T12:00:00Z
        let getFormatter = DateFormatter()
        getFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = getFormatter.date(from: dateString)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return date != nil ? formatter.string(from: date!) : ""
    }
    
}
