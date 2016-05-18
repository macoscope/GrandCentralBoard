//
//  WatchWidgetViewModelTests.swift
//  GrandCentralBoard
//
//  Created by Maciek Grzybowski on 18.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import GrandCentralBoard


class WatchWidgetViewModelTests: FBSnapshotTestCase {

    let now = NSDate()
    let timeZone = NSTimeZone.defaultTimeZone()
    let calendarName = "Calendar name"

    func eventStartingAt(startTime: NSDate) -> Event {
        return Event(name: "Event name", time: startTime)
    }

    func widgetRenderingViewModel(viewModel: WatchWidgetViewModel) -> UIView {
        let view = WatchWidgetView.fromNib()
        view.render(viewModel)
        return view
    }

    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testEventStartingNow() {
        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt(now), calendarName: calendarName
        )
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testEventStartingIn1Minute() {
        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt( now + 1.minutes ), calendarName: calendarName
        )
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testEventStartingIn5Minutes() {
        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt( now + 5.minutes ), calendarName: calendarName
        )
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testEventStartingIn6Minutes() {
        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt( now + 6.minutes ), calendarName: calendarName
        )
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testEventStartingIn55Minutes() {
        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt( now + 55.minutes ), calendarName: calendarName
        )
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testEventStartingIn60Minutes() {
        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt( now + 60.minutes ), calendarName: calendarName
        )
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testTimeRenderingWithEvent() {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        timeFormatter.timeZone = timeZone

        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: eventStartingAt( now + 5.minutes ), calendarName: calendarName
        )

        XCTAssertEqual(viewModel.alignedTimeText, timeFormatter.stringFromDate(now))
        XCTAssertNil(viewModel.centeredTimeText)
        XCTAssertNotNil(viewModel.eventText)
    }

    func testTimeRenderingWithoutEvent() {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        timeFormatter.timeZone = timeZone

        let viewModel = WatchWidgetViewModel(
            date: now, timeZone: timeZone, event: nil
        )

        XCTAssertNil(viewModel.alignedTimeText)
        XCTAssertEqual(viewModel.centeredTimeText, timeFormatter.stringFromDate(now))
        XCTAssertNil(viewModel.eventText)
    }
}


// MARK: Syntax sugar

private extension Int {
    var minutes: NSTimeInterval {
        return NSTimeInterval(self) * 60
    }
}

private func + (date: NSDate, timeInterval: NSTimeInterval) -> NSDate {
    return date.dateByAddingTimeInterval(timeInterval)
}
