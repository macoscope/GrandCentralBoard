//
//  BillingStatsFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class BillingStatsFetcher {
    private let dates: [NSDate]
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(account: String, accessToken: AccessToken, downloader: NetworkRequestManager, numberOfDays: Int) {
        self.dates = NSDate.arrayOfPreviousDays(numberOfDays)
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchBillingStats(completion: (Result<[DailyBillingStats]>) -> Void) {
        fetchBillingStats(dates, fetchedStats: [], completion: completion)
    }

    private func fetchBillingStats(dates: [NSDate], fetchedStats: [DailyBillingStats], completion: (Result<[DailyBillingStats]>) -> Void) {
        if (dates.count == 0) {
            return completion(.Success(fetchedStats))
        }

        var remainingDates = dates
        let date = dates.first!
        remainingDates.removeFirst()

        let dailyFetcher = DailyBillingStatsFetcher(date: date, account: account, accessToken: accessToken, downloader: downloader)
        dailyFetcher.fetchDailyBillingStats { result in
            switch result {
            case .Success(let dailyStats):
                var fetchedStats = fetchedStats
                fetchedStats.append(dailyStats)

                self.fetchBillingStats(remainingDates, fetchedStats: fetchedStats, completion: completion)

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}


extension NSDate {
    static func arrayOfPreviousDays(numberOfDays: Int) -> [NSDate] {
        return (1...numberOfDays).map({ index in
            return NSDate().dateDaysAgo(index)
        })
    }

    func dateDaysAgo(daysAgo: Int) -> NSDate {
        return dateWithDayOffset(-daysAgo)
    }

    func dateWithDayOffset(numberOfDays: Int) -> NSDate {
        let timeInterval = NSTimeInterval(numberOfDays * 24 * 3600)

        return self.dateByAddingTimeInterval(timeInterval)
    }
}