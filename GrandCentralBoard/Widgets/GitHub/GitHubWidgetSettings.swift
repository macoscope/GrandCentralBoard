//
//  GitHubWidgetSettings.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 30.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Decodable

struct GitHubWidgetSettings {
    let accessToken: String
    let refreshInterval: NSTimeInterval
}

extension GitHubWidgetSettings: Decodable {

    static func decode(json: AnyObject) throws -> GitHubWidgetSettings {
        return try GitHubWidgetSettings(accessToken: json => "accessToken", refreshInterval: json => "refreshInterval")
    }
}
