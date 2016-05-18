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
