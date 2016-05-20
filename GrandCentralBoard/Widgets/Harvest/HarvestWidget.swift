//
//  HarvestWidget.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore


final class HarvestWidget: WidgetControlling {

    private let widgetView: HarvestWidgetView
    private let widgetViewWrapper: WidgetTemplateView

    private let numberOfDays: Int

    let sources: [UpdatingSource]

    var view: UIView {
        return widgetViewWrapper
    }

    init(source: HarvestSource, numberOfDays: Int) {
        self.sources = [source]
        self.numberOfDays = numberOfDays

        let emptyCircleChartModel = CircleChartViewModel(items: [CircleChartItem(color: UIColor.gcb_blackColor(), ratio: 1.0)])
        let emptyWidgetViewModel = HarvestWidgetViewModel(lastDayChartModel: emptyCircleChartModel,
                                                          lastNDaysChartModel: emptyCircleChartModel,
                                                          numberOfLastDays: numberOfDays)
        widgetView = HarvestWidgetView.fromNib()
        widgetView.configureWithViewModel(emptyWidgetViewModel)

        let viewModel = WidgetTemplateViewModel(title: "HARVEST", subtitle: "USERS BILLED HOURS REPORT", contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        widgetViewWrapper = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        widgetView.startAnimatingActivityIndicator()
    }

    func update(source: UpdatingSource) {
        guard let source = source as? HarvestSource else {
            fatalError("Expected `source` as instance of `HarvestSource`.")
        }

        source.read { [weak self] result in
            self?.updateViewWithResult(result)
        }
    }

    func updateViewWithResult(result: HarvestSource.ResultType) {
        widgetView.stopAnimatingActivityIndicator()

        switch result {
        case .Success(let billingStats):
            let model = HarvestWidgetViewModel.viewModelFromBillingStats(billingStats)
            widgetView.configureWithViewModel(model)
        case .Failure: break
        }

    }
}
