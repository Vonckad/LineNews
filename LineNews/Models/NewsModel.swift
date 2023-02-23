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

struct ArticlesNews: Decodable, Equatable {
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
    var url: String?
    var imageData: Data? // for CoreData
    var isLiked: Bool?   // for CoreData
}
