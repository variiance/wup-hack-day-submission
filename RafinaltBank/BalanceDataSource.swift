//
//  BalanceDataSource.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import Foundation
import Combine

final class BalanceDataSource {
    
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func fetch<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct BalanceResponse: Codable {
    let random: Results
}

struct Results: Codable {
    let data: [Int]
}

enum FinancialHealth {
    case broke
    case ok
    case drowningInMoney
}

struct BalanceViewModel {
    let balance: String
    let message: String
    let health: FinancialHealth
}
