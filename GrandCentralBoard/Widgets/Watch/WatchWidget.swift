//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class WatchWidget : Widget  {

    private unowned let widgetView: WatchWidgetView
    let source: TimeSource

    init(source: TimeSource) {
        self.widgetView = WatchWidgetView.fromNib()
        self.source = source
    }

    var interval: NSTimeInterval {
        return source.optimalInterval
    }

    var view: UIView {
        return widgetView
    }

    var events: [Event]?
    var lastFetch: NSDate?

    @objc func update() {

        let result = source.read()
        var time: Time

        switch result {
            case .Success(let timeFromSource):
                time = timeFromSource
            case .Failure:
                widgetView.failure()
                return
        }

        renderTime(time)

        let intervalPassed = NSDate().timeIntervalSinceDate(lastFetch ?? NSDate()) > source.eventSource.optimalInterval
        let noEvents = events == nil
        let shouldFetchEvents = intervalPassed || noEvents

        guard shouldFetchEvents else { return }

        lastFetch = NSDate()
        source.eventSource.read { [weak self] result in
            guard let instance = self else { return }

            switch result {
                case .Success(let events):
                    instance.events = events.events
                case .Failure:
                break
            }
        }
    }

    private func renderTime(time: Time) {
        let relevantEvents = events?.filter {
            $0.time.timeIntervalSinceDate(NSDate()) > 0 && $0.time.timeIntervalSinceDate(NSDate()) < 60*60
        }

        let eventsCount = relevantEvents?.count ?? 1
        let index = Int(NSDate().timeIntervalSince1970/10.0) % eventsCount
        let event = relevantEvents?[index]

        let timeViewModel = WatchWidgetViewModel(date: time.time, timeZone: time.timeZone, event: event)
        widgetView.render(timeViewModel)
    }
}