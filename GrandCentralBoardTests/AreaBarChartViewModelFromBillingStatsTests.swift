//
//  AreaBarChartViewModelFromBillingStatsTests.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard

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
        let billingStats = [emptyDailyBillingStats, normalDailyBillingStats, normalDailyBillingStats]
        let viewModel = AreaBarChartViewModel.viewModelFromBillingStats(billingStats)

        XCTAssertEqual(viewModel.mainChart.barItems[0].valueLabelMode, AreaBarItemValueLabelDisplayMode.Hidden)
        XCTAssertEqual(viewModel.mainChart.barItems[1].valueLabelMode, AreaBarItemValueLabelDisplayMode.Hidden)
        XCTAssertEqual(viewModel.mainChart.barItems[2].valueLabelMode, AreaBarItemValueLabelDisplayMode.Hidden)

        XCTAssertEqual(viewModel.componentCharts.count, 2)

        for componentChart in viewModel.componentCharts {
            XCTAssertEqual(componentChart.barItems[0].proportionalWidth, 0.1)
            XCTAssertEqual(componentChart.barItems[1].proportionalWidth, 0.2)
            XCTAssertEqual(componentChart.barItems[2].proportionalWidth, 0.7)
        }
    }

    func testCreatingTheViewModelFromBillingStatsWithEmptyOtherDays() {
        let billingStats = [normalDailyBillingStats, emptyDailyBillingStats, emptyDailyBillingStats]
        let viewModel = AreaBarChartViewModel.viewModelFromBillingStats(billingStats)

        XCTAssertEqual(viewModel.mainChart.barItems[0].proportionalWidth, 0.1)
        XCTAssertEqual(viewModel.mainChart.barItems[1].proportionalWidth, 0.2)
        XCTAssertEqual(viewModel.mainChart.barItems[2].proportionalWidth, 0.7)

        XCTAssertEqual(viewModel.componentCharts.count, 0)
    }
}
