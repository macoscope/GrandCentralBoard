//
//  HarvestWidgetViewSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 20.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import FBSnapshotTestCase
@testable import GrandCentralBoard


class HarvestWidgetViewSnapshotTests: FBSnapshotTestCase {

    private var widgetView: HarvestWidgetView!

    override func setUp() {
        super.setUp()
//        recordMode = true

        widgetView = HarvestWidgetView.fromNib()
        widgetView.frame = CGRect(x: 0, y: 0, width: 640, height: 540)
        widgetView.backgroundColor = UIColor.gcb_blackTwoColor()
    }

    func testViewWithNoBillingStats() {

        let viewModel = HarvestWidgetViewModel.viewModelFromBillingStats([])
        widgetView.configureWithViewModel(viewModel)
        FBSnapshotVerifyView(widgetView)
    }

    func testViewWithOneDayBillingStats() {

        let billings = [
            DayEntry(userID: 1, hours: 3.5),
            DayEntry(userID: 2, hours: 6.5),
            DayEntry(userID: 3, hours: 6.5),
            DayEntry(userID: 4, hours: 8.0)
        ]

        let viewModel = HarvestWidgetViewModel.viewModelFromBillingStats([
            DailyBillingStats(day: NSDate().dateWithDayOffset(-1), billings: billings)
        ])
        widgetView.configureWithViewModel(viewModel)

        FBSnapshotVerifyView(widgetView)
    }

    func testViewWithMultipleDaysBillingStats() {

        let billings1 = [
            DayEntry(userID: 1, hours: 3.5),
            DayEntry(userID: 2, hours: 6.5),
            DayEntry(userID: 3, hours: 6.5),
            DayEntry(userID: 4, hours: 8.0)
        ]

        let billings2 = [
            DayEntry(userID: 1, hours: 3.5),
            DayEntry(userID: 3, hours: 6.5),
            DayEntry(userID: 4, hours: 1.0)
        ]

        let viewModel = HarvestWidgetViewModel.viewModelFromBillingStats([
            DailyBillingStats(day: NSDate().dateWithDayOffset(-1), billings: billings1),
            DailyBillingStats(day: NSDate().dateWithDayOffset(-2), billings: billings2)
            ])
        widgetView.configureWithViewModel(viewModel)

        FBSnapshotVerifyView(widgetView)
    }

}
