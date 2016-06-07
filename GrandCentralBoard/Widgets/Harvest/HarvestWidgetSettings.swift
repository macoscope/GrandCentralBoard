//
//  HarvestWidgetSettings.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable
import Alamofire
import GCBUtilities

struct HarvestWidgetSettings: Decodable {
    let account: String
    let refreshToken: String
    let clientID: String
    let clientSecret: String
    let numberOfDays: Int
    let includeWeekends: Bool?
    let refreshInterval: NSTimeInterval
    let downloader: NetworkRequestManager = Alamofire.Manager.sharedInstance

    static func decode(json: AnyObject) throws -> HarvestWidgetSettings {
        return try HarvestWidgetSettings(account:         json => "account",
                                         refreshToken:    json => "refreshToken",
                                         clientID:        json => "clientID",
                                         clientSecret:    json => "clientSecret",
                                         numberOfDays:    json => "numberOfDays",
                                         includeWeekends: json =>? "includeWeekends",
                                         refreshInterval: json => "refreshInterval")
    }

    var refreshCredentials: TokenRefreshCredentials {
        return TokenRefreshCredentials(refreshToken: refreshToken, clientID: clientID, clientSecret: clientSecret)
    }
}
