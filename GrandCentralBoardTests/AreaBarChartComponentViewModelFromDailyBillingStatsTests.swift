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
        BillingStatsGroup(type: .Less, count: 5, averageHours: 4.5),
        BillingStatsGroup(type: .Normal, count: 8, averageHours: 6.4),
        BillingStatsGroup(type: .More, count: 3, averageHours: 8.2)])
    static let dailyBillingStatsWithEmptyGroup = DailyBillingStats(day: NSDate(timeIntervalSinceReferenceDate: 0), groups: [
        BillingStatsGroup(type: .Less, count: 7, averageHours: 3.2),
        BillingStatsGroup(type: .Normal, count: 0, averageHours: 0),
        BillingStatsGroup(type: .More, count: 3, averageHours: 8.2)])
    let viewModelForTypicalDay = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(typicalDailyBillingStats)!
    let viewModelForDayWithEmptyGroup = AreaBarChartComponentViewModel.viewModelFromDailyBillingStats(dailyBillingStatsWithEmptyGroup)!

    func testItemCountForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems.count, 3)
    }

    func testItemCountForDayWithAnEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems.count, 2)
    }

    func testHeightForTypicalDay() {
        XCTAssertEqual(viewModelForTypicalDay.barItems[0].proportionalHeight, 0.5625)
        XCTAssertEqual(viewModelForTypicalDay.barItems[1].proportionalHeight, 0.8)
        XCTAssertEqual(viewModelForTypicalDay.barItems[2].proportionalHeight, 1)
    }

    func testHeightForDayWithAnEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[0].proportionalHeight, 0.4)
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
        XCTAssertEqual(viewModelForTypicalDay.barItems[0].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelLeft(text: "4.5"))
        XCTAssertEqual(viewModelForTypicalDay.barItems[1].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleWithHiddenLabel)
        XCTAssertEqual(viewModelForTypicalDay.barItems[2].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelRight(text: "8.2"))
    }

    func testValueLabelModeForDayWithEmptyGroup() {
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[0].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelLeft(text: "3.2"))
        XCTAssertEqual(viewModelForDayWithEmptyGroup.barItems[1].valueLabelMode, AreaBarItemValueLabelDisplayMode.VisibleLabelRight(text: "8.2"))
    }

    func testCountLabelText() {
        XCTAssertEqual(viewModelForTypicalDay.horizontalAxisCountLabelText, "16")
        XCTAssertEqual(viewModelForDayWithEmptyGroup.horizontalAxisCountLabelText, "10")
    }

    func testHeaderText() {
        XCTAssertEqual(viewModelForTypicalDay.headerText, "HARVEST BURN REPORT")
    }

    func testSubheaderText() {
        XCTAssertEqual(viewModelForTypicalDay.subheaderText, "Monday 01.01.2001")
    }
}


