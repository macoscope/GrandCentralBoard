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
        guard let source = source as? HarvestSource else { return }

        source.read({ result in
            self.updateViewWithViewModel(result)
        })
    }

    func updateViewWithViewModel(viewModel: HarvestSource.ResultType) {

        // TODO: Remove fake ViewModels.
        let items = [AreaBarItemViewModel(proportionalWidth: 0.5, proportionalHeight: 0.2, color: UIColor.lipstick(), valueLabelMode: .Left(text: "123")), AreaBarItemViewModel(proportionalWidth: 0.25, proportionalHeight: 0.5, color: UIColor.aquaMarine(), valueLabelMode: .Hidden), AreaBarItemViewModel(proportionalWidth: 0.25, proportionalHeight: 1, color: UIColor.almostWhite(), valueLabelMode: .Right(text: "222"))]

        let model = AreaBarChartViewModel(barItems: items, horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:", hotizontalAxisCountLabelText: "666")

        widgetView.render(model)
    }
}
