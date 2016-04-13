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

    func build(settings: AnyObject) throws -> Widget {
        let timeSettings = try TimeSourceSettings.decode(settings)
        let calendarSettings = try GoogleCalendarSourceSettings.decode(settings)

        let networkRequestManager = Manager()
        let tokenProvider = GoogleTokenProvider(clientID: calendarSettings.clientID,
                                                clientSecret: calendarSettings.clientSecret,
                                                refreshToken: calendarSettings.refreshToken)
        let apiDataProvider = GoogleAPIDataProvider(tokenProvider: tokenProvider, networkRequestManager: networkRequestManager)
        let calendarDataProvider = GoogleCalendarDataProvider(dataProvider: apiDataProvider)

        let calendarID = calendarSettings.calendarID

        let calendarNameSource = CalendarNameSource(calendarID: calendarID, dataProvider: calendarDataProvider)
        let timeSource = TimeSource(settings: timeSettings)
        let eventsSource = EventsSource(calendarID: calendarID, dataProvider: calendarDataProvider)
        let view = WatchWidgetView.fromNib()

        return WatchWidget(view: view, sources: [timeSource, eventsSource, calendarNameSource])
    }
}
