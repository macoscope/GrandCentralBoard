//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable
import GrandCentralBoardCore


final class WatchWidgetBuilder : WidgetBuilding {

    let name = "watch"

    private let dataDownloader: DataDownloading

    init(dataDownloader: DataDownloading) {
        self.dataDownloader = dataDownloader
    }

    func build(settings: AnyObject) throws -> Widget {
        
        let settings = try TimeSourceSettings.decode(settings)

        let timeSource = TimeSource(settings: settings)
        let eventSource = EventsSource(settings: EventsSourceSettings(calendarPath: settings.calendarPath), dataDownloader: dataDownloader)
        let view = WatchWidgetView.fromNib()

        return WatchWidget(view: view, sources: [timeSource, eventSource])
    }
}
