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

        validJSON = readJSONFromBundle("DailyBillingStats")
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

    func readJSONFromBundle(name: String) -> AnyObject {
        do {
            let url = NSBundle(forClass: self.dynamicType).URLForResource(name, withExtension: "json")
            let data = NSData(contentsOfURL: url!)

            return try NSJSONSerialization.JSONObjectWithData(data!, options: [])

        } catch {
            XCTFail("Couldn't load " + name + ".json from the application bundle")

            return [:]
        }
    }
}
