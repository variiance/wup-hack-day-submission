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
        urlComponents.path = "json-rpc/4/invoke/generateIntegers"
        urlComponents.queryItems = [
            //            URLQueryItem(name: "i", value: "1+2")
        ]
        
        return .init(url: urlComponents.url!)
    }
    
    static func fetch<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.fetch(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
