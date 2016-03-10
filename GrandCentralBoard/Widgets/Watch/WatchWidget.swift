//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore

private let slideshowInterval = 10.0
private let secondsInDay: NSTimeInterval = 3600

final class WatchWidget : Widget {

    private let widgetView: WatchWidgetView
    let sources: [UpdatingSource]

    init(view: WatchWidgetView, sources: [UpdatingSource]) {
        self.widgetView = view
        self.sources = sources
    }

    var view: UIView {
        return widgetView
    }

    private var events: [Event]?
    private var lastFetch: NSDate?

    func update(source: UpdatingSource) {
        switch source {
            case let source as TimeSource:
                updateTimeFromSource(source)
            case let source as EventsSource:
                fetchEventsFromSource(source)
            default:
                assertionFailure("Expected `source` as instance of `TimeSource` or `EventsSource`.")
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
                    self?.events = events.events
                case .Failure:
                    break
            }
        }
    }

    private func renderTime(time: Time) {

        let relevantEvents = events?.filter {
            let secondsLeftToEvent = $0.time.timeIntervalSinceDate(NSDate())
            return secondsLeftToEvent > 0 && secondsLeftToEvent < secondsInDay
        }

        var event: Event? = nil

        if let relevantEvents = relevantEvents where !relevantEvents.isEmpty {
            let eventsCount = relevantEvents.count
            let index = Int(NSDate().timeIntervalSince1970 / slideshowInterval) % eventsCount
            event = relevantEvents[index]
        }

        let timeViewModel = WatchWidgetViewModel(date: time.time, timeZone: time.timeZone, event: event)
        widgetView.render(timeViewModel)
    }
}