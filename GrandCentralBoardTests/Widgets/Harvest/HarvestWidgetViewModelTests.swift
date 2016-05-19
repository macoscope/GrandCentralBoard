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
        return DailyBillingStats(day: newDay, groups: groups)
    }
}


class HarvestWidgetViewModelTests: XCTestCase {
    private let typicalDailyBillingStats = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), groups: [
        BillingStatsGroup(type: .Less, count: 5, averageHours: 4),
        BillingStatsGroup(type: .Normal, count: 8, averageHours: 6.4),
        BillingStatsGroup(type: .More, count: 3, averageHours: 7.234)])
    private let dailyBillingStatsWithEmptyGroup = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), groups: [
        BillingStatsGroup(type: .Less, count: 7, averageHours: 1),
        BillingStatsGroup(type: .Normal, count: 0, averageHours: 0),
        BillingStatsGroup(type: .More, count: 3, averageHours: 10)])

    func testViewModelForNotSortedStats() {
        let viewModel = HarvestWidgetViewModel.viewModelFromBillingStats([
            dailyBillingStatsWithEmptyGroup.statsByAddingDaysToDate(0),
            typicalDailyBillingStats.statsByAddingDaysToDate(3), //this will be the last day
            typicalDailyBillingStats.statsByAddingDaysToDate(2),
            dailyBillingStatsWithEmptyGroup.statsByAddingDaysToDate(1)
            ]
        )

        let typicalManDays = typicalDailyBillingStats.groups.reduce(0, combine: { $0 + $1.count })
        let emptyGroupManDays = dailyBillingStatsWithEmptyGroup.groups.reduce(0, combine: { $0 + $1.count })
        let totalManDays = typicalManDays + emptyGroupManDays

        expect(viewModel.lastDayChartModel.items.count) == 3
        expect(viewModel.lastDayChartModel.items[0].ratio) == Double(typicalDailyBillingStats.groups[1].count) / Double(typicalManDays)
        expect(viewModel.lastDayChartModel.items[1].ratio) == Double(typicalDailyBillingStats.groups[2].count) / Double(typicalManDays)
        expect(viewModel.lastDayChartModel.items[2].ratio) == Double(typicalDailyBillingStats.groups[0].count) / Double(typicalManDays)

        expect(viewModel.lastDayChartModel.items.count) == 3
        let normalManDays = typicalDailyBillingStats.groups[1].count + dailyBillingStatsWithEmptyGroup.groups[1].count
        expect(viewModel.lastNDaysChartModel.items[0].ratio) == Double(normalManDays) / Double(totalManDays)
        let overManDays = typicalDailyBillingStats.groups[2].count + dailyBillingStatsWithEmptyGroup.groups[2].count
        expect(viewModel.lastNDaysChartModel.items[1].ratio) == Double(overManDays) / Double(totalManDays)
        let lessManDays = typicalDailyBillingStats.groups[0].count + dailyBillingStatsWithEmptyGroup.groups[0].count
        expect(viewModel.lastNDaysChartModel.items[2].ratio) == Double(lessManDays) / Double(totalManDays)
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
