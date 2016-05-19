//
//  HarvestWidget.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore


final class HarvestWidget: WidgetControlling {

    private let widgetView = HarvestWidgetView.fromNib()
    private let numberOfDays: Int
    private weak var loadingIndicatorView: UIActivityIndicatorView?

    let sources: [UpdatingSource]

    var view: UIView {
        return widgetView
    }

    init(source: HarvestSource, numberOfDays: Int) {
        self.sources = [source]
        self.numberOfDays = numberOfDays

        let emptyCircleChartModel = CircleChartViewModel(items: [CircleChartItem(color: UIColor.gcb_blackColor(), ratio: 1.0)])
        widgetView.configureWithViewModel(HarvestWidgetViewModel(lastDayChartModel: emptyCircleChartModel,
            lastNDaysChartModel: emptyCircleChartModel, numberOfLastDays: numberOfDays))

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
