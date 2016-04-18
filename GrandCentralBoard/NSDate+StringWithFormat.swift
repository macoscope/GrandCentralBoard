//
//  NSDate+StringWithFormat.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


extension NSDate {
    func stringWithFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = format

        return formatter.stringFromDate(self)
    }
}