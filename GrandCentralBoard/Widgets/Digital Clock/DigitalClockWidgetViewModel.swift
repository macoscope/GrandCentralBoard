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
    let timeZoneCityName: String

    init(date: NSDate, timeZone: NSTimeZone) {
        timeString = DigitalClockWidgetViewModel.stringForDate(date)
        timeZoneCityName = DigitalClockWidgetViewModel.zoneNameForTimeZone(timeZone)
    }

    private static func zoneNameForTimeZone(timeZone: NSTimeZone) -> String {
        return String(timeZone.name.characters.split("/")[1])
    }
    
    private static func stringForDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.locale = NSLocale.currentLocale()
        
        return dateFormatter.stringFromDate(date)
    }
}
