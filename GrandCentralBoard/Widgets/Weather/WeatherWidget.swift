//
//  WeatherWidget.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore
import GCBUtilities

final class WeatherWidget: WidgetControlling {
    let sources: [UpdatingSource]

    private let widgetView: WeatherWidgetView
    private let mainView: UIView

    private lazy var errorView: UIView = {
        let errorViewModel = WidgetErrorTemplateViewModel(title: "Weather".localized.uppercaseString,
                                                          subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(errorViewModel)
    }()

    var view: UIView {
        return mainView
    }

    init(view: WeatherWidgetView, sources: [UpdatingSource]) {
        self.sources = sources
        widgetView = view

        mainView = UIView(frame: widgetView.frame)
        mainView.fillViewWithView(widgetView, animated: false)
    }

    private var hasWeatherFetchFailed = false

    func update(source: UpdatingSource) {
        switch source {
        case let source as WeatherSource:
            updateFromSource(source)
        default:
            assertionFailure("Expected `source` as instance of `TrelloSource`.")
        }
    }

    private func updateFromSource(source: WeatherSource) {
        source.read { [weak self] result in
            switch result {
            case .Success(let weather):
                self?.hasWeatherFetchFailed = false
                dispatch_async(dispatch_get_main_queue()) {
                    self?.renderWeather(weather)
                }
            case .Failure:
                self?.hasWeatherFetchFailed = true
            }
        }
    }

    private func renderErrorView() {
        guard !mainView.subviews.contains(errorView) else { return }
        mainView.fillViewWithView(errorView, animated: false)
    }

    private func removeErrorView() {
        errorView.removeFromSuperview()
    }

    private func renderWeather(weather: WeatherModel) {
        guard !hasWeatherFetchFailed else {
            renderErrorView()
            return
        }

        removeErrorView()

        let weatherViewModel = WeatherViewModel(model: weather)
        widgetView.updateWithViewModel(weatherViewModel)
    }
}
