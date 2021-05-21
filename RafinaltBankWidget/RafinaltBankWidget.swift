//
//  RafinaltBankWidget.swift
//  RafinaltBankWidget
//
//  Created by Pável Miklós on 2021. 05. 21..
//

import Combine
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    
    @AppStorage(wrappedValue: 0,
                Keys.balance,
                store: UserDefaults(suiteName: "group.hu.pavel.RafinaltBank"))
    var balance: Int
    
    func placeholder(in context: Context) -> BalanceEntry {
        BalanceEntry(date: Date(),
                     balanceViewModel: .init(balance: "123 HUF",
                                             message: "Tele vagy!!4",
                                             health: .drowningInMoney))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BalanceEntry) -> ()) {
        let entry = BalanceEntry(date: Date(),
                                 balanceViewModel: .init(balance: "123 HUF",
                                                         message: "Tele vagy!!4",
                                                         health: .drowningInMoney))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let min = BalanceViewModelBuilder.Constants.minBalance
        let max = BalanceViewModelBuilder.Constants.maxBalance
        let balance = Int.random(in: min..<max)
        let viewModel = BalanceViewModelBuilder().build(using: balance)
        let entry = BalanceEntry(date: Date(), balanceViewModel: viewModel)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct BalanceEntry: TimelineEntry {
    let date: Date
    let balanceViewModel: BalanceViewModel
}

struct RafinaltBankWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        BalanceView(balanceViewModel: entry.balanceViewModel)
    }
}

@main
struct RafinaltBankWidget: Widget {
    let kind: String = "RafinaltBankWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RafinaltBankWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Balance widget")
        .description("Megmondja mennyi pénzed van.")
        .supportedFamilies([.systemSmall])
    }
}

struct RafinaltBankWidget_Previews: PreviewProvider {
    static var previews: some View {
        RafinaltBankWidgetEntryView(entry: BalanceEntry(date: Date(),
                                                        balanceViewModel: .init(balance: "123 HUF",
                                                                                message: "Tele vagy!!4",
                                                                                health: .drowningInMoney)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        RafinaltBankWidgetEntryView(entry: BalanceEntry(date: Date(),
                                                        balanceViewModel: .init(balance: "123 HUF",
                                                                                message: "Tele vagy!!4",
                                                                                health: .drowningInMoney)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .redacted(reason: .placeholder)
    }
}
