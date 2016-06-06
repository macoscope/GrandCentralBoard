//
//  BillableDates.swift
//  GrandCentralBoard
//
//  Created by Maciek Grzybowski on 03.06.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


final class BillableDates {

    let dates: [NSDate]

    init(referenceDate: NSDate, numberOfPreviousDays: Int, includeWeekends: Bool?) {
        let calendar = NSCalendar.currentCalendar()

        var previousDays: [NSDate] = []
        var date = referenceDate

        while previousDays.count < numberOfPreviousDays {
            date = date.dateDaysAgo(1)

            if let includeWeekends = includeWeekends where includeWeekends == false {
                if !calendar.isDateInWeekend(date) {
                    previousDays.append(date)
                }

            } else {
                previousDays.append(date)
            }
        }

        dates = previousDays
    }
}
