//
//  SlackTimestampParseTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
import Nimble


final class SlackTimestampParseTests: XCTestCase {

    func testTimestampParsing() {
        let timestamp = 121237888
        let slackTimestamp = "\(timestamp).00123"

        let date = slackTimestamp.slackMessageTimestamp()!
        expect(date.timeIntervalSince1970).to(beCloseTo(timestamp))
    }
}
