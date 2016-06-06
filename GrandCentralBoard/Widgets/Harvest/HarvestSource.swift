//
//  HarvestSource.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore


final class HarvestSource: Asynchronous {
    typealias ResultType = Result<[DailyBillingStats]>
    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary
    let harvestAPI: HarvestAPIProviding
    let numberOfPreviousDays: Int
    let includeWeekends: Bool

    init(apiProvider: HarvestAPIProviding, refreshInterval: NSTimeInterval, numberOfPreviousDays: Int, includeWeekends: Bool) {
        harvestAPI = apiProvider
        interval = refreshInterval
        self.numberOfPreviousDays = numberOfPreviousDays
        self.includeWeekends = includeWeekends
    }

    func read(callback: (ResultType) -> Void) {
        harvestAPI.refreshTokenIfNeeded { [weak self] _ in
            guard let instance = self else { return }

            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let billableDates = calendar.previousDays(instance.numberOfPreviousDays, beforeDate: today, ignoreWeekends: !instance.includeWeekends)
            instance.harvestAPI.fetchBillingStatsForDates(billableDates, completion: callback)
        }
    }
}


extension NSCalendar {

    public func previousDays(numberOfDays: Int, beforeDate referenceDate: NSDate, ignoreWeekends: Bool = false) -> [NSDate] {
        var previousDays: [NSDate] = []
        var date = referenceDate

        while previousDays.count < numberOfDays {
            date = date.dateDaysAgo(1)

            if ignoreWeekends {
                if !isDateInWeekend(date) {
                    previousDays.append(date)
                }

            } else {
                previousDays.append(date)
            }
        }

        return previousDays
    }
}
