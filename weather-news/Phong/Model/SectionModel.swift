//
//  SectionModel.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import RxDataSources
import MediaPlayer

enum SectionModel {
    case Title(items: [MPMediaItem])
    case Artist(items: [MPMediaItem])
    case Related(items: [MPMediaItem])
    
    var sectionTitle: String {
        switch self {
        case .Title(items: _):
            return "\(self.items.count) songs with matching title "
        case .Artist(items: _):
            return "\(self.items.count) songs from the same artist"
        case .Related(items: _):
            return "Songs that might be related"
        }
        
    }
}

extension SectionModel: SectionModelType {
    typealias Item = MPMediaItem
     
    var items: [MPMediaItem] {
        switch self {
        case .Title(items: let items):
            return items.map {$0}
        case .Artist(items: let items):
            return items.map {$0}
        case .Related(items: let items):
            return items.map {$0}
        }
    }
    
    init(original: SectionModel, items: [Item]) {
        switch original {
        case .Title(items: _):
            self = .Title(items: items)
        case .Artist(items: _):
            self = .Artist(items: items)
        case .Related(items: _):
            self = .Related(items: items)
        }
    }
}
