//
//  DailyBillingStatsTests.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-13.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard


class DailyBillingStatsTests: XCTestCase {
    var validJSON: AnyObject = [:]
    var dateFormatter = NSDateFormatter()

    override func setUp() {
        super.setUp()

        validJSON = NSBundle(forClass: self.dynamicType).loadJSON("DailyBillingStats")
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDecodingFromValidJSON() throws {
        let stats = try DailyBillingStats.decode(validJSON)

        XCTAssertEqual(dateFormatter.stringFromDate(stats.day), "2016-04-13")
        XCTAssertEqual(stats.groups.count, 3)

        XCTAssertEqual(stats.groups[0].type, BillingStatsGroupType.Less)
        XCTAssertEqual(stats.groups[0].count, 0)
        XCTAssertEqualWithAccuracy(stats.groups[0].averageHours, 0, accuracy: 0.001)

        XCTAssertEqual(stats.groups[1].type, BillingStatsGroupType.Normal)
        XCTAssertEqual(stats.groups[1].count, 2)
        XCTAssertEqualWithAccuracy(stats.groups[1].averageHours, 6.45, accuracy: 0.001)

        XCTAssertEqual(stats.groups[2].type, BillingStatsGroupType.More)
        XCTAssertEqual(stats.groups[2].count, 1)
        XCTAssertEqualWithAccuracy(stats.groups[2].averageHours, 7.9, accuracy: 0.001)
    }

    func testMerging() {
        let stats1 = DailyBillingStats(day: NSDate(), groups: [
            BillingStatsGroup(type: .Less, count: 10, averageHours: 3.5),
            BillingStatsGroup(type: .Normal, count: 2, averageHours: 6.4),
            BillingStatsGroup(type: .More, count: 5, averageHours: 7.2)])
        let stats2 = DailyBillingStats(day: NSDate(), groups: [
            BillingStatsGroup(type: .Less, count: 2, averageHours: 4.4),
            BillingStatsGroup(type: .Normal, count: 3, averageHours: 6.65),
            BillingStatsGroup(type: .More, count: 5, averageHours: 10)])

        let mergedStats = stats1.merge(stats2)

        XCTAssertEqual(mergedStats.day, stats1.day)
        XCTAssertEqual(mergedStats.groups.count, 3)
        XCTAssertEqual(mergedStats.groups[0].type, BillingStatsGroupType.Less)
        XCTAssertEqual(mergedStats.groups[0].count, 12)
        XCTAssertEqual(mergedStats.groups[0].averageHours, 3.65)
        XCTAssertEqual(mergedStats.groups[1].type, BillingStatsGroupType.Normal)
        XCTAssertEqual(mergedStats.groups[1].count, 5)
        XCTAssertEqual(mergedStats.groups[1].averageHours, 6.55)
        XCTAssertEqual(mergedStats.groups[2].type, BillingStatsGroupType.More)
        XCTAssertEqual(mergedStats.groups[2].count, 10)
        XCTAssertEqual(mergedStats.groups[2].averageHours, 8.6)
    }

    func testMergingEmptyStats() {
        let mergedStats = DailyBillingStats.emptyStats().merge(DailyBillingStats.emptyStats())

        XCTAssertEqual(mergedStats.groups.count, 3)
        XCTAssertEqual(mergedStats.groups[0].type, BillingStatsGroupType.Less)
        XCTAssertEqual(mergedStats.groups[0].count, 0)
        XCTAssertEqual(mergedStats.groups[0].averageHours, 0)
        XCTAssertEqual(mergedStats.groups[1].type, BillingStatsGroupType.Normal)
        XCTAssertEqual(mergedStats.groups[1].count, 0)
        XCTAssertEqual(mergedStats.groups[1].averageHours, 0)
        XCTAssertEqual(mergedStats.groups[2].type, BillingStatsGroupType.More)
        XCTAssertEqual(mergedStats.groups[2].count, 0)
        XCTAssertEqual(mergedStats.groups[2].averageHours, 0)
    }
}
