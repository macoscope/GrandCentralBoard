//
//  HarvestWidgetSettings.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct HarvestWidgetSettings : Decodable {
    let accessToken: String
    let refreshToken: String
    let expirationDate: NSDate
    let refreshInterval: NSTimeInterval

    static func decode(json: AnyObject) throws -> HarvestWidgetSettings {
        let accessToken: String = try json => "accessToken"
        let refreshToken: String = try json => "refreshToken"
        let expirationTime: Double = try json => "expirationTime"
        let refreshInterval: Double = try json => "refreshInterval"
        let expirationDate = NSDate.init(timeIntervalSince1970: expirationTime)

        return HarvestWidgetSettings(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate, refreshInterval: refreshInterval)
    }

    var oauthCredentials: OAuthCredentials {
        return OAuthCredentials(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate)
    }
}
