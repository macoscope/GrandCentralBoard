//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

struct Time : Timed {
    let time: NSDate
    let timeZone: NSTimeZone
}

final class TimeSource : Synchronous {

    typealias ResultType = Result<Time>

    let optimalInterval: NSTimeInterval = 1
    let sourceType: SourceType = .Momentary

    private let timeZone: NSTimeZone

    init(zone: NSTimeZone) {
        self.timeZone = zone
    }

    func read() -> ResultType {
        return .Success(Time(time: NSDate(), timeZone: timeZone))
    }
}