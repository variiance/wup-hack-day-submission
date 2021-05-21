//
//  BalanceViewModelBuilder.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import Foundation

struct BalanceViewModelBuilder {
    
    private enum Constants {
        static let minBalance = 0
        static let maxBalance = 100_000
    }
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "HU_hu")
        
        return formatter
    }()
    
    func build(using response: BalanceResponse) -> BalanceViewModel {
        let balance = response.random.data[0]
        let formattedBalance = currencyFormatter.string(from: balance as NSNumber)!
        let health = financialHealth(from: balance)
        let message = message(using: health)
        
        return .init(balance: formattedBalance, message: message, health: health)
    }
}

private extension BalanceViewModelBuilder {
    
    func financialHealth(from balance: Int) -> FinancialHealth {
        switch balance {
        case 0..<33333:
            return .broke
        case 33333..<66666:
            return .ok
        default:
            return .drowningInMoney
        }
    }
    
    func message(using health: FinancialHealth) -> String {
        switch health {
        case .broke:
            return "Le vagy égve 😕"
        case .ok:
            return "Talán kihúzod fizuig"
        case .drowningInMoney:
            return "Tele vagy tesa!!4"
        }
    }
}
