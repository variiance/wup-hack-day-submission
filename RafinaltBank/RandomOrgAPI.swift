//
//  RandomOrgAPI.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import Foundation
import Combine

enum RandomOrgAPI {
    
    static let agent = BalanceDataSource()
    
    private enum Constants {
        static let base = "api.random.org"
        static let apiVersion = 2
        static let minBalance = 0
        static let maxBalance = 100_000
    }
}

extension RandomOrgAPI {
        
    static func randomBalance(minValue: Int, maxValue: Int) -> AnyPublisher<[BalanceResponse], Error> {
        return fetch(randomNumberRequest(minvalue: minValue, maxValue: maxValue))
    }
    
    static func randomNumberRequest(minvalue: Int, maxValue: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.base
        urlComponents.path = "json-rpc/\(Constants.apiVersion)/invoke/generateIntegers"
        urlComponents.queryItems = [
            URLQueryItem(name: "num", value: "1"),
            URLQueryItem(name: "min", value: String(Constants.minBalance)),
            URLQueryItem(name: "max", value: String(Constants.maxBalance))
        ]
        
        return .init(url: urlComponents.url!)
    }
    
    static func fetch<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.fetch(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
