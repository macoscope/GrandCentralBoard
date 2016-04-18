//
//  DailyUserBillingStatsFetcher.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import GrandCentralBoardCore


final class DailyUserBillingStatsFetcher {
    private let date: NSDate
    private let userID: BillingUserID
    private let account: String
    private let accessToken: AccessToken
    private let downloader: NetworkRequestManager

    init(date: NSDate, userID: BillingUserID, account: String, accessToken: AccessToken, downloader: NetworkRequestManager) {
        self.date = date
        self.userID = userID
        self.account = account
        self.accessToken = accessToken
        self.downloader = downloader
    }

    func fetchDailyUserBillingStats(completion: (Result<DailyBillingStats>) -> Void) {
        downloader.requestJSON(.GET, url: url, parameters: [:], headers: headers, encoding: .URL, completion: { result in
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

    private var url: NSURL {
        let urlString = String(format: "https://%@.harvestapp.com/daily/%d/%d?of_user=%d", account, date.dayOfYear, date.year, userID)

        return NSURL(string: urlString)!
    }

    private var headers: [String: String] {
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
