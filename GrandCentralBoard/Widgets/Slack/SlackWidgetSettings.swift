//
//  SlackWidgetSettings.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Decodable


struct SlackWidgetSettings {
    let apiToken: String
}

extension SlackWidgetSettings: Decodable {

    static func decode(json: AnyObject) throws -> SlackWidgetSettings {
        return try SlackWidgetSettings(apiToken: json => "apiToken")
    }
}
