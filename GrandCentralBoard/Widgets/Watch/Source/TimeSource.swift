//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable
import GrandCentralBoardCore


struct Time : Timed {
    let time: NSDate
    let timeZone: NSTimeZone
}

struct TimeSourceSettings : Decodable {
    let timeZone: NSTimeZone

    static func decode(jsonObject: AnyObject) throws -> TimeSourceSettings {
        return try TimeSourceSettings(timeZone: NSTimeZone(name: jsonObject => "timeZone") ?? NSTimeZone.defaultTimeZone())
    }
}

final class TimeSource : Synchronous {

    typealias ResultType = Result<Time>

    let interval: NSTimeInterval = 1
    let sourceType: SourceType = .Momentary

    private let timeZone: NSTimeZone

    init(settings: TimeSourceSettings) {
        self.timeZone = settings.timeZone
    }

    func read() -> ResultType {
        return .Success(Time(time: NSDate(), timeZone: timeZone))
    }
}