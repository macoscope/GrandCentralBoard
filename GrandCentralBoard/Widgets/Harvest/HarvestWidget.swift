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

    private lazy var errorView: UIView = {
        let errorViewModel = WidgetErrorTemplateViewModel(title: "HARVEST",
                                                          subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(errorViewModel)
    }()

    var view: UIView {
        return widgetViewWrapper
    }
    private let numberOfDays: Int

    let sources: [UpdatingSource]

    init(source: HarvestSource, numberOfDays: Int) {
        self.sources = [source]
        self.numberOfDays = numberOfDays

        let emptyCircleChartModel = CircleChartViewModel.emptyViewModel()
        let emptyWidgetViewModel = HarvestWidgetViewModel(lastDayChartModel: emptyCircleChartModel,
                                                          lastNDaysChartModel: emptyCircleChartModel,
                                                          numberOfLastDays: numberOfDays)
        widgetView = HarvestWidgetView.fromNib()
        widgetView.configureWithViewModel(emptyWidgetViewModel)

        let viewModel = WidgetTemplateViewModel(title: "HARVEST",
                                                subtitle: "Users Billed Hours Report".localized.uppercaseString,
                                                contentView: widgetView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        widgetViewWrapper = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        widgetView.startAnimatingActivityIndicator()
    }

    private func renderErrorView() {
        guard !view.subviews.contains(errorView) else { return }
        view.fillViewWithView(errorView, animated: false)
    }

    private func removeErrorView() {
        errorView.removeFromSuperview()
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
            removeErrorView()
            let model = HarvestWidgetViewModel.viewModelFromBillingStats(billingStats)
            widgetView.configureWithViewModel(model)
        case .Failure:
            renderErrorView()
        }

    }
}
