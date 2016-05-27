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
    let avatarProvider = AvatarProvider()

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
        guard let text = message.text, channelName = message.channel, authorID = message.user,
            author = slackClient.users[authorID], authorName = author.name, channel = slackClient.channels[channelName]
            where text.containsAnyString(searchedTags) else {
            return
        }

        let timestamp = message.ts?.slackMessageTimestamp() ?? NSDate()
        let formattedText = text.stringByRemovingOccurrencesOfStrings(searchedTags).trim()

        var avatarImageObservable: Observable<UIImage!>
        if let avatarPath = author.profile?.image192, avatarURL = NSURL(string: avatarPath) {
            avatarImageObservable = avatarProvider.avatarWithURL(avatarURL)
        } else {
            avatarImageObservable = Observable.just(nil)
        }


        let subscriptionBlock = self.subscriptionBlock
        avatarImageObservable.map { SlackMessage(text: formattedText, timestamp: timestamp, author: authorName, channel: channel.name, avatar: $0) }
        .observeOn(MainScheduler.instance).subscribe {
            switch $0 {
            case .Next(let message): subscriptionBlock?(message)
            case .Error(let error): assertionFailure("\(error)")
            case .Completed: break
            }
        }
        .addDisposableTo(disposeBag)
    }
}
