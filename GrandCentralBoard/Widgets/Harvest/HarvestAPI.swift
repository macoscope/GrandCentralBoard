//
//  HarvestAPI.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-12.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore
import Alamofire


final class HarvestAPI {
    let account: String
    var oauthCredentials: OAuthCredentials
    let downloader: NetworkRequestManager = Alamofire.Manager.sharedInstance

    init(account: String, oauthCredentials: OAuthCredentials) {
        self.account = account
        self.oauthCredentials = oauthCredentials
    }

    func fetchBillingStats(completion: (GrandCentralBoardCore.Result<[DailyBillingStats]>) -> Void) {
        fetchBillingStats(datesToFetch(), fetchedStats: [], completion: completion)
    }

    func fetchBillingStats(dates: [NSDate], fetchedStats: [DailyBillingStats], completion: (GrandCentralBoardCore.Result<[DailyBillingStats]>) -> Void) {
        if (dates.count == 0) {
            return completion(.Success(fetchedStats))
        }

        var remainingDates = dates
        let date = dates.first!
        remainingDates.removeFirst()

        fetchDailyBillingStats(date) { (result: GrandCentralBoardCore.Result<DailyBillingStats>) -> Void in
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

    func fetchDailyBillingStats(date: NSDate, completion: (GrandCentralBoardCore.Result<DailyBillingStats>) -> Void) {
        downloader.requestJSON(.GET, url: dailyStatsURL(date), parameters: [:], headers: headers(), completion: { (result: ResultType<AnyObject, NSError>.result) -> Void in
            switch result {
            case .Success(let json):
                do {
                    let dailyStats = try DailyBillingStats.decode(json)
                    completion(.Success(dailyStats))

                } catch let error {
                    completion(.Failure(error))
                }

            case .Failure(let error):
                completion(.Failure(error))
            }
        })
    }

    func refreshTokenIfNeeded(completion: (GrandCentralBoardCore.Result<OAuthCredentials>) -> Void) {
        if (self.oauthCredentials.accessToken.isExpired()) {
            refreshToken(completion)

        } else {
            completion(.Success(self.oauthCredentials))
        }
    }

    func refreshToken(completion: (GrandCentralBoardCore.Result<OAuthCredentials>) -> Void) {
        let parameters = ["refresh_token": oauthCredentials.refreshToken,
                          "client_id": oauthCredentials.clientID,
                          "client_secret": oauthCredentials.clientSecret,
                          "grant_type": "refresh_token"]
        let headers = ["ContentType": "application/x-www-form-urlencoded"]

        downloader.requestJSON(.POST, url: refreshTokenURL(), parameters: parameters, headers: headers) { (result: ResultType<AnyObject, NSError>.result) -> Void in
            switch (result) {
            case .Success(let json):
                do {
                    let accessToken = try AccessToken.decode(json)
                    self.oauthCredentials.accessToken = accessToken
                    completion(.Success(self.oauthCredentials))

                } catch let error {
                    completion(.Failure(error))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }


// MARK: - Helper methods

    func headers() -> [String: String] {
        return ["Authorization": "Bearer " + oauthCredentials.accessToken.token, "Accept": "application/json"]
    }

    func datesToFetch() -> [NSDate] {
        let numberOfDays = 6

        return (0..<numberOfDays).map({ index in
            return NSDate().dateDaysAgo(index)
        })
    }

    func dailyStatsURL(date: NSDate) -> NSURL {
        let dailyStatsBaseURL = NSURL(string: String(format: "https://%@.harvestapp.com/daily", account))!

        return dailyStatsBaseURL.URLByAppendingPathComponent(String(date.dayOfYear)).URLByAppendingPathComponent(String(date.year))
    }

    func refreshTokenURL() -> NSURL {
        return NSURL(string: String(format: "https://%@.harvestapp.com/oauth2/token", account))!
    }
}


extension NSDate {
    var gregorianCalendar: NSCalendar {
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    }

    var dayOfYear: Int {
        return gregorianCalendar.ordinalityOfUnit(.Day, inUnit: .Year, forDate: self)
    }

    var year: Int {
        return gregorianCalendar.component(.Year, fromDate: self)
    }

    func dateDaysAgo(daysAgo: Int) -> NSDate {
        let timeInterval = NSTimeInterval(-daysAgo * 24 * 3600)

        return self.dateByAddingTimeInterval(timeInterval)
    }
}
