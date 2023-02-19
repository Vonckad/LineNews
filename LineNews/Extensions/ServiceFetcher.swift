//
//  ServiceFetcher.swift
//  LineNews
//
//  Created by Vlad Ralovich on 19.02.2023.
//

import Foundation

protocol ServiceFetcherProtocol {
    func fetchSpaceRokets(complition: @escaping (NewsModel?) -> Void)
}

class ServiceFetcher: ServiceFetcherProtocol {

    var service: ServiceProtocol = Service()
    
    func fetchSpaceRokets(complition: @escaping (NewsModel?) -> Void) {
        service.requestNews() { data, error in
            if let error = error {
                print("error request = \(error.localizedDescription )")
                complition(nil) //можно подумать передать ошибку дальше
            }
            let decod = self.decodJSON(type: NewsModel.self, from: data)
            complition(decod)
        }
    }

    private func decodJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch let jsonError {
            print("jsonError = \(jsonError)")
            return nil
        }
    }
}
