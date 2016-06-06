//
//  AnalogClockWidget.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

final class AnalogClockWidget: WidgetControlling {
    private let widgetView: AnalogClockWidgetView
    private let mainView: UIView

    private lazy var errorView: UIView = {
        let errorViewModel = WidgetErrorTemplateViewModel(title: "Clock".localized.uppercaseString,
                                                          subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(errorViewModel)
    }()

    let sources: [UpdatingSource]

    init(view: AnalogClockWidgetView, sources: [UpdatingSource]) {
        self.widgetView = view
        self.sources = sources

        mainView = UIView(frame: widgetView.frame)
        mainView.fillViewWithView(widgetView, animated: false)
    }

    var view: UIView {
        return widgetView
    }

    private var lastFetch: NSDate?
    func update(source: UpdatingSource) {
        switch source {
        case let source as AnalogClockSource:
            updateTimeFromSource(source)
        default:
            assertionFailure("Expected `source` as instance of `TimeSource`.")
        }
    }

    private func updateTimeFromSource(source: AnalogClockSource) {
        let result = source.read()

        switch result {
        case .Success(let time):
            renderTime(time)
        case .Failure:
            widgetView.failure()
        }
    }

    private func renderTime(time: Time) {
        let timeViewModel = AnalogClockWidgetViewModel(date: time.time, timeZone: time.timeZone)
        widgetView.render(timeViewModel)
    }
}
