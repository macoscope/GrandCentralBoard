//
//  SlackWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore
import SlackKit


final class SlackWidgetBuilder: WidgetBuilding {

    let name: String = "slack"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let slackSettings = try SlackWidgetSettings.decode(settings)
        let slackClient = Client(apiToken: slackSettings.apiToken)
        let source = SlackSource(slackClient: slackClient)

        slackClient.messageEventsDelegate = source
        slackClient.connect(noUnreads: true, pingInterval: 10, timeout: 20, reconnect: true)

        return SlackMessagesWidget(source: source)
    }
}
