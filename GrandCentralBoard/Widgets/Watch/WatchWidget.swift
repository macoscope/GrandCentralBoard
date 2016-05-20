//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

private let secondsInAnHour: NSTimeInterval = 3600

final class WatchWidget: WidgetControlling {

    let sources: [UpdatingSource]

    private let widgetView: WatchWidgetView
    private let mainView: UIView

    private lazy var errorView: UIView = {
        let errorViewModel = WidgetErrorTemplateViewModel(title: "Clock & Calendar".localized.uppercaseString,
                                                          subtitle: "Error".localized.uppercaseString)
        return WidgetTemplateView.viewWithErrorViewModel(errorViewModel)
    }()

    var view: UIView {
        return mainView
    }

    init(view: WatchWidgetView, sources: [UpdatingSource]) {
        self.sources = sources
        widgetView = view

        mainView = UIView(frame: widgetView.frame)
        mainView.fillViewWithView(widgetView, animated: false)
    }

    private var calendarName: String?
    private var events: [Event]?
    private var lastFetch: NSDate?

    private var hasCalendarNameFetchFailed = false
    private var hasEventsFetchFailed = false

    func update(source: UpdatingSource) {
        switch source {
            case let source as TimeSource:
                updateTimeFromSource(source)
            case let source as EventsSource:
                fetchEventsFromSource(source)
            case let source as CalendarNameSource:
                fetchCalendarNameFromSource(source)
            default:
                assertionFailure("Expected `source` as instance of `TimeSource` or `EventsSource`.")
        }
    }

    private func fetchCalendarNameFromSource(source: CalendarNameSource) {
        source.read { [weak self] result in
            switch result {
            case .Success(let calendar):
                self?.calendarName = calendar.name
                self?.hasCalendarNameFetchFailed = false
            case .Failure:
                self?.hasCalendarNameFetchFailed = true
            }
        }
    }

    private func updateTimeFromSource(source: TimeSource) {
        let result = source.read()

        switch result {
            case .Success(let time):
                renderTime(time)
            case .Failure:
                widgetView.failure()
                return
        }
    }

    private func fetchEventsFromSource(source: EventsSource) {
        source.read { [weak self] result in
            switch result {
                case .Success(let events):
                    self?.events = events
                    self?.hasEventsFetchFailed = false
                case .Failure:
                    self?.hasEventsFetchFailed = true
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

    private func renderTime(time: Time) {
        guard !hasCalendarNameFetchFailed && !hasEventsFetchFailed else {
            renderErrorView()
            return
        }

        removeErrorView()

        let relevantEvents = events?.filter {
            let secondsLeftToEvent = $0.time.timeIntervalSinceDate(NSDate())
            return secondsLeftToEvent > 0 && secondsLeftToEvent < secondsInAnHour
        }

        let event: Event? = relevantEvents?.first
        let displayedCalendarName = event != nil ? calendarName : nil
        let timeViewModel = WatchWidgetViewModel(date: time.time, timeZone: time.timeZone, event: event, calendarName: displayedCalendarName)
        widgetView.render(timeViewModel)
    }
}
