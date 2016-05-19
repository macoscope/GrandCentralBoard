//
//  HarvestWidgetViewModelTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 2016-05-19.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
import Nimble
@testable import GrandCentralBoard

private extension DailyBillingStats {

    func statsByAddingDaysToDate(days: Int) -> DailyBillingStats {
        let newDay = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: days, toDate: day, options: [])!
        return DailyBillingStats(day: newDay, billings: billings)
    }
}


class HarvestWidgetViewModelTests: XCTestCase {
    private let typicalDailyBillingStats = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), billings: [
        DayEntry(userID: 1, hours: 6.0),
        DayEntry(userID: 2, hours: 7.0),
        DayEntry(userID: 3, hours: 8.0),
        DayEntry(userID: 4, hours: 6.5),
        DayEntry(userID: 5, hours: 6.6),
        DayEntry(userID: 6, hours: 9.0)
        ])
    private let dayWithoutUsers = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), billings: [
        DayEntry(userID: 1, hours: 7.0),
        DayEntry(userID: 2, hours: 7.0),
        DayEntry(userID: 3, hours: 2.0),
        DayEntry(userID: 5, hours: 6.5)
        ])

    func testViewModelForNotSortedStats() {
        let viewModel = HarvestWidgetViewModel.viewModelFromBillingStats([
            dayWithoutUsers.statsByAddingDaysToDate(0),
            typicalDailyBillingStats.statsByAddingDaysToDate(4), //this will be the last day
            typicalDailyBillingStats.statsByAddingDaysToDate(3),
            dayWithoutUsers.statsByAddingDaysToDate(1),
            dayWithoutUsers.statsByAddingDaysToDate(2)
            ]
        )

        expect(viewModel.lastDayChartModel.items.count) == 3
        expect(viewModel.lastDayChartModel.items[0].ratio) == 2 / 6.0
        expect(viewModel.lastDayChartModel.items[1].ratio) == 1 / 6.0
        expect(viewModel.lastDayChartModel.items[2].ratio) == 3 / 6.0

        expect(viewModel.lastNDaysChartModel.items.count) == 3
        expect(viewModel.lastNDaysChartModel.items[0].ratio) == 3 / 6.0
        expect(viewModel.lastNDaysChartModel.items[1].ratio) == 1 / 6.0
        expect(viewModel.lastNDaysChartModel.items[2].ratio) == 2 / 6.0
    }

    func testLastDaysLabelTextFor1Day() {
        let viewModel = HarvestWidgetViewModel(lastDayChartModel: CircleChartViewModel(items: []),
                                               lastNDaysChartModel: CircleChartViewModel(items: []),
                                               numberOfLastDays: 1)

        expect(viewModel.lastDaysLabelText) == "LAST\nDAY"
    }

    func testLastDaysLabelTextForMultipleDays() {
        for numberOfDays in 2...5 {
            let viewModel = HarvestWidgetViewModel(lastDayChartModel: CircleChartViewModel(items: []),
                                                   lastNDaysChartModel: CircleChartViewModel(items: []),
                                                   numberOfLastDays: numberOfDays)

            expect(viewModel.lastDaysLabelText) == "LAST\n\(numberOfDays) DAYS"
        }
    }
}
