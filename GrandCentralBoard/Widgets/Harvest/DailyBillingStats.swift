//
//  HarvestTeamStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct DailyBillingStats {
    let day: NSDate
    let groups: [BillingStatsGroup]
}


extension DailyBillingStats {
    static func emptyStats(day: NSDate = NSDate()) -> DailyBillingStats {
        return DailyBillingStats(day: day, groups: BillingStatsGroup.allTypes().map { BillingStatsGroup(type: $0, count: 0, averageHours: 0) })
    }

    func merge(dailyBillingStats: DailyBillingStats) -> DailyBillingStats {
        let types = BillingStatsGroup.allTypes()
        let indexes = 0..<types.count

        let groups = indexes.map { index -> BillingStatsGroup in
            let group1 = self.groups[index]
            let group2 = dailyBillingStats.groups[index]
            let count = group1.count + group2.count
            let totalHours = group1.averageHours * Double(group1.count) + group2.averageHours * Double(group2.count)
            let averageHours = totalHours / max(1.0, Double(count))
            let type = types[index]

            return BillingStatsGroup(type: type, count: count, averageHours: averageHours)
        }

        return DailyBillingStats(day: day, groups: groups)
    }
}


extension DailyBillingStats : Decodable {
    static func decode(json: AnyObject) throws -> DailyBillingStats {
        var hoursForUserIDs = [Int: Double]()
        let entries: [DayEntry] = try json => "day_entries"
        let day: Day = try json => "for_day"

        for entry in entries {
            hoursForUserIDs[entry.userID] = (hoursForUserIDs[entry.userID] ?? 0) + entry.hours
        }

        var countsForTypes = [BillingStatsGroupType: Int]()
        var hoursForTypes = [BillingStatsGroupType: Double]()

        for hours in hoursForUserIDs.values {
            let type = BillingStatsGroup.typeForHours(hours)

            countsForTypes[type] = (countsForTypes[type] ?? 0) + 1
            hoursForTypes[type] = (hoursForTypes[type] ?? 0.0) + hours
        }

        var groups = [BillingStatsGroup]()

        for type in BillingStatsGroup.allTypes() {
            let count = countsForTypes[type] ?? 0
            let hours = hoursForTypes[type] ?? 0.0
            let averageHours = hours / Double(max(count, 1))

            let group = BillingStatsGroup(type: type, count: count, averageHours: averageHours)

            groups.append(group)
        }

        return DailyBillingStats(day: day.date, groups: groups)
    }

    private struct DayEntry: Decodable {
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
}
