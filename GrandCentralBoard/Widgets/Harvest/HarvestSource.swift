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
            let billableDates = BillableDates(
                referenceDate: today, numberOfPreviousDays: instance.numberOfPreviousDays, includeWeekends: instance.includeWeekends
            )
            instance.harvestAPI.fetchBillingStatsForDates(billableDates, completion: callback)
        }
    }
}
