//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

struct WatchWidgetViewModel {

    let hourLeft: String?
    let hourRight: String?
    let blinkingImage: UIImage?
    let watchFaceImage: UIImage?

    init(date: NSDate, timeZone: NSTimeZone) {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone

        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = timeZone
        let comp = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = comp.hour
        let minute = comp.minute

        let blinking = (minute / 5) + 1

        blinkingImage = UIImage(named: "\(blinking)")
        watchFaceImage = UIImage(named: "f\(blinking)")

        if minute < 30 {
            hourLeft = nil
            hourRight = "\(hour)"
        } else {
            hourLeft = "\(hour + 1 % 24)"
            hourRight = nil
        }

    }
}