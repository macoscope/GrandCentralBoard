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

    let sources: [UpdatingSource]

    var view: UIView {
        return widgetView
    }

    init(sources: [UpdatingSource], numberOfDays: Int) {
        self.sources = sources
        self.numberOfDays = numberOfDays

        let emptyCircleChartModel = CircleChartViewModel(startAngle: 0, items: [CircleChartItem(color: UIColor.gcb_blackColor(), ratio: 1.0)])
        widgetView.configureWithViewModel(HarvestWidgetViewModel(lastDayChartModel: emptyCircleChartModel,
            lastNDaysChartModel: emptyCircleChartModel, numberOfLastDays: numberOfDays))
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

    }
}
