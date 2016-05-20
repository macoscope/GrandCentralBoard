//
//  HarvestWidgetView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit
import GCBUtilities


struct HarvestWidgetViewModel {
    let lastDayChartModel: CircleChartViewModel
    let lastNDaysChartModel: CircleChartViewModel
    let lastDaysLabelText: String

    init(lastDayChartModel: CircleChartViewModel, lastNDaysChartModel: CircleChartViewModel, numberOfLastDays: Int) {
        self.lastDayChartModel = lastDayChartModel
        self.lastNDaysChartModel = lastNDaysChartModel

        if numberOfLastDays == 1 {
            lastDaysLabelText = "Last\nDay".localized.uppercaseString
        } else {
            lastDaysLabelText = String(format: "Last\n%d Days".localized, numberOfLastDays).uppercaseString
        }
    }
}

extension HarvestWidgetViewModel {

    static func viewModelFromBillingStats(stats: [DailyBillingStats]) -> HarvestWidgetViewModel {
        //sort with timestamp descending
        let stats = stats.sort { (left, right) -> Bool in
            left.day > right.day
        }

        guard let lastDayStats = stats.first else {
            let emptyCircleChartViewModel = CircleChartViewModel(items: [])
            return HarvestWidgetViewModel(lastDayChartModel: emptyCircleChartViewModel,
                                          lastNDaysChartModel: emptyCircleChartViewModel,
                                          numberOfLastDays: stats.count)
        }

        let lastDayChartViewModel = CircleChartViewModel.chartViewModelFromBillingStats(lastDayStats)
        let lastNDaysChartViewModel = CircleChartViewModel.chartViewModelFromMultipleBillingStats(stats)
        return HarvestWidgetViewModel(lastDayChartModel: lastDayChartViewModel,
                                      lastNDaysChartModel: lastNDaysChartViewModel,
                                      numberOfLastDays: stats.count)
    }
}

final class HarvestWidgetView: UIView {

    @IBOutlet private weak var lastDayCircleChart: CircleChart!
    @IBOutlet private weak var lastNDaysCircleChart: CircleChart!
    @IBOutlet private weak var lastNDaysLabel: LabelWithSpacing!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    func startAnimatingActivityIndicator() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }

    func stopAnimatingActivityIndicator() {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }

    func configureWithViewModel(viewModel: HarvestWidgetViewModel) {
        lastDayCircleChart.configureWithViewModel(viewModel.lastDayChartModel)
        lastNDaysCircleChart.configureWithViewModel(viewModel.lastNDaysChartModel)
        lastNDaysLabel.text = viewModel.lastDaysLabelText
    }

    // MARK - fromNib

    class func fromNib() -> HarvestWidgetView {
        return NSBundle.mainBundle().loadNibNamed("HarvestWidgetView", owner: nil, options: nil)[0] as! HarvestWidgetView
    }
}
