//
//  SlackSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore
import SlackKit


final class SlackSource: Subscribable, SlackMessageReceiving {
    typealias ResultType = SlackMessage
    var subscriptionBlock: ((SlackMessage) -> Void)?

    var interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    let slackClient: SlackDataProviding

    init(slackClient: SlackDataProviding) {
        self.slackClient = slackClient
    }

    // MARK: SlackMessageReceiving

    func messageReceived(message: Message) {
        let searchedTags = ["<!here|@here>", "<!here>", "<!channel>", "<!everyone>"]
        guard let text = message.text, channelID = message.channel, authorID = message.user,
            author = slackClient.userNameForUserID(authorID), channel = slackClient.channelNameForChannelID(channelID)
            where text.containsAnyString(searchedTags) else {
            return
        }

        let timestamp = message.ts?.slackMessageTimestamp() ?? NSDate()
        let formattedText = text.stringByRemovingOccurrencesOfStrings(searchedTags).trim()

        let message = SlackMessage(text: formattedText, timestamp: timestamp, author: author,
                                   channel: channel, avatarPath: slackClient.userAvatarPathForUserID(authorID))
        subscriptionBlock?(message)
    }
}
