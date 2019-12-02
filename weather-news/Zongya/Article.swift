//
//  Article.swift
//  NewsAppMVVM
//
//  Created by Mohammad Azam on 3/13/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
}

struct Article: Codable {
    var title: String
    var description: String?
    var imageURL: String?
    var content: String?
    var url: String?
}

