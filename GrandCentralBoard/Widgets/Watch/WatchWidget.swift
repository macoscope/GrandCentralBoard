//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class WatchWidget : Widget  {

    private let widgetView: WatchWidgetView
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

    @objc func update() {

        let result = source.read()

        switch result {
            case .Success(let time):
                let timeViewModel = WatchWidgetViewModel(date: time.time, timeZone: time.timeZone)
                widgetView.render(timeViewModel)
            case .Failure:
                widgetView.failure()
        }
    }
}