//
//  AreaBarChartViewModelFromBillingStatsTests.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard


private extension DailyBillingStats {

    func statsByAddingDaysToDate(days: Int) -> DailyBillingStats {
        let newDay = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: days, toDate: day, options: [])!
        return DailyBillingStats(day: newDay, groups: groups)
    }
}

// swiftlint:disable:next type_name
class AreaBarChartViewModelFromBillingStatsTests: XCTestCase {
    let emptyDailyBillingStats = DailyBillingStats(day: NSDate(), groups: [
        BillingStatsGroup(type: .Less, count: 0, averageHours: 0),
        BillingStatsGroup(type: .Normal, count: 0, averageHours: 0),
        BillingStatsGroup(type: .More, count: 0, averageHours: 0)])
    let normalDailyBillingStats = DailyBillingStats(day: NSDate(), groups: [
        BillingStatsGroup(type: .Less, count: 1, averageHours: 5),
        BillingStatsGroup(type: .Normal, count: 2, averageHours: 6.5),
        BillingStatsGroup(type: .More, count: 7, averageHours: 8)])

    func testCreatingTheViewModelFromBillingStatsWithEmptyFirstDay() {
        let billingStats = [emptyDailyBillingStats.statsByAddingDaysToDate(2),
                            normalDailyBillingStats.statsByAddingDaysToDate(1),
                            normalDailyBillingStats]
        let viewModel = AreaBarChartViewModel.viewModelFromBillingStats(billingStats)

        XCTAssertEqual(viewModel.mainChart.barItems.count, 3)
        viewModel.mainChart.barItems.forEach {
            XCTAssertEqual($0.valueLabelMode, AreaBarItemValueLabelDisplayMode.Hidden)
        }

        XCTAssertEqual(viewModel.componentCharts.count, 2)
        viewModel.componentCharts.forEach {
            XCTAssertEqual($0.barItems[0].proportionalWidth, 0.1)
            XCTAssertEqual($0.barItems[1].proportionalWidth, 0.2)
            XCTAssertEqual($0.barItems[2].proportionalWidth, 0.7)
        }
    }

    func testCreatingTheViewModelFromBillingStatsWithEmptyOtherDays() {
        let billingStats = [normalDailyBillingStats.statsByAddingDaysToDate(2),
                            emptyDailyBillingStats.statsByAddingDaysToDate(1),
                            emptyDailyBillingStats]
        let viewModel = AreaBarChartViewModel.viewModelFromBillingStats(billingStats)

        XCTAssertEqual(viewModel.mainChart.barItems[0].proportionalWidth, 0.1)
        XCTAssertEqual(viewModel.mainChart.barItems[1].proportionalWidth, 0.2)
        XCTAssertEqual(viewModel.mainChart.barItems[2].proportionalWidth, 0.7)

        XCTAssertEqual(viewModel.componentCharts.count, 0)
    }

    func testBillingStatsAreSortedCorrectlyByDate() {
        let billingStats = [normalDailyBillingStats.statsByAddingDaysToDate(1),
                            normalDailyBillingStats,
                            emptyDailyBillingStats.statsByAddingDaysToDate(2)]
        let viewModel = AreaBarChartViewModel.viewModelFromBillingStats(billingStats)

        XCTAssertEqual(viewModel.mainChart.barItems.count, 3)
        viewModel.mainChart.barItems.forEach {
            XCTAssertEqual($0.proportionalWidth, 1 / 3.0)
        }

        XCTAssertEqual(viewModel.componentCharts.count, 2)
    }
}
