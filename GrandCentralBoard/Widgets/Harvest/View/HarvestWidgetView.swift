//
//  HarvestWidgetView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBUtilities


struct HarvestWidgetViewModel {
    let lastDayChartModel: CircleChartViewModel
    let lastNDaysChartModel: CircleChartViewModel
    let numberOfLastDays: Int
}

extension HarvestWidgetViewModel {

    static func viewModelFromBillingStats(stats: [DailyBillingStats]) -> HarvestWidgetViewModel {
        //sort with timestamp descending
        let stats = stats.sort { (left, right) -> Bool in
            left.day > right.day
        }

        guard let lastDayStats = stats.first else {
            let emptyCircleChartViewModel = CircleChartViewModel(startAngle: 0, items: [])
            return HarvestWidgetViewModel(lastDayChartModel: emptyCircleChartViewModel,
                                          lastNDaysChartModel: emptyCircleChartViewModel,
                                          numberOfLastDays: stats.count)
        }

        let lastDayChartViewModel = CircleChartViewModel.chartItemFromBillingStats(lastDayStats)
        let lastNDaysChartViewModel = CircleChartViewModel.chartItemFromMultipleBillingStats(stats)
        return HarvestWidgetViewModel(lastDayChartModel: lastDayChartViewModel,
                                      lastNDaysChartModel: lastNDaysChartViewModel,
                                      numberOfLastDays: stats.count)
    }
}

final class HarvestWidgetView: UIView {

    @IBOutlet private weak var lastDayCircleChart: CircleChart!
    @IBOutlet private weak var lastNDaysCircleChart: CircleChart!
    @IBOutlet private weak var lastNDaysLabel: LabelWithSpacing!


    func configureWithViewModel(viewModel: HarvestWidgetViewModel) {
        lastDayCircleChart.configureWithViewModel(viewModel.lastDayChartModel)
        lastNDaysCircleChart.configureWithViewModel(viewModel.lastNDaysChartModel)
        lastNDaysLabel.text =  String(format: "Last\n%d Days".localized, viewModel.numberOfLastDays).uppercaseString
    }

    // MARK - fromNib

    class func fromNib() -> HarvestWidgetView {
        return NSBundle.mainBundle().loadNibNamed("HarvestWidgetView", owner: nil, options: nil)[0] as! HarvestWidgetView
    }
}
