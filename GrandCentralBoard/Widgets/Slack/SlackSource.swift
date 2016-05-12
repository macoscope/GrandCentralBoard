//
//  SlackSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore
import SlackKit
import RxSwift


final class SlackSource: Subscribable, MessageEventsDelegate {
    typealias ResultType = SlackMessage
    var subscriptionBlock: ((SlackMessage) -> Void)?

    var interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    let slackClient: Client

    private let disposeBag = DisposeBag()

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
        guard let text = message.text, channel = message.channel, author = message.user
            where text.containsAnyString(searchedTags) else {
            return
        }

        let timestamp = message.ts?.slackMessageTimestamp() ?? NSDate()
        let formattedText = text.stringByRemovingOccurrencesOfStrings(searchedTags).trim()
        let slackClient = self.slackClient

        let userInfoObservable = slackClient.webAPI.userInfo(author)
        let channelInfoObservable = slackClient.webAPI.channelInfo(channel)

        Observable.zip(userInfoObservable, channelInfoObservable) { (userInfo: User, channelInfo: Channel) -> SlackMessage in
            SlackMessage(text: formattedText, timestamp: timestamp, channel: channelInfo.name,
                author: userInfo.name, avatarPath: userInfo.profile?.image192)
        }.subscribeNext({ [weak self] message in
            dispatch_async(dispatch_get_main_queue(), {
                self?.subscriptionBlock?(message)
            })
        }).addDisposableTo(disposeBag)
    }
}
