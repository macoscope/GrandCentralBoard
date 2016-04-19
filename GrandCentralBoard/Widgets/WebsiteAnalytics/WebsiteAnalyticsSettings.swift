//
//  WebsiteAnalyticsSettings.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 18.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct WebsiteAnalyticsSettings  {
    let viewID: String
    let daysInReport: Int
    let validPathPrefix: String?

    let clientID: String
    let clientSecret: String
    let refreshToken: String
    
    let refreshInterval: Int
}

extension WebsiteAnalyticsSettings: Decodable {
    static func decode(jsonObject: AnyObject) throws -> WebsiteAnalyticsSettings {
        return try WebsiteAnalyticsSettings(viewID: jsonObject => "viewID",
                                            daysInReport: jsonObject => "daysInReport",
                                            validPathPrefix: jsonObject =>? "validPathPrefix",
                                            clientID: jsonObject => "clientID",
                                            clientSecret: jsonObject => "clientSecret",
                                            refreshToken: jsonObject => "refreshToken",
                                            refreshInterval: jsonObject => "refreshInterval")
    }
}
