//
//  ContentView.swift
//  RafinaltBank
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import Combine
import SwiftUI
import WidgetKit

struct ContentView: View {
    
    var body: some View {
        Text("Számoljuk a pénzedet...")
            .padding()
            .onAppear {
                let min = BalanceViewModelBuilder.Constants.minBalance
                let max = BalanceViewModelBuilder.Constants.maxBalance
                let balance = Int.random(in: min..<max)
                UserDefaults.standard.set(balance, forKey: Keys.balance)
                WidgetCenter.shared.reloadAllTimelines()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
