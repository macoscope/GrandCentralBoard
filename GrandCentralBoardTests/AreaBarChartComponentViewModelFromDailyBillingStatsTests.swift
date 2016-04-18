//
//  AreaBarChartComponentViewModelFromDailyBillingStatsTests.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard


class AreaBarChartComponentViewModelFromDailyBillingStatsTests: XCTestCase {
    static let typicalDailyBillingStats = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), groups: [
        BillingStatsGroup(type: .Less, count: 5, averageHours: 4),
        BillingStatsGroup(type: .Normal, count: 8, averageHours: 6.4),
        BillingStatsGroup(type: .More, count: 3, averageHours: 7.2)])
    static let dailyBillingStatsWithEmptyGroup = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), groups: [
        BillingStatsGroup(type: .Less, count: 7, averageHours: 1),
        BillingStatsGroup(type: .Normal, count: 0, averageHours: 0),
        BillingStatsGroup(type: .More, count: 3, averageHours: 10)])
    let viewModelForTypicalDay = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(typicalDailyBillingStats)!
    let viewModelForDayWithEmptyGroup = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(dailyBillingStatsWithEmptyGroup)!
    let viewModelForMainChart = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(typicalDailyBillingStats, isMainChart: true)!
    let viewModelForPreviousDayChart = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(dailyBillingStatsWithEmptyGroup, isMainChart: false)!

    func testItemCountForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems.count, 3)
    }

    func testItemCountForDayWithAnEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems.count, 2)
    }

    func testHeightForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems[0].proportionalHeight, 0.5)
        XCTAssertEqual(viewModelForTypicalDay.barItems[1].proportionalHeight, 0.8)
        XCTAssertEqual(viewModelForTypicalDay.barItems[2].proportionalHeight, 0.9)
    }

    func testHeightForDayWithAnEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[0].proportionalHeight, 0.375)
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[1].proportionalHeight, 1)
    }

    func testWidthForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems[0].proportionalWidth, 0.3125)
        XCTAssertEqual(viewModelForTypicalDay.barItems[1].proportionalWidth, 0.5)
        XCTAssertEqual(viewModelForTypicalDay.barItems[2].proportionalWidth, 0.1875)
    }
    
    func testWidthForDayWithAnEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[0].proportionalWidth, 0.7)
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[1].proportionalWidth, 0.3)
    }

    func testColorForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems[0].color, UIColor.lipstick())
        XCTAssertEqual(viewModelForTypicalDay.barItems[1].color, UIColor.aquaMarine())
        XCTAssertEqual(viewModelForTypicalDay.barItems[2].color, UIColor.almostWhite())
    }

    func testColorForDayWithEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[0].color, UIColor.lipstick())
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[1].color, UIColor.almostWhite())
    }

    func testValueLabelModeForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems[0].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelLeft(text: "4"))
        XCTAssertEqual(viewModelForTypicalDay.barItems[1].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleWithHiddenLabel)
        XCTAssertEqual(viewModelForTypicalDay.barItems[2].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelRight(text: "7.2"))
    }

    func testValueLabelModeForDayWithEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[0].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelLeft(text: "Less than 3!"))
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[1].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelRight(text: "More than 8!"))
    }

    func testCountLabelText() {
        XCTAssertEqual(viewModelForMainChart.horizontalAxisCountLabelText, "16")
        XCTAssertEqual(viewModelForPreviousDayChart.horizontalAxisCountLabelText, "10")
    }

    func testHeaderAndSubheaderTextForMainChart() {
        XCTAssertEqual(viewModelForMainChart.headerText, "HARVEST BURN REPORT")
        XCTAssertEqual(viewModelForMainChart.subheaderText, "Monday 01.01.2001")
    }

    func testHeaderAndSubheaderTextForPreviousDayChart() {
        XCTAssertEqual(viewModelForPreviousDayChart.headerText, "Mon")
        XCTAssertEqual(viewModelForPreviousDayChart.subheaderText, "01.01.2001")
    }

    func testCreatingTheViewModelWithBillingStatsWithOnlyEmptyGroups() {
        let emptyGroups = BillingStatsGroup.allTypes().map { return BillingStatsGroup(type: $0, count: 0, averageHours: 0) }
        let emptyBillingStats = DailyBillingStats(day: NSDate(), groups: emptyGroups)

        XCTAssertNil(AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(emptyBillingStats))
    }
}


