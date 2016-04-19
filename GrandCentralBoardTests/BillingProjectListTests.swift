//
//  BillingProjectListTests.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
@testable import GrandCentralBoard


class BillingProjectListTests: XCTestCase {
    var json: AnyObject = [:]

    override func setUp() {
        super.setUp()

        json = NSBundle(forClass: self.dynamicType).loadJSON("BillingProjectList")
    }

    func testDecodingJSON() {
        do {
            let projectIDs = try BillingProjectList.decode(json).projectIDs

            XCTAssertEqual(projectIDs.count, 3)
            XCTAssertEqual(projectIDs[0], 10516006)
            XCTAssertEqual(projectIDs[1], 10516010)
            XCTAssertEqual(projectIDs[2], 10516017)

        } catch _ {
            XCTFail("Failed to decode BillingProjectList.json")
        }
    }
}
