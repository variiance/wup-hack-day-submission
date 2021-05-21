//
//  BalanceView.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import SwiftUI
import WidgetKit

struct BalanceView: View {
    
    let balanceViewModel: BalanceViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                
                Text(balanceViewModel.balance)
            }
            .font(.title3)
            .foregroundColor(healthColor(from: balanceViewModel.health))
            
            Text(balanceViewModel.message)
                .font(.subheadline)
        }
    }
    
    private func healthColor(from health: FinancialHealth) -> Color {
        switch health {
        case .broke:
            return .red
        case .ok:
            return .yellow
        case .drowningInMoney:
            return .green
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    
    static var previews: some View {
        BalanceView(balanceViewModel: .init(balance: "123 HUF",
                                            message: "Tele vagy!!4",
                                            health: .drowningInMoney))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
