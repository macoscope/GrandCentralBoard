//
//  Slack+TimestampParsing.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

extension String {

    func slackMessageTimestamp() -> NSDate? {
        if let timestampString = self.componentsSeparatedByString(".").first, let timeInterval = NSTimeInterval(timestampString) {
            return NSDate(timeIntervalSince1970: timeInterval)
        } else {
            return nil
        }
    }
}
