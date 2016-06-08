//
//  Slack+DataProviding.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 30.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import SlackKit


protocol SlackDataProviding {
    func userNameForUserID(id: String) -> String?
    func userAvatarPathForUserID(id: String) -> String?
    func channelNameForChannelID(id: String) -> String?
}

extension Client: SlackDataProviding {

    func userNameForUserID(id: String) -> String? {
        return users[id]?.name
    }

    func userAvatarPathForUserID(id: String) -> String? {
        return users[id]?.profile?.image192
    }

    func channelNameForChannelID(id: String) -> String? {
        return channels[id]?.name
    }
}

protocol SlackMessageReceiving: MessageEventsDelegate {}

extension SlackMessageReceiving {
    func messageSent(message: Message) {}
    func messageChanged(message: Message) {}
    func messageDeleted(message: Message?) {}
}
