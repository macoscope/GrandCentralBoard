//
//  EventModel.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct DateFormattingError: ErrorType {
    let dateString: String
}

struct Event: Decodable {

    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()

    let name: String
    let time: NSDate

    static func decode(json: AnyObject) throws -> Event {
        let startString: String = try json => "start" => "dateTime"
        guard let startTime = Event.dateFormatter.dateFromString(startString) else {
            throw DateFormattingError(dateString: startString)
        }
        return try Event(name: json =>? "summary" ?? "-", time: startTime)
    }

    static func decodeArray(json: AnyObject) throws -> [Event] {
        return try [Event].decode(json => "items")
    }

    static func decodeArrayFromData(data: NSData) throws -> [Event] {
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
            return try Event.decodeArray(jsonResult)
        }

        throw EventsError.WrongFormat
    }
}
