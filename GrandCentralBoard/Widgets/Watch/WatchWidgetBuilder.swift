//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

final class WatchWidgetBuilder : WidgetBuilding {

    let name = "watch"

    func build(settings: AnyObject) throws -> Widget {
        
        let settings = try TimeSourceSettings.decode(settings)

        let timeSource = TimeSource(settings: settings)
        let eventSource = EventsSource(settings: EventsSourceSettings(calendarPath: settings.calendarPath))

        return WatchWidget(sources: [timeSource, eventSource])
    }
}
