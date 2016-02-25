//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

struct WatchWidgetViewModel {

    let time: String
    let timeZone: String
    let day: String
    let month: String

    init(date: NSDate, timeZone: NSTimeZone) {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone

        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = timeZone
        let comp = calendar.components([.Hour, .Minute, .Day, .Month], fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        let day = comp.day
        let month = comp.month

        self.time = "\(hour):\(minute)"
        self.timeZone = timeZone.name ?? ""
        self.day = "\(day)"
        self.month = "\(month)"
    }
}