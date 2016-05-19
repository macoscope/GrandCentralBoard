//
//  DailyBillingStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct DailyBillingStats {
    let day: NSDate
    let billings: [DayEntry]
}

struct DayEntry: Decodable {
    let userID: Int
    let hours: Double

    static func decode(json: AnyObject) throws -> DayEntry {
        return try DayEntry(userID: json => "user_id", hours: json => "hours")
    }
}

private struct Day: Decodable {
    let date: NSDate

    static func decode(json: AnyObject) throws -> Day {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.dateFromString(try String.decode(json)) else {
            throw RawRepresentableInitializationError(type: self, rawValue: json, object: json)
        }

        return Day(date: date)
    }
}

extension DailyBillingStats: Decodable {
    static func decode(json: AnyObject) throws -> DailyBillingStats {
        var hoursForUserIDs = [Int: Double]()
        let entries: [DayEntry] = try json => "day_entries"
        let day: Day = try json => "for_day"

        for entry in entries {
            hoursForUserIDs[entry.userID] = (hoursForUserIDs[entry.userID] ?? 0) + entry.hours
        }

        let billings = hoursForUserIDs.map { (userID, hours) -> DayEntry in
            return DayEntry(userID: userID, hours: hours)
        }

        return DailyBillingStats(day: day.date, billings: billings)
    }
}
