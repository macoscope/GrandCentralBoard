//
//  DailyBillingStatsFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GCBCore


final class DailyBillingStatsFetcher {
    private let projectIDs: [BillingProjectID]
    private let date: NSDate
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(projectIDs: [BillingProjectID], date: NSDate, account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.projectIDs = projectIDs
        self.date = date
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchDailyBillingStats(completion: (Result<DailyBillingStats>) -> Void) {
        self.fetchRawDailyBillingStats(projectIDs, json:[]) { result in
            switch result {
            case .Success(let jsonEntries):
                do {
                    let json = ["day_entries": jsonEntries.flatMap { $0["day_entry"] }, "for_day": self.date.stringWithFormat("yyyy-MM-dd")]
                    let dailyBillingStats = try DailyBillingStats.decode(json)
                    completion(.Success(dailyBillingStats))

                } catch let error {
                    completion(.Failure(error))
                }

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }

    private func fetchRawDailyBillingStats(projectIDs: [BillingProjectID], json: [AnyObject], completion: (Result<[AnyObject]>) -> Void) {
        guard let projectID = projectIDs.first else {
            return completion(.Success(json))
        }

        let dailyUserStatsFetcher = DailyProjectBillingStatsFetcher(date: date, projectID: projectID, account: account,
                                                                    accessToken: accessToken, downloader: downloader)

        dailyUserStatsFetcher.fetchDailyProjectBillingStats { result in
            switch result {
            case .Success(let resultJSON):
                let remainingProjectIDs = Array(projectIDs.dropFirst())
                let mergedJSON = json + resultJSON

                self.fetchRawDailyBillingStats(remainingProjectIDs, json: mergedJSON, completion: completion)

            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}
