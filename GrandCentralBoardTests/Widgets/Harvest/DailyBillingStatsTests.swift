//
//  DailyBillingStatsTests.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-13.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
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

    private let userHoursInJSON = [
        1261690: 7.9,
        11111: 6.5,
        22222: 6.4
    ]

    func testDecodingFromValidJSON() throws {
        let stats = try DailyBillingStats.decode(validJSON)

        XCTAssertEqual(dateFormatter.stringFromDate(stats.day), "2016-04-13")
        stats.billings.forEach { (entry) in
            expect(entry.hours).to(beCloseTo(userHoursInJSON[entry.userID]!))
        }
    }
}
