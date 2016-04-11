//
//  HarvestWidgetSettings.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct HarvestWidgetSettings: Decodable {
    let accessToken: String
    let refreshToken: String
    let expirationDate: NSDate
    let refreshInterval: NSTimeInterval

    static func decode(json: AnyObject) throws -> HarvestWidgetSettings {
        let accessToken = try json => "accessToken" as! String
        let refreshToken = try json => "accessToken" as! String
        let expirationTime = (try json => "expirationTime" as! NSNumber).doubleValue
        let refreshInterval = (try json => "refreshInterval" as! NSNumber).doubleValue
        let expirationDate = NSDate.init(timeIntervalSince1970: expirationTime)

        return HarvestWidgetSettings(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate, refreshInterval: refreshInterval)
    }

    var oauthCredentials: OAuthCredentials {
        return OAuthCredentials(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate)
    }
}
