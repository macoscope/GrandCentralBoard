//
//  FetchDailyBillingStatsRequest.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-14.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class FetchDailyBillingStatsRequest {
    let date: NSDate
    let account: String
    let accessToken: AccessToken
    let downloader: NetworkRequestManager

    init(date: NSDate, account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.date = date
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetch(completion: (Result<DailyBillingStats>) -> Void) {
        downloader.requestJSON(.GET, url: url, parameters: [:], headers: headers, completion: { (result: ResultType<AnyObject, NSError>.result) -> Void in
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

    var url: NSURL {
        let dailyStatsBaseURL = NSURL(string: String(format: "https://%@.harvestapp.com/daily", account))!

        return dailyStatsBaseURL.URLByAppendingPathComponent(String(date.dayOfYear)).URLByAppendingPathComponent(String(date.year))
    }

    var headers: [String: String] {
        return ["Authorization": "Bearer " + accessToken.token, "Accept": "application/json"]
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
}


