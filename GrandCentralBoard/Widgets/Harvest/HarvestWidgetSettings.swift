//
//  HarvestWidgetSettings.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct HarvestWidgetSettings : Decodable {
    let account: String
    let refreshToken: String
    let clientID: String
    let clientSecret: String
    let refreshInterval: NSTimeInterval

    static func decode(json: AnyObject) throws -> HarvestWidgetSettings {
        return try HarvestWidgetSettings(account:         json => "account",
                                         refreshToken:    json => "refreshToken",
                                         clientID:        json => "clientID",
                                         clientSecret:    json => "clientSecret",
                                         refreshInterval: json => "refreshInterval")
    }

    var oauthCredentials: OAuthCredentials {
        return OAuthCredentials(accessToken: AccessToken(token: "", expiresIn: 0), refreshToken: refreshToken, clientID: clientID, clientSecret: clientSecret)
    }
}
