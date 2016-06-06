//
//  AnalogClockViewModelTests.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 6/6/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import GrandCentralBoard

class AnalogClockViewModelTests: FBSnapshotTestCase {

    private let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en_US")

        return formatter
    }()

    let timeZone = NSTimeZone(forSecondsFromGMT: 0)

    func widgetRenderingViewModel(viewModel: AnalogClockWidgetViewModel) -> UIView {
        let view = AnalogClockWidgetView.fromNib()
        view.render(viewModel)
        return view
    }


    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testClockMidnight() {
        let date = formatter.dateFromString("2016-06-06 00:00:00")

        let viewModel = AnalogClockWidgetViewModel(date: date!, timeZone: timeZone)
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }

    func testClock315pm() {
        let date = formatter.dateFromString("2016-06-06 15:15:15")

        let viewModel = AnalogClockWidgetViewModel(date: date!, timeZone: timeZone)
        FBSnapshotVerifyView(widgetRenderingViewModel(viewModel))
    }
}
