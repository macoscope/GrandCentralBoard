//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


struct WatchWidgetViewModel {

    let hourLeft: String?
    let hourRight: String?
    let meetingName: String?
    let meetingETA: String?
    let startsIn: String?
    let watchFaceImage: UIImage?
    let calendarName: String?

    init(date: NSDate, timeZone: NSTimeZone, event: Event?, calendarName: String?) {

        if let event = event {
            let minutes = Int(event.time.timeIntervalSinceDate(date) / 60)
            let isNow = minutes <= 1
            meetingName = event.name
            startsIn = isNow ? "is" : "starts in"
            meetingETA = isNow ? "now" : "\(minutes) minutes"
        } else {
            meetingName = nil
            meetingETA = nil
            startsIn = nil
        }

        let currentTimeComponents = WatchWidgetViewModel.componentsFromDate(date, timeZone: timeZone)

        let blinking = (currentTimeComponents.minute / 5) + 1

        watchFaceImage = UIImage(named: "f\(blinking)")

        if currentTimeComponents.minute < 30 {
            hourLeft = nil
            hourRight = "\(currentTimeComponents.hour % 24)"
        } else {
            hourLeft = "\(currentTimeComponents.hour + 1 % 24)"
            hourRight = nil
        }

        self.calendarName = calendarName?.uppercaseString
    }

    private static func componentsFromDate(date: NSDate, timeZone: NSTimeZone) -> (hour: Int, minute: Int) {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = timeZone
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minute = components.minute

        return (hour: hour, minute: minute)
    }
}
