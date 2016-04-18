//
//  BillingUserListTests.swift
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

        json = NSBundle(forClass: self.dynamicType).loadJSON("BillingUserList")
    }

    func testDecodingJSON() {
        do {
            let userIDs = try BillingUserList.decode(json).userIDs

            XCTAssertEqual(userIDs.count, 2)
            XCTAssertEqual(userIDs[0], 1265443)
            XCTAssertEqual(userIDs[1], 1261690)

        } catch _ {
            XCTFail("Failed to decode BillingUserList.json")
        }
    }
}
