//
//  EventModel.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 07.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable

struct DateFormattingError : ErrorType {
    let dateString: String
}

struct EventModel : Decodable {

    private static let dateFormatter: NSDateFormatter =  {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
        return formatter
    }()

    let name: String
    let startTime: NSDate

    static func decode(json: AnyObject) throws -> EventModel {
        let startString: String = try json => "start" => "dateTime"
        guard let startTime = EventModel.dateFormatter.dateFromString(startString) else {
            throw DateFormattingError(dateString: startString)
        }
        return try EventModel(name: json => "summary", startTime: startTime)
    }

    static func decodeArray(json: AnyObject) throws -> [EventModel] {
        return try [EventModel].decode(json => "items")
    }
}

