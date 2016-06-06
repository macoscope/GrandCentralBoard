//
//  clockViewModel.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

struct AnalogClockWidgetViewModel {
    let hour: Int
    let minute: Int
    let second: Int

    let timeZoneCityName: String

    let dateString: String // From NSDateFormatter .LongStyle

    init(date: NSDate, timeZone: NSTimeZone) {
        let dateComponents = AnalogClockWidgetViewModel.componentsFromDate(date, timeZone: timeZone)
        hour = dateComponents.hour
        minute = dateComponents.minute
        second = dateComponents.second

        timeZoneCityName = AnalogClockWidgetViewModel.cityNameForTimeZone(timeZone)
        dateString = AnalogClockWidgetViewModel.stringForDate(date)
    }

    private static func cityNameForTimeZone(timeZone: NSTimeZone) -> String {
        return String(timeZone.name.characters.split("/")[1])
    }

    private static func componentsFromDate(date: NSDate, timeZone: NSTimeZone) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = timeZone
        return calendar.components([.Hour, .Minute, .Second], fromDate: date)
    }

    private static func stringForDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.locale = NSLocale.currentLocale()

        return dateFormatter.stringFromDate(date)
    }
}
