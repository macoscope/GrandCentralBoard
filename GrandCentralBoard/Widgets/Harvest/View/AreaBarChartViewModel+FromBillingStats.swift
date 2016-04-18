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
        let componentViewModels = billingStats.flatMap({ dailyBillingStats in
            return AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(dailyBillingStats)
        })

        if (componentViewModels.count < 1) {
            return AreaBarChartViewModel.emptyViewModel()
        }

        let mainViewModel = componentViewModels.first!
        let historyViewModels = Array(componentViewModels.dropFirst())

        return AreaBarChartViewModel(mainChart: mainViewModel, componentCharts: historyViewModels, horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:", centerText: nil)
    }
}
