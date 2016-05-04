//
//  HarvestWidget.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestWidget: WidgetControlling {

    private let widgetView: AreaBarChartView

    let sources: [UpdatingSource]

    var view: UIView {
        return widgetView
    }

    init(view: AreaBarChartView, sources: [UpdatingSource]) {
        self.widgetView = view
        self.sources = sources
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
        switch result {
        case .Success(let billingStats):
            let model = AreaBarChartViewModel.viewModelFromBillingStats(billingStats)
            widgetView.render(model)

        case .Failure:
            widgetView.failure()
        }
    }
}
