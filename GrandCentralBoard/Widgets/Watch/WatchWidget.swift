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
    var meetingDate: NSDate?

    @objc func update() {

        let result = source.read()

        switch result {
            case .Success(let time):
                let timeViewModel = WatchWidgetViewModel(date: time.time, timeZone: time.timeZone, events: events)
                widgetView.render(timeViewModel)
            case .Failure:
                widgetView.failure()
        }

        source.eventSource.read { result in
            switch result {
                case .Success(let events):
                    self.events = events.events.filter({ $0.time.timeIntervalSinceDate(NSDate()) > 0}).filter({ $0.time.timeIntervalSinceDate(NSDate()) < 60*60 })
                default: break
            }
        }
    }
}