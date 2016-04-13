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
    func yearMonthDayString() -> String {
        return yearMonthDayFormatter.stringFromDate(self)
    }
}
