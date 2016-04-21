//
//  NSDate.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

private let yearMonthDayFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter
}()

extension NSDate {
    func yearMonthDayStringForNetwork() -> String {
        return yearMonthDayFormatter.stringFromDate(self)
    }
}

extension NSDate {
    func dateMinusDays(days: Int) -> NSDate? {
        let dateComponents = NSDateComponents()
        dateComponents.day = -days
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: [])
    }

    func dateWith(hour hour: Int, minute: Int, second: Int) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: self)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        return calendar.dateFromComponents(dateComponents)
    }
}
