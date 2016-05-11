//
//  SlackSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore
import SlackKit


private extension String {

    func slackMessageTimestamp() -> NSDate? {
        if let timestampString = self.componentsSeparatedByString(".").first, let timeInterval = NSTimeInterval(timestampString) {
            return NSDate(timeIntervalSinceReferenceDate: timeInterval)
        } else {
            return nil
        }
    }
}

final class SlackSource: Subscribable, MessageEventsDelegate {
    typealias ResultType = SlackMessage
    var subscriptionBlock: ((SlackMessage) -> Void)?

    var interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    let slackClient: Client

    init(apiToken: String) {
        slackClient = Client(apiToken: apiToken)
        slackClient.messageEventsDelegate = self
        slackClient.connect(noUnreads: true, reconnect: true)
    }

    // MARK: MessageEventsDelegate

    func messageSent(message: Message) {}
    func messageChanged(message: Message) {}
    func messageDeleted(message: Message?) {}

    func messageReceived(message: Message) {
        let searchedTags = ["<!here|@here>", "<!here>", "<!channel>", "<!everyone>"]
        guard let text = message.text where text.containsAnyString(searchedTags) else {
            return
        }

        let timestamp = message.ts?.slackMessageTimestamp() ?? NSDate()
        let slackMessage = SlackMessage(text: text.stringByRemovingOccurrencesOfStrings(searchedTags), timestamp: timestamp)
        subscriptionBlock?(slackMessage)
    }
}
