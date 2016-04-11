//
//  GoogleCalendarWatchWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore
import Alamofire

final class GoogleCalendarWatchWidgetBuilder : WidgetBuilding {

    let name = "googleCalendarWatch"

    private let dataDownloader: DataDownloading

    init(dataDownloader: DataDownloading) {
        self.dataDownloader = dataDownloader
    }

    func build(settings: AnyObject) throws -> Widget {
        let networkRequestManager = Manager()

        let timeSettings = try TimeSourceSettings.decode(settings)
        let eventsSettings = try GoogleCalendarEventsSourceSettings.decode(settings)

        let timeSource = TimeSource(settings: timeSettings)
        let eventSource = GoogleCalendarEventsSource(settings: eventsSettings, networkRequestManager: networkRequestManager)
        let view = WatchWidgetView.fromNib()

        return WatchWidget(view: view, sources: [timeSource, eventSource])
    }
}
