//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


struct WatchWidgetViewModel {

    let watchFaceImage: UIImage?
    let centeredTimeText: String?
    let alignedTimeText: String?
    let eventText: NSAttributedString?


    init(date: NSDate, timeZone: NSTimeZone, event: Event? = nil, calendarName: String? = nil) {
        if let event = event {
            let timeToEvent = event.time.timeIntervalSinceDate(date)
            let minutesToEvent = Int(ceil(timeToEvent / 60)) // 10 seconds is "1 minute left"; 1 minute and 10 seconds is "2 minutes left"

            centeredTimeText = nil
            alignedTimeText = WatchWidgetViewModel.dateFormatterWithTimeZone(timeZone).stringFromDate(date)
            eventText = WatchWidgetViewModel.descriptionForEvent(event, fromCalendar: calendarName, startingInMinutes: minutesToEvent)
            watchFaceImage = WatchWidgetViewModel.watchFaceImageForEventStartingInMinutes(minutesToEvent)
        } else {
            centeredTimeText = WatchWidgetViewModel.dateFormatterWithTimeZone(timeZone).stringFromDate(date)
            alignedTimeText = nil
            eventText = nil
            watchFaceImage = nil
        }
    }

    private static func watchFaceImageForEventStartingInMinutes(minutesToEvent: Int) -> UIImage? {
        guard minutesToEvent > 0 else { return nil }

        let minutesInSlot = 5
        let numberOfSlots = 12
        let slotIndex = min(Int(ceil(Float(minutesToEvent) / Float(minutesInSlot))), numberOfSlots)

        return UIImage(named: "\(slotIndex)")
    }


    // MARK: Event description formatting

    private static let nextMeetingInFont = UIFont.systemFontOfSize(24, weight: UIFontWeightSemibold)
    private static let minutesFont = UIFont.systemFontOfSize(50, weight: UIFontWeightSemibold)
    private static let nowFont = UIFont.systemFontOfSize(50, weight: UIFontWeightSemibold)
    private static let calendarNameFont = UIFont.systemFontOfSize(22, weight: UIFontWeightBold)
    private static let eventNameFont = UIFont.systemFontOfSize(22, weight: UIFontWeightBold)
    private static let calendarNameTextColor = UIColor(red: 35/255, green: 208/255, blue: 165/255, alpha: 1)
    private static let highLineSpacingStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 34
        style.alignment = .Center
        return style
    }()
    private static let lowLineSpacingStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        style.alignment = .Center
        return style
    }()

    private static func descriptionForEvent(event: Event,
                                            fromCalendar calendarName: String?,
                                            startingInMinutes minutesToEvent: Int) -> NSAttributedString {
        let resultString = NSMutableAttributedString()

        if minutesToEvent > 0 {
            let nextMeetingIn = NSAttributedString(
                string: "NEXT MEETING IN" + "\n",
                attributes: [NSFontAttributeName : nextMeetingInFont, NSParagraphStyleAttributeName : lowLineSpacingStyle]
            )

            let minutes = NSMutableAttributedString(
                string: "\(minutesToEvent) MIN" + "\n",
                attributes: [NSFontAttributeName : minutesFont, NSParagraphStyleAttributeName : lowLineSpacingStyle]
            )
            resultString.appendAttributedString(nextMeetingIn)
            resultString.appendAttributedString(minutes)
        } else {
            let now = NSAttributedString(
                string: "NOW" + "\n",
                attributes: [NSFontAttributeName : nowFont, NSParagraphStyleAttributeName : highLineSpacingStyle]
            )
            resultString.appendAttributedString(now)
        }

        if let calendarName = calendarName {
            let calendarNameString = NSMutableAttributedString(
                string: "@\(calendarName.uppercaseString)" + "\n",
                attributes: [NSFontAttributeName : calendarNameFont, NSForegroundColorAttributeName : calendarNameTextColor]
            )
            resultString.appendAttributedString(calendarNameString)
        }

        let eventNameString = NSMutableAttributedString(
            string: event.name.uppercaseString,
            attributes: [NSFontAttributeName : eventNameFont]
        )
        resultString.appendAttributedString(eventNameString)

        return resultString
    }


    // MARK: Date formatting

    private static var cachedFormatter: NSDateFormatter?

    private static func dateFormatterWithTimeZone(timeZone: NSTimeZone) -> NSDateFormatter {
        if let formatter = cachedFormatter where formatter.timeZone == timeZone {
            return formatter
        }

        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        formatter.timeZone = timeZone
        cachedFormatter = formatter

        return formatter
    }
}
