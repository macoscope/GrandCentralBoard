//
//  AnalogClockSource.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

import Decodable
import GCBCore


/**
 *  { settings: { "timeZone": "America/Detroit"} }
 *  Available Timezones here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
 */
struct AnalogAnalogClockSourceSettings: Decodable {
    let timeZone: NSTimeZone

    static func decode(jsonObject: AnyObject) throws -> AnalogAnalogClockSourceSettings {
        return try AnalogAnalogClockSourceSettings(timeZone: NSTimeZone(name: jsonObject => "timeZone") ??
            NSTimeZone.defaultTimeZone())
    }
}

final class AnalogClockSource: Synchronous {

    typealias ResultType = Result<Time>

    let interval: NSTimeInterval = 1
    let sourceType: SourceType = .Momentary

    private let timeZone: NSTimeZone

    init(settings: AnalogAnalogClockSourceSettings) {
        self.timeZone = settings.timeZone
    }

    func read() -> ResultType {
        return .Success(Time(time: NSDate(), timeZone: timeZone))
    }
}
