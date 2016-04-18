//
//  DailyBillingStatsFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class DailyBillingStatsFetcher {
    private let date: NSDate
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(date: NSDate, account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.date = date
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchDailyBillingStats(completion: (Result<DailyBillingStats>) -> Void) {
        let userFetcher = BillingUserListFetcher(account: account, accessToken: accessToken, downloader: downloader)
        userFetcher.fetchUserList { result in
            switch result {
            case .Success(let userIDs):
                self.fetchDailyBillingStats(userIDs, dailyBillingStats: DailyBillingStats.emptyStats(), completion: completion)

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    func fetchDailyBillingStats(userIDs: [BillingUserID], dailyBillingStats: DailyBillingStats, completion: (Result<DailyBillingStats>) -> Void) {
        guard let userID = userIDs.first else {
            return completion(.Success(dailyBillingStats))
        }

        let dailyUserStatsFetcher = DailyUserBillingStatsFetcher(date: date, userID: userID, account: account, accessToken: accessToken, downloader: downloader)

        dailyUserStatsFetcher.fetchDailyUserBillingStats { result in
            switch result {
            case .Success(let dailyUserBillingStats):
                let remainingUserIDs = Array(userIDs.dropFirst())
                let mergedDailyBillingStats = dailyBillingStats.merge(dailyUserBillingStats)

                self.fetchDailyBillingStats(remainingUserIDs, dailyBillingStats: mergedDailyBillingStats, completion: completion)

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}
