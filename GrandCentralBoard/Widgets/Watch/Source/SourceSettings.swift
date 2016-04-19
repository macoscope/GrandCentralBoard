//
//  GoogleCalendarSourceSettings.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct GoogleCalendarSourceSettings: Decodable {
    let calendarID: String
    let clientID: String
    let clientSecret: String
    let refreshToken: String

    static func decode(jsonObject: AnyObject) throws -> GoogleCalendarSourceSettings {
        return try GoogleCalendarSourceSettings(calendarID: jsonObject => "calendarID",
                                                clientID: jsonObject => "clientID",
                                                clientSecret: jsonObject => "clientSecret",
                                                refreshToken: jsonObject => "refreshToken")
    }
}

struct EventsSourceSettings: Decodable {
    let calendarPath: String

    static func decode(json: AnyObject) throws -> EventsSourceSettings {
        return try EventsSourceSettings(calendarPath: json => "calendar")
    }
}
