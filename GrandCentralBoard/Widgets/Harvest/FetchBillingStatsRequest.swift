//
//  FetchBillingStatsRequest.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class FetchBillingStatsRequest {
    let dates: [NSDate]
    let account: String
    let accessToken: AccessToken
    let downloader: NetworkRequestManager

    init(account: String, accessToken: AccessToken, downloader: NetworkRequestManager, numberOfDays: Int) {
        self.dates = NSDate.lastNDays(numberOfDays)
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetch(completion: (Result<[DailyBillingStats]>) -> Void) {
        fetch(dates, fetchedStats: [], completion: completion)
    }

    private func fetch(dates: [NSDate], fetchedStats: [DailyBillingStats], completion: (Result<[DailyBillingStats]>) -> Void) {
        if (dates.count == 0) {
            return completion(.Success(fetchedStats))
        }

        var remainingDates = dates
        let date = dates.first!
        remainingDates.removeFirst()

        let dailyRequest = FetchDailyBillingStatsRequest(date: date, account: account, accessToken: accessToken, downloader: downloader)
        dailyRequest.fetch { result in
            switch result {
            case .Success(let dailyStats):
                var fetchedStats = fetchedStats
                fetchedStats.append(dailyStats)

                self.fetch(remainingDates, fetchedStats: fetchedStats, completion: completion)

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}


extension NSDate {
    static func lastNDays(numberOfDays: Int) -> [NSDate] {
        return (0..<numberOfDays).map({ index in
            return NSDate().dateDaysAgo(index)
        })
    }

    func dateDaysAgo(daysAgo: Int) -> NSDate {
        let timeInterval = NSTimeInterval(-daysAgo * 24 * 3600)

        return self.dateByAddingTimeInterval(timeInterval)
    }
}