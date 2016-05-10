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

        let billingStats = billingStats.sort { (stat1, stat2) -> Bool in
            stat1.day < stat2.day
        }
        guard let mainDailyStats = billingStats.last else {
            return AreaBarChartViewModel.emptyViewModel()
        }

        let componentDailyStats = Array(billingStats.dropLast())

        let componentViewModels = componentDailyStats.flatMap { dailyBillingStats in
            return AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(dailyBillingStats, isMainChart: false)
        }

        if let mainViewModel = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(mainDailyStats, isMainChart: true) {
            return AreaBarChartViewModel(mainChart: mainViewModel, componentCharts: componentViewModels,
                                         horizontalAxisStops: 20, centerText: nil)

        } else {
            return AreaBarChartViewModel.emptyViewModel(header: nil, subheader: nil, historicalCharts: componentViewModels)
        }
    }
}
