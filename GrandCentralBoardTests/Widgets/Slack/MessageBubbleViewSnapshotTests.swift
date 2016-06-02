//
//  MessageBubbleViewSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 25.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import FBSnapshotTestCase
@testable import GrandCentralBoard


final class MessageBubbleViewSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testMessageBubbleShortText() {
        let view = MessageBubbleView()
        view.frame = CGRect(x: 0, y:0, width: 520, height: 400)
        view.backgroundColor = .blackColor()

        view.text = "Short text"

        FBSnapshotVerifyView(view)
    }

    func testMessageBubbleMediumText() {
        let view = MessageBubbleView()
        view.frame = CGRect(x: 0, y:0, width: 520, height: 400)
        view.backgroundColor = .blackColor()

        view.text = "Hi, I just wanted to say I love GrandCentralBoard, it is the nicest thing to happen on TV since color TV"

        FBSnapshotVerifyView(view)
    }

    func testMessageBubbleLongText() {
        let view = MessageBubbleView()
        view.frame = CGRect(x: 0, y:0, width: 520, height: 400)
        view.backgroundColor = .blackColor()

        view.text = "Hi, this is just a message from our developers with a long long long long long long long long long " +
                    "long long long long long long long long long long long long long long long long long long long text"

        FBSnapshotVerifyView(view)
    }
}
