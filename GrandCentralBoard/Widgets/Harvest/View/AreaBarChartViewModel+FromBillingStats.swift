//
//  AreaBarChartViewModel+FromBillingStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-15.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


extension AreaBarChartViewModel {
    static func viewModelFromBillingStats(billingStats: [DailyBillingStats]) -> AreaBarChartViewModel {
        if (billingStats.count < 1) {
            return AreaBarChartViewModel.emptyViewModel()
        }

        let mainDailyStats = billingStats.first!
        let componentDailyStats = Array(billingStats.dropFirst())

        let componentViewModels = componentDailyStats.flatMap({ dailyBillingStats in
            return AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(dailyBillingStats, isMainChart: false)
        })

        if let mainViewModel = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(mainDailyStats, isMainChart: true) {
            return AreaBarChartViewModel(mainChart: mainViewModel, componentCharts: componentViewModels, horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:".localized, centerText: nil)

        } else {
            return AreaBarChartViewModel.emptyViewModel(header: nil, subheader: nil, historicalCharts: componentViewModels)
        }
    }
}
