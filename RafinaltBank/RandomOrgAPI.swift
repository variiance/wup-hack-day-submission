//
//  RandomOrgAPI.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import Foundation
import Combine

enum RandomOrgAPI {
    
    private static let agent = BalanceDataSource()
    private static let encoder = JSONEncoder()
    
    private enum Constants {
        static let base = "api.random.org"
        static let apiVersion = 2
        static let minBalance = 0
        static let maxBalance = 50
    }
}

extension RandomOrgAPI {
    
    static func fetchRandomBalance(completion: @escaping (BalanceViewModel?, Error?) -> Void) {
        URLSession.shared.dataTask(with: randomNumberRequest()) { data, response, error in
            if let data = data {
                let balanceResponse = try! JSONDecoder().decode(BalanceResponse.self, from: data)
                let viewModelBuiler = BalanceViewModelBuilder()
                let balanceViewModel = viewModelBuiler.build(using: balanceResponse)
                completion(balanceViewModel, nil)
            } else {
                completion(nil, nil)
            }
        }
        .resume()
    }
    
    static func randomBalance() -> AnyPublisher<BalanceResponse, Error> {
        return fetch(randomNumberRequest())
    }
    
    static private func randomNumberRequest() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.base
        urlComponents.path = "/json-rpc/\(Constants.apiVersion)/invoke"
        
        var request = URLRequest(url: urlComponents.url!)
        let params = Params(apiKey: Keys.randomOrgApiKey,
                            n: 1,
                            min: Constants.minBalance,
                            max: Constants.maxBalance)
        let body = RequestBody(jsonrpc: "2.0",
                               method: "generateIntegers",
                               params: params,
                               id: .random(in: 0...100))
        let encodedBody = try! encoder.encode(body)
        request.httpBody = encodedBody
        
        return request
    }
    
    static private func fetch<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.fetch(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    struct RequestBody: Codable {
        let jsonrpc: String
        let method: String
        let params: Params
        let id: Int
    }
    
    struct Params: Codable {
        let apiKey: String
        let n: Int
        let min: Int
        let max: Int
    }
}
