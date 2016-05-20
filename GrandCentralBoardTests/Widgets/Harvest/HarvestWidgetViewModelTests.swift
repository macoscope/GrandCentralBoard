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
        let billingStats = [
            dayWithoutUsers.statsByAddingDaysToDate(0),
            typicalDailyBillingStats.statsByAddingDaysToDate(4), //this will be the last day
            typicalDailyBillingStats.statsByAddingDaysToDate(3),
            dayWithoutUsers.statsByAddingDaysToDate(1),
            dayWithoutUsers.statsByAddingDaysToDate(2)
        ]
        let viewModel = HarvestWidgetViewModel.viewModelFromBillingStats(billingStats)

        var statsLastDay: [BillingStatsGroupType: Int] = [ .Less: 0, .Normal: 0, .More: 0 ]
        var statsMultipleDays: [BillingStatsGroupType: Int] = [ .Less: 0, .Normal: 0, .More: 0 ]

        for userID in 1...6 {
            let hoursInDayTypical = typicalDailyBillingStats.billings.filter { $0.userID == userID }.map { $0.hours }.first
            let hoursInDayWithoutUsers = dayWithoutUsers.billings.filter { $0.userID == userID }.map { $0.hours }.first

            let userLastDayStatType = BillingStatsGroupType.typeForHours(hoursInDayTypical!)
            statsLastDay[userLastDayStatType] = statsLastDay[userLastDayStatType]! + 1

            if let hoursInDayWithoutUsers = hoursInDayWithoutUsers {
                let userMultipleDaysStatType = BillingStatsGroupType.typeForHours((hoursInDayTypical! * 2.0 + hoursInDayWithoutUsers * 3.0) / 5.0)
                statsMultipleDays[userMultipleDaysStatType] = statsMultipleDays[userMultipleDaysStatType]! + 1
            } else {
                statsMultipleDays[userLastDayStatType] = statsMultipleDays[userLastDayStatType]! + 1
            }
        }

        expect(viewModel.lastDayChartModel.items.count) == 3
        expect(viewModel.lastDayChartModel.items[0].ratio) == Double(statsLastDay[.Normal]!) / 6.0
        expect(viewModel.lastDayChartModel.items[1].ratio) == Double(statsLastDay[.Less]!) / 6.0
        expect(viewModel.lastDayChartModel.items[2].ratio) == Double(statsLastDay[.More]!) / 6.0

        expect(viewModel.lastNDaysChartModel.items.count) == 3
        expect(viewModel.lastNDaysChartModel.items[0].ratio) == Double(statsMultipleDays[.Normal]!) / 6.0
        expect(viewModel.lastNDaysChartModel.items[1].ratio) == Double(statsMultipleDays[.Less]!) / 6.0
        expect(viewModel.lastNDaysChartModel.items[2].ratio) == Double(statsMultipleDays[.More]!) / 6.0
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
