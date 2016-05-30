//
//  SlackSourceTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Nimble
import SlackKit
@testable import GrandCentralBoard


final class SlackSourceTests: XCTestCase {

    private let channelName = "test_channel_name"
    private var channelResponse: AnyObject { return [
        "ok": true, "channel": [
            "name": channelName
        ]
    ]}

    private let userName = "test_user_name"
    private let avatarPath = "http://image.url"
    private var userResponse: AnyObject { return [
        "ok": true, "user": [
            "name": userName,
            "profile": [
                "image_192": avatarPath
            ]
        ]
    ]}

    override func setUp() {
        stub(isPath("/api/users.info")) { _ -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(JSONObject: self.userResponse, statusCode: 200, headers: nil)
        }

        stub(isPath("/api/channels.info")) { _ -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(JSONObject: self.channelResponse, statusCode: 200, headers: nil)
        }
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }

    func testSlackMessageIsComplete() {
        let source = SlackSource(apiToken: "")
        let timestamp = NSDate().timeIntervalSince1970
        let messageTimestamp = "\(Int(timestamp)).0001"
        let messageText = "<!here> test_message_text"
        let fakeMessage = Message(message: [
            "ts": messageTimestamp,
            "user": "user_id",
            "channel": "channel_id",
            "text": messageText
            ])!

        waitUntil { done in
            source.subscriptionBlock = { message in
                expect(message.text) == messageText.stringByReplacingOccurrencesOfString("<!here> ", withString: "")
                expect(message.timestamp.timeIntervalSince1970).to(beCloseTo(timestamp, within: 1.0))
                expect(message.author) == self.userName
                expect(message.channel) == self.channelName
                done()
            }
            source.messageReceived(fakeMessage)
        }
    }
}
