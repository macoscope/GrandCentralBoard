//
//  HarvestWidget.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


final class HarvestWidget : Widget {

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

        // TODO: Remove fake ViewModels.
        let items = [AreaBarItemViewModel(proportionalWidth: 0.5, proportionalHeight: 0.2, color: UIColor.lipstick(), valueLabelMode: .VisibleLabelLeft(text: "123")), AreaBarItemViewModel(proportionalWidth: 0.25, proportionalHeight: 0.5, color: UIColor.aquaMarine(), valueLabelMode: .VisibleWithHiddenLabel), AreaBarItemViewModel(proportionalWidth: 0.25, proportionalHeight: 1, color: UIColor.almostWhite(), valueLabelMode: .VisibleLabelRight(text: "222"))]

        let model = AreaBarChartViewModel(barItems: items, horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:", hotizontalAxisCountLabelText: "666", centerText: nil, headerText: "HARVEST BURN REPORT", subheaderText: "Monday 28.03.2016")

        widgetView.render(model)

        // Why another render? To check if view renders the view model after the previous one.
        // TODO: Remove!
        widgetView.render(AreaBarChartViewModel.emptyViewModel(header: "HARVEST BURN REPORT", subheader: "Monday 28.03.2016"))
    }
}
