//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

private let slideshowInterval = 10.0

final class WatchWidget : Widget  {

    private unowned let widgetView: WatchWidgetView
    let sources: [UpdatingSource]

    init(sources: [UpdatingSource]) {
        self.widgetView = WatchWidgetView.fromNib()
        self.sources = sources
    }

    var view: UIView {
        return widgetView
    }

    var events: [Event]?
    var lastFetch: NSDate?

    @objc func update(timer: NSTimer) {

        if let source = timer.userInfo as? TimeSource {
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
        }

        if let source = timer.userInfo as? EventsSource {
            source.read { [weak self] result in
                guard let instance = self else { return }
    
                switch result {
                    case .Success(let events):
                        instance.events = events.events
                    case .Failure:
                    break
                }
            }
        }
    }

    private func renderTime(time: Time) {
        let relevantEvents = events?.filter {
            $0.time.timeIntervalSinceDate(NSDate()) > 0 && $0.time.timeIntervalSinceDate(NSDate()) < 60*60
        }

        var event: Event? = nil

        if let relevantEvents = relevantEvents where relevantEvents.count > 0 {
            let eventsCount = relevantEvents.count
            let index = Int(NSDate().timeIntervalSince1970 / slideshowInterval) % eventsCount
            event = relevantEvents[index]
        }

        let timeViewModel = WatchWidgetViewModel(date: time.time, timeZone: time.timeZone, event: event)
        widgetView.render(timeViewModel)
    }
}