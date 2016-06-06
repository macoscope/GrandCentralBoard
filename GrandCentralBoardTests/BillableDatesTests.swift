//
//  BillableDatesTests.swift
//  GrandCentralBoard
//
//  Created by Maciek Grzybowski on 03.06.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
@testable import GrandCentralBoard


class BillableDatesTests: XCTestCase {

    func testOneDaySetting() {
        let someMonday = dateFromDay(30, month: 5, year: 2016)
        let sundayBeforeSomeMonday = dateFromDay(29, month: 5, year: 2016)
        let fridayBeforeSomeMonday = dateFromDay(27, month: 5, year: 2016)

        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let billableDatesIncludingWeekend = calendar.previousDays(1, beforeDate: someMonday, ignoreWeekends: false)
        let billableDatesExcludingWeekend = calendar.previousDays(1, beforeDate: someMonday, ignoreWeekends: true)

        expect(billableDatesIncludingWeekend) == [sundayBeforeSomeMonday]
        expect(billableDatesExcludingWeekend) == [fridayBeforeSomeMonday]
    }

    func testMultipleDaysSetting() {
        let someWednesday = dateFromDay(1, month: 6, year: 2016)
        let sixDaysBeforeSomeWednesday = [31, 30, 29, 28, 27, 26].map { dateFromDay($0, month: 5, year: 2016) }
        let sixDaysBeforeSomeWednesdayExcludingWeekend = [31, 30, 27, 26, 25, 24].map { dateFromDay($0, month: 5, year: 2016) }

        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let billableDatesIncludingWeekend = calendar.previousDays(6, beforeDate: someWednesday, ignoreWeekends: false)
        let billableDatesExcludingWeekend = calendar.previousDays(6, beforeDate: someWednesday, ignoreWeekends: true)

        expect(billableDatesIncludingWeekend) == sixDaysBeforeSomeWednesday
        expect(billableDatesExcludingWeekend) == sixDaysBeforeSomeWednesdayExcludingWeekend
    }

}


// MARK: Helpers

private func dateFromDay(day: Int, month: Int, year: Int) -> NSDate {
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!

    let components = NSDateComponents()
    components.year = year
    components.month = month
    components.day = day

    return calendar.dateFromComponents(components)!
}
