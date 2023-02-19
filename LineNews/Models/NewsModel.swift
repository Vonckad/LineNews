//
//  NewsModel.swift
//  LineNews
//
//  Created by Vlad Ralovich on 19.02.2023.
//

import Foundation

struct NewsModel: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [ArticlesNews]
}

struct ArticlesNews: Decodable {
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
}
