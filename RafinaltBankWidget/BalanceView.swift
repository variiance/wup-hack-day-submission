//
//  BalanceView.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import SwiftUI

struct BalanceView: View {
    
    let balanceViewModel: BalanceViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text(String(balanceViewModel.balance))
                .font(.title)
                .foregroundColor(healthColor(from: balanceViewModel.health))
            
            Text(balanceViewModel.message)
                .font(.subheadline)
        }
    }
    
    private func healthColor(from health: Double) -> Color {
        switch health {
        case 0..<0.33:
            return .red
        case 0.33..<0.66:
            return .yellow
        default:
            return .green
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    
    static var previews: some View {
        BalanceView(balanceViewModel: .init(balance: 123, message: "Tele vagy!!4", health: 0.1))
    }
}
