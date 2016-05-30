//
//  SlackSourceTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import XCTest
import Nimble
import SlackKit
@testable import GrandCentralBoard


private struct TestSlackClient: SlackDataProviding {
    let author, avatar, channel: String?

    func userNameForUserID(id: String) -> String? { return author }
    func userAvatarPathForUserID(id: String) -> String? { return avatar }
    func channelNameForChannelID(id: String) -> String? { return channel}
}

final class SlackSourceTests: XCTestCase {

    func testSlackMessageIsComplete() {
        let channelName = "test_channel_name"
        let userName = "test_user_name"
        let avatarPath = "http://image.url"

        let client = TestSlackClient(author: userName, avatar: avatarPath, channel: channelName)

        let source = SlackSource(slackClient: client)
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
                expect(message.author) == userName
                expect(message.channel) == channelName
                expect(message.avatarPath) == avatarPath
                done()
            }
            source.messageReceived(fakeMessage)
        }
    }
}
