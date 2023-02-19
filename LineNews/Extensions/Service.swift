//
//  Service.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import Foundation

protocol ServiceProtocol {
    func requestNews(complition: @escaping (Data?, Error?) -> ())
}

class Service: ServiceProtocol {
    
    private var apiKey = "37c1624214a74993b521bbec5364be24"
    
    func requestNews(complition: @escaping (Data?, Error?) -> ()) {
        let url = url()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        let dataTask = createDataTask(from: urlRequest, complition: complition)
        dataTask.resume()
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }

    private func url() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        components.queryItems = [URLQueryItem(name: "country", value: "ru"),
                                 URLQueryItem(name: "apiKey", value: apiKey)]
        return components.url!
    }
}

