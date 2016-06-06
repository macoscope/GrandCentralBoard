//
//  clockViewModel.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

struct DigitalClockWidgetViewModel {
    let timeString: String
    let dateString: String
    let timeZoneCityName: String

    private static let timeFormatter: NSDateFormatter = {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss a"
        timeFormatter.locale = NSLocale.currentLocale()

        return timeFormatter
    }()

    private static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        dateFormatter.locale = NSLocale.currentLocale()

        return dateFormatter
    }()

    init(date: NSDate, timeZone: NSTimeZone) {
        timeString = DigitalClockWidgetViewModel.timeFormatter.stringFromDate(date)
        dateString = DigitalClockWidgetViewModel.dateFormatter.stringFromDate(date)
        timeZoneCityName = DigitalClockWidgetViewModel.zoneNameForTimeZone(timeZone)
    }

    private static func zoneNameForTimeZone(timeZone: NSTimeZone) -> String {
        let string = timeZone.name.characters.split("/").map(String.init).last
        return string!
    }
}
