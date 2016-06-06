//
//  WatchWidgetSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 19.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import FBSnapshotTestCase
import Nimble
import GCBCore
@testable import GrandCentralBoard


private final class TestCalendarErrorsDataProvider: CalendarDataProviding {

    func fetchEventsForCalendar(completion: (Result<[Event]>) -> Void) {
        completion(.Failure(ErrorWithMessage(message: "")))
    }
    func fetchCalendar(completion: (Result<Calendar>) -> Void) {
        completion(.Failure(ErrorWithMessage(message: "")))
    }
}

final class WatchWidgetSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testWidgetShowsErrorOnEventsFailure() {
        let watchWidgetView = WatchWidgetView(frame: CGRect(x: 0, y: 0, width: 640, height: 540))

        let timeSource = TimeSource(settings: TimeSourceSettings(timeZone: NSTimeZone(name: "Europe/Warsaw")!))
        let eventsSource = EventsSource(dataProvider: TestCalendarErrorsDataProvider())

        let watchWidget = WatchWidget(view: watchWidgetView, sources: [timeSource, eventsSource])
        watchWidget.update(eventsSource)
        watchWidget.update(timeSource)

        FBSnapshotVerifyView(watchWidget.view)
    }

    func testWidgetShowsErrorOnCalendarNameFailure() {
        let watchWidgetView = WatchWidgetView(frame: CGRect(x: 0, y: 0, width: 640, height: 540))

        let timeSource = TimeSource(settings: TimeSourceSettings(timeZone: NSTimeZone(name: "Europe/Warsaw")!))
        let calendarNameSource = CalendarNameSource(dataProvider: TestCalendarErrorsDataProvider())

        let watchWidget = WatchWidget(view: watchWidgetView, sources: [timeSource, calendarNameSource])
        watchWidget.update(calendarNameSource)
        watchWidget.update(timeSource)

        FBSnapshotVerifyView(watchWidget.view)
    }
}
