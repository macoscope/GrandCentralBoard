//
//  clockWidget.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

final class DigitalClockWidget: WidgetControlling {
    private let widgetView: DigitalClockWidgetView
    private let mainView: UIView

    let sources: [UpdatingSource]

    init(view: DigitalClockWidgetView, sources: [UpdatingSource]) {
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
        case let source as DigitalClockSource:
            updateTimeFromSource(source)
        default:
            assertionFailure("Expected `source` as instance of `TimeSource`.")
        }
    }

    private func updateTimeFromSource(source: DigitalClockSource) {
        let result = source.read()

        switch result {
        case .Success(let time):
            renderTime(time)
        case .Failure:
            widgetView.failure()
        }
    }

    private func renderTime(time: Time) {
        let timeViewModel = DigitalClockWidgetViewModel(date: time.time, timeZone: time.timeZone)
        widgetView.render(timeViewModel)
    }
}
