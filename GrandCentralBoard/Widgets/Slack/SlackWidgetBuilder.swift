//
//  SlackWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GrandCentralBoardCore


final class SlackWidgetBuilder: WidgetBuilding {

    let name: String = "slack"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let slackSettings = try SlackWidgetSettings.decode(settings)
        let source = SlackSource(apiToken: slackSettings.apiToken)

        return SlackMessagesWidget(source: source)
    }
}
