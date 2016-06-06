//
//  String+SlackTimestampParsing.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Foundation

extension String {

    func slackMessageTimestamp() -> NSDate? {
        guard let timestampString = componentsSeparatedByString(".").first, timeInterval = NSTimeInterval(timestampString) else {
            return nil
        }
        return NSDate(timeIntervalSince1970: timeInterval)
    }
}
